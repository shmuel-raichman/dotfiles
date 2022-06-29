#!/usr/bin/env python
# B"H

# echo -e "\u001b[38;5;${ID}m"
# ID is the number printed in color

import sys

prompt="shmuel@L2004"

for i in range(0, 16):
    for j in range(0, 16):
        code = str(i * 16 + j)
        sys.stdout.write(u"\u001b[38;5;" + code + " m" + code.ljust(4) + "-" + prompt)
    print (u"\u001b[0m")
