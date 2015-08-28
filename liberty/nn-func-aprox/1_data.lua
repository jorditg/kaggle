require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator

----------------------------------------------------------------------

test_size = 5000
train_file = '../data/train96.th7'
--test_file = '../test.th7'
features = 95

----------------------------------------------------------------------
print '==> loading dataset'

dat = torch.load(train_file)
--testData = torch.load(test_file)

--mean = dat.labels[{{}}]:mean()
--std = dat.labels[{ {}}]:std()
--dat.labels:add(-mean)
--dat.labels:div(std)
--print('Hazard' .. ' ' .. mean .. ' ' .. std)

feature = 1
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 2
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)


feature = 3
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)


feature = 32
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)


feature = 47
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)


feature = 74
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 75
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 77
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 83
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 84
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 86
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 87
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 94
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

feature = 95
mean = dat.data[{ {},1,1,feature }]:mean()
std = dat.data[{ {},1,1,feature }]:std()
dat.data[{ {},1,1,feature }]:add(-mean)
dat.data[{ {},1,1,feature }]:div(std)
print(feature .. ' ' .. mean .. ' ' .. std)

len = dat:size()

trainData = {
   data = dat.data[{{test_size + 1,len},1,1,{}}],
   labels = dat.labels[{{test_size + 1,len}}]
}
function trainData:size() return self.data:size()[1] end

testData = {
   data = dat.data[{{1,test_size},1,1,{}}],
   labels = dat.labels[{{1,test_size}}]
}
function testData:size() return self.data:size()[1] end


trsize = trainData:size()
tesize = testData:size()

----------------------------------------------------------------------
