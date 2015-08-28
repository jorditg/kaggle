require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator

----------------------------------------------------------------------
-- parse command line arguments
if not opt then
   print '==> processing options'
   cmd = torch.CmdLine()
   cmd:text()
   cmd:text('Retine Dataset Preprocessing')
   cmd:text()
   cmd:text('Options:')
   cmd:option('-size', 'small', 'how many samples do we load: small | full | extra')
   cmd:option('-visualize', true, 'visualize input data and weights during training')
   cmd:text()
   opt = cmd:parse(arg or {})
end

train_file = 'train_256x256.th7'
test_file = 'test_256x256.th7'

----------------------------------------------------------------------
-- training/test size

trsize = 20000
tesize = 2000

----------------------------------------------------------------------
print '==> loading dataset'

-- We load the dataset from disk, and re-arrange it to be compatible
-- with Torch's representation. Matlab uses a column-major representation,
-- Torch is row-major, so we just have to transpose the data.

-- Note: the data, in X, is 4-d: the 1st dim indexes the samples, the 2nd
-- dim indexes the color channels (RGB), and the last two dims index the
-- height and width of the samples.

loaded = torch.load(train_file,'ascii')
trainData = {
   data = loaded.X,
   labels = loaded.y,
   size = function() return trsize end
}

-- Finally we load the test data.

loaded = torch.load(test_file,'ascii')
testData = {
   data = loaded.X,
   labels = loaded.y,
   size = function() return tesize end
}

----------------------------------------------------------------------
print '==> preprocessing data'

-- Preprocessing requires a floating point representation (the original
-- data is stored on bytes). Types can be easily converted in Torch, 
-- in general by doing: dst = src:type('torch.TypeTensor'), 
-- where Type=='Float','Double','Byte','Int',... Shortcuts are provided
-- for simplicity (float(),double(),cuda(),...):

trainData.data = trainData.data:float()
testData.data = testData.data:float()

-- We now preprocess the data. Preprocessing is crucial
-- when applying pretty much any kind of machine learning algorithm.

print '==> preprocessing data:'
for i = 1,trainData:size() do
   mean = trainData.data[i, 1, {}, {}]:mean()
   std =  trainData.data[i, 1, {}, {}]:std()
   trainData.data[i, 1, {}, {}]:add(-mean)
   trainData.data[i, 1, {}, {}]:div(std)
end
for i = 1,testData:size() do
   mean = testData.data[i, 1, {}, {}]:mean()
   std =  testData.data[i, 1, {}, {}]:std()
   testData.data[i, 1, {}, {}]:add(-mean)
   testData.data[i, 1, {}, {}]:div(std)
end


----------------------------------------------------------------------
print '==> verify statistics'

-- It's always good practice to verify that data is properly
-- normalized.

for i,channel in ipairs(channels) do
   trainMean = trainData.data[{ {},i }]:mean()
   trainStd = trainData.data[{ {},i }]:std()

   testMean = testData.data[{ {},i }]:mean()
   testStd = testData.data[{ {},i }]:std()

   print('training data, '..channel..'-channel, mean: ' .. trainMean)
   print('training data, '..channel..'-channel, standard deviation: ' .. trainStd)

   print('test data, '..channel..'-channel, mean: ' .. testMean)
   print('test data, '..channel..'-channel, standard deviation: ' .. testStd)
end

----------------------------------------------------------------------
print '==> visualizing data'

-- Visualization is quite easy, using itorch.image().

if opt.visualize then
   if itorch then
   first256Samples = trainData.data[{ {1,256},1 }]
   itorch.image(first256Samples)
   else
      print("For visualization, run this script in an itorch notebook")
   end
end

