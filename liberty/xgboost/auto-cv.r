# You can write R code here and then click "Run" to run it on our platform

# The readr library is the best way to read and write CSV files in R
library(xgboost)
library(data.table)
library(Matrix)

# build Gini functions for use in custom xgboost evaluation metric
SumModelGini <- function(solution, submission) {
  df = data.frame(solution = solution, submission = submission)
  df <- df[order(df$submission, decreasing = TRUE),]
  df$random = (1:nrow(df))/nrow(df)
  totalPos <- sum(df$solution)
  df$cumPosFound <- cumsum(df$solution) # this will store the cumulative number of positive examples found (used for computing "Model Lorentz")
  df$Lorentz <- df$cumPosFound / totalPos # this will store the cumulative proportion of positive examples found ("Model Lorentz")
  df$Gini <- df$Lorentz - df$random # will store Lorentz minus random
  return(sum(df$Gini))
}

NormalizedGini <- function(solution, submission) {
  SumModelGini(solution, submission) / SumModelGini(solution, solution)
}

# wrap up into a function to be called within xgboost.train
evalgini <- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  err <- NormalizedGini(as.numeric(labels),as.numeric(preds))
  return(list(metric = "Gini", value = err))
}


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
train_x <- sparse.model.matrix(~., data = train_x)

# predictor variables from test
test_x <- subset(test, select = -c(Id))
test_x <- sparse.model.matrix(~., data = test_x)

# Using 5000 rows for early stopping. 
offset <- 5000
num_rounds <- 2000


for (i in 1:100000)
{
# Set xgboost test and training and validation datasets
xgtest <- xgb.DMatrix(data = test_x)
xgtrain <- xgb.DMatrix(data = train_x[offset:nrow(train_x),], label= train_y[offset:nrow(train_x)])
xgval <-  xgb.DMatrix(data = train_x[1:offset,], label= train_y[1:offset])

# setup watchlist to enable train and validation, validation must be first for early stopping
watchlist <- list(val=xgval, train=xgtrain)
# to train with watchlist, use xgb.train, which contains more advanced features

# Set xgboost parameters
eta <- runif(1,min=0.001,max=0.06)
min_child_weight <- floor(runif(1,min=3,max=10))
subsample <- runif(1,min=0.75,max=0.95)
colsample <- runif(1,min=0.75,max=0.95)
max_depth <- floor(runif(1,min=3,max=12))
param <- list("objective" = "reg:linear",
              "eta" = eta,
              "min_child_weight" = min_child_weight,
              "subsample" = subsample,
              "colsample_bytree" = colsample,
              "scale_pos_weight" = 1.0,
              "max_depth" = max_depth,
              threads=8)

# Now fit again but this time evaulate using Normalized Gini
bst2 <- xgb.train(params = param, data = xgtrain, feval = evalgini, nround=num_rounds, print.every.n = 1000, watchlist=watchlist, early.stop.round = 50, maximize = TRUE)

write(c(paste(bst2$bestScore, bst2$bestInd, eta, min_child_weight, subsample, colsample, max_depth)), file = "output.txt", append = TRUE)

}


