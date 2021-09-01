# Violet

`Violet` is the main main executable inside Violet project (duh…).

## Usage

```
USAGE: Violet <options>

ARGUMENTS:
  <script>                execute the code contained in script (terminates
                          option list)

OPTIONS:
  -help, -h, --help       print this help message and exit (also --help)
  -V, --version           print the Python version number and exit (also
                          --version)
  -d                      debug output messages; also PYTHONDEBUG=x
  -q                      don't print version and copyright messages on
                          interactive startup
  -i                      inspect interactively after running script; forces a
                          prompt even if stdin does not appear to be a
                          terminal; also PYTHONINSPECT=x
  -E                      ignore PYTHON* environment variables (such as
                          PYTHONPATH)
  -I                      isolate Violet from the user's environment (implies
                          -E)
  -v                      Print a message each time a module is initialized,
                          showing the place (filename or built-in module) from
                          which it is loaded. When given twice (-vv), print a
                          message for each file that is checked for when
                          searching for a module. Also provides information on
                          module cleanup at exit. See also PYTHONVERBOSE.
  -O                      remove assert and __debug__-dependent statements;
                          also PYTHONOPTIMIZE=x
  -OO                     do -O changes and also discard docstrings (overrides
                          '-O' if it is also set)
  -Wd, -Wdefault          warning control; warn once per call location; also
                          PYTHONWARNINGS=arg
  -We, -Werror            warning control; convert to exceptions; also
                          PYTHONWARNINGS=arg
  -Wa, -Walways           warning control; warn every time; also
                          PYTHONWARNINGS=arg
  -Wm, -Wmodule           warning control; warn once per calling module; also
                          PYTHONWARNINGS=arg
  -Wo, -Wonce             warning control; warn once per Python process; also
                          PYTHONWARNINGS=arg
  -Wi, -Wignore           warning control; never warn; also PYTHONWARNINGS=arg
  -b                      issue warning about str(bytes_instance),
                          str(bytearray_instance) and comparing bytes/bytearray
                          with str.
  -c <c>                  program passed in as string (terminates option list)
  -m <m>                  run library module as a script (terminates option
                          list)%
```
