import sys 

fpath = "out_blend.txt"
if len(sys.argv) > 1:
    fpath = sys.argv[1]

# Color codes:
RESET = "\033[0;0m"
RED = "\033[0;31m"
GREEN = "\033[0;32m"

start = 14 # starting index for the integer representation

pred_prefix = "\tPrediction:  "

with open(fpath, 'r') as f:
    lines = f.readlines()

for i in xrange(1, len(lines)):
    
    if lines[i].startswith("\tPrediction"):
        spred = lines[i][start:]
        stgt = lines[i - 1][start:]
    
        pred2 = ""
        for j, c in enumerate(spred):
            if c == "\n":
                pred2 += (RESET + "\n")
                break
            if c == stgt[j]:
                pred2 += (GREEN + c)
            else:
                pred2 += (RED + c)
        lines[i] = pred_prefix + pred2

for line in lines:
    print(line[:-1]) # remove extra '\n'

