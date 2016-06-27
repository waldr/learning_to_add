from __future__ import division
import numpy as np
from matplotlib import pyplot as plt

import os
import re

# NOCARRY 0/1
# PADDING 0/1
# INVERT  0/1
#
# Baseline: 000

PATH_ROOT = os.path.curdir

exps = {'000' : os.path.join(PATH_ROOT, 'sum_exp_full_000.txt'),
        '001' : os.path.join(PATH_ROOT, 'sum_exp_full_001.txt'),
        '010' : os.path.join(PATH_ROOT, 'sum_exp_full_010.txt'),
        '011' : os.path.join(PATH_ROOT, 'sum_exp_full_011.txt'),
        '100' : os.path.join(PATH_ROOT, 'sum_exp_full_100.txt'),
        '101' : os.path.join(PATH_ROOT, 'sum_exp_full_101.txt'),
        '110' : os.path.join(PATH_ROOT, 'sum_exp_full_110.txt'),
        '111' : os.path.join(PATH_ROOT, 'sum_exp_full_111.txt')}


def get_accs(exp_path):
    with open(exp_path, 'r') as f:  
        lines = f.readlines()
    
    lines = filter(lambda s : s.startswith('epoch='), lines)
    
    lines = map(lambda s : re.compile('[\d]?[\d]?\d.\d\d%').findall(s),
                lines)
    
    values = map(lambda x : map(lambda s : float(s[:-1]),
                                x),
                 lines)
    values = np.array(values)

    return values


def get_difficulty_changes(exp_path):
    with open(exp_path, 'r') as f:
        lines = f.readlines()

    lines = filter(lambda s : s.startswith('epoch='), lines)

    lines = [re.compile('current length=[\d]?[\d]').findall(s)[0]
             for s in lines]

    lines = [int(s[s.find('=') + 1 : ]) for s in lines]
   
    length = 1
    pos = []
    for i, n in enumerate(lines):
        if n > length:
            pos.append(i)
            length = n
    
    return pos
     

def get_final_test_acc(exp_path):
    with open(exp_path, 'r') as f:  
        lines = f.readlines()
    
    accs_s = [s for s in lines if s.startswith('Test accuracy')]
    accs = [float(s[s.find('=') + 1: s.find('%')]) for s in accs_s] 
    
    return np.mean(accs), np.std(accs)


fig, ax = plt.subplots() 
for exp_code, path in sorted(exps.items()):
    accs = get_accs(path)[:, 2]
    pchanges = get_difficulty_changes(path)

    ax.plot(accs, label=exp_code)
    ax.scatter(pchanges, accs[pchanges], marker='*', color='r')

ax.set_xlabel('Iteration')
ax.set_ylabel('Test accuracy')
ax.legend()

accs = [get_final_test_acc(i[1]) for i in sorted(exps.items())]
accs = np.array(accs)

fig, ax = plt.subplots()
width = 0.5
ind = np.arange(len(accs))
rects = ax.bar(ind, accs[:,0], width, yerr=accs[:,1],
               color='gold', align='center')
ax.set_ylabel('Accuracy on target length + 1')
ax.set_xlabel('Experiment')
ax.set_xticks([rect.get_x() + width/2 for rect in rects])
ax.set_xticklabels(sorted(exps.keys()))
ax.set_ylim((0, 100))

for rect in rects:
    height = rect.get_height()
    ax.text(rect.get_x() + rect.get_width()/2., height + 1,
            '%.2f' % height,
            ha='center', va='bottom')

plt.show()

