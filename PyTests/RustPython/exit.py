from testutils import assert_raises

# VIOLET: 'exit' and 'quit' are added by 'site', which we don't have (see: https://docs.python.org/3.8/library/constants.html#quit)
# with assert_raises(SystemExit):
#     exit()

# with assert_raises(SystemExit):
#     exit(None)

# with assert_raises(SystemExit):
#     exit(1)

# with assert_raises(SystemExit):
#     exit("AB")

# with assert_raises(SystemExit):
#     quit()

# with assert_raises(SystemExit):
#     quit(None)

# with assert_raises(SystemExit):
#     quit(1)

# with assert_raises(SystemExit):
#     quit("AB")

import sys

with assert_raises(SystemExit):
    sys.exit()

with assert_raises(SystemExit):
    sys.exit(None)

with assert_raises(SystemExit):
    sys.exit(1)

with assert_raises(SystemExit):
    sys.exit("AB")
