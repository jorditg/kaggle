
require 'torch'

----------------------------------------------------------------------
print('==> switching to floats')
torch.setdefaulttensortype('torch.FloatTensor')
torch.setnumthreads(6)
torch.manualSeed(335653)

----------------------------------------------------------------------
print '==> executing all'

dofile '1_data.lua'
dofile '2_model.lua'
dofile '3_loss.lua'
dofile '4_train.lua'
dofile '5_test.lua'

----------------------------------------------------------------------
print '==> training!'

while true do
   train()
   test()
end

