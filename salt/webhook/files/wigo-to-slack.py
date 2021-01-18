#!/usr/bin/env python3

import sys

TEST_FILE = "/tmp/test-wigo-to-slack.txt"


def main(argv):
    if len(argv) < 2:
        print("Missing arguments!")
        sys.exit(1)
    with open(TEST_FILE, 'w') as tf:
        tf.write(argv)
        tf.close()


if "__name__" == "__main__":
    main(sys.argv)
