Learning to Add
===================


This code is based on the following repository:
https://github.com/wojciechz/learning_to_execute 

You might also want to read their paper:
http://arxiv.org/abs/1410.4615


Our objective here is to gain some insight into the limitations of
 using a Recurrent Neural Network with LSTM units to solve a simple
algorithmic task: integer addition.

The model is a character-based RNN that maps integer sum expressions of the form
print(\<integer operand\>+\<integer operand\>) to the output, which is an integer
representing the result of the operation.

We use the default parameters as defined in the original code, with the 
combined/blend curriculum learning strategy. The network is trained with
integer pairs up to 8 characters long. We then test generalization
by running tests on pairs that are up to 9 characters long.


Our experiments examine the influences of 3 factors:

1. No carry: 0 (false) / 1 (true)
2. Zero padding: 0 (false) / 1 (true)
3. Input inversion (change "endianess" of operands): 0 (false) / 1 (true)


By encoding the experiments with 3 bits, we have, for example, the following experiment codes:

* 000: Baseline ("carry" can happen, no padding, usual operand representation)
* 010: Zero padding
* 111: No carry, zero padding, inverted operands


Scripts for processing the output are also provided.


Execution
=========

All 8 experiments can be executed sequentially on a GPU by calling:

  `runall.sh`

This will generate files that document the evolution of accuracy during training,
and show some exemplary predictions.
These files can then be used to plot graphs summarizing the results:

  `cd out ; python2 plots.py`
 
You can also generate color-highlighted versions of the output files
 to more easily check on which characters prediction fails. Run:

  `cd out ; ./colorify-all.sh *.txt colored-out`

