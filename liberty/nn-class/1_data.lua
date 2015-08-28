require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator

train_file = '../data/train-220-features-5-classes.th7'

----------------------------------------------------------------------
print '==> loading dataset'


trainData = torch.load(train_file)

--testData = torch.load(test_file)

testData = {
   data = trainData.data[{{1,100},1,1,{}}],
   labels = trainData.labels[{{1,100}}]
}
function testData:size() return self.data:size()[1] end


trsize = trainData:size()
tesize = testData:size()

