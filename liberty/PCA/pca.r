library(Matrix)

# The competition datafiles are in the directory ../input
# Read competition data files:
train <- read.csv("../data/train.csv")
test <- read.csv("../data/test.csv")

# Generate output files with write_csv(), plot() or ggplot()
# Any files you write to the current directory get shown as outputs

# keep copy of ID variables for test and train data
train_Id <- train$Id
test_Id <- test$Id

# response variable from training data
train_y <- train$Hazard



# predictor variables from training
train_x <- subset(train, select = -c(Id, Hazard))
test_x <- subset(test, select = -c(Id))

all <- rbind(train_x, test_x)

all <- sparse.model.matrix(~., data = all)


# detect 0 variance columns
#v=apply(test_x,2,var)

# first column of train_x and test_x is constant, so we remove it
cols <- dim(all)[2]

all <- all[,2:cols]

prc <- prcomp(all, center=TRUE, scale=TRUE)

summary(prc)

# get the 70 PCA of all the data
all_pca <- prc$x[,1:70]

write.csv(all_pca[1:nrow(train_x),], 'train_pca70.csv')
write.csv(all_pca[(nrow(train_x)+1):nrow(all),], 'test_pca70.csv')


