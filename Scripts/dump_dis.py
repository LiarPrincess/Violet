import dis

if __name__ == '__main__':
  # if len(sys.argv) < 2:
  #   print("Usage: 'python3 dump_dis.py [FILE]'")
  #   sys.exit(1)

  # filename = sys.argv[1]
  # code = open(filename).read()

  code = '''
class FROZEN():
  def ELSA():
    ELSA
'''

  print(code)
  dis.dis(code)
