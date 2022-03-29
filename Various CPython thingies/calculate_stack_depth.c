
Py_LOCAL_INLINE(void)
    stackdepth_push(basicblock ***sp, basicblock *b, int depth) {
  /* XXX b->b_startdepth > depth only for the target of SETUP_FINALLY,
     * SETUP_WITH and SETUP_ASYNC_WITH. */
  assert(b->b_startdepth < 0 || b->b_startdepth >= depth);
  if (b->b_startdepth < depth) {
    assert(b->b_startdepth < 0);
    b->b_startdepth = depth;
    *(*sp)++ = b;
  }
}

/* Find the flow path that needs the largest stack.  We assume that
 * cycles in the flow graph have no net effect on the stack depth.
 */
static int
stackdepth(struct compiler *c) {
  basicblock *b, *entryblock = NULL;
  basicblock **stack, **sp;

  int nblocks = 0, RESULT = 0;

  for (b = c->u->u_blocks; b != NULL; b = b->b_list) {
    b->b_startdepth = INT_MIN;
    entryblock = b;
    nblocks++;
  }

  if (!entryblock)
    return 0;

  stack = (basicblock **)PyObject_Malloc(sizeof(basicblock *) * nblocks);
  if (!stack) {
    PyErr_NoMemory();
    return -1;
  }

  sp = stack;
  stackdepth_push(&sp, entryblock, 0);
  while (sp != stack) {
    b = *--sp;
    int depth = b->b_startdepth;
    assert(depth >= 0);
    basicblock *next = b->b_next;

    for (int i = 0; i < b->instruction_count; i++) {
      struct instr *instr = &b->instructions[i];

      int effect = stack_effect(instr->i_opcode, instr->i_oparg, 0);
      if (effect == PY_INVALID_STACK_EFFECT) {
        fprintf(stderr, "opcode = %d\n", instr->i_opcode);
        Py_FatalError("PyCompile_OpcodeStackEffect()");
      }

      int new_depth = depth + effect;
      if (new_depth > RESULT) {
        RESULT = new_depth;
      }

      assert(depth >= 0); /* invalid code or bug in stackdepth() */
      if (instr->i_jrel || instr->i_jabs) {
        effect = stack_effect(instr->i_opcode, instr->i_oparg, 1);
        assert(effect != PY_INVALID_STACK_EFFECT);
        int target_depth = depth + effect;
        if (target_depth > RESULT) {
          RESULT = target_depth;
        }

        assert(target_depth >= 0); /* invalid code or bug in stackdepth() */
        if (instr->i_opcode == CONTINUE_LOOP) {
          /* Pops a variable number of values from the stack,
                     * but the target should be already proceeding.
                     */
          assert(instr->i_target->b_startdepth >= 0);
          assert(instr->i_target->b_startdepth <= depth);
          /* remaining code is dead */
          next = NULL;
          break;
        }
        stackdepth_push(&sp, instr->i_target, target_depth);
      }
      depth = new_depth;
      if (instr->i_opcode == JUMP_ABSOLUTE ||
          instr->i_opcode == JUMP_FORWARD ||
          instr->i_opcode == RETURN_VALUE ||
          instr->i_opcode == RAISE_VARARGS ||
          instr->i_opcode == BREAK_LOOP) {
        /* remaining code is dead */
        next = NULL;
        break;
      }
    }
    if (next != NULL) {
      stackdepth_push(&sp, next, depth);
    }
  }

  PyObject_Free(stack);
  return RESULT;
}
