require 'torch'   -- torch
require 'nn'      -- provides all sorts of loss functions

----------------------------------------------------------------------
-- 5-class problem
noutputs = 2

----------------------------------------------------------------------
print '==> define loss'

criterion = nn.ClassNLLCriterion()

----------------------------------------------------------------------
print '==> here is the loss function:'
print(criterion)
