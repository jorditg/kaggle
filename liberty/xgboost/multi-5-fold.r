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



set.seed(39724316)

# The competition datafiles are in the directory ../input
# Read competition data files:
train <- read.csv("../data/train-randomized.csv")
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
num_rounds <- 2000
folds <- 5

rows <- nrow(train_x)
split <- floor(rows/folds)

# Set xgboost test and training and validation datasets
xgtest <- xgb.DMatrix(data = test_x)

ypred <- rep(0, times=nrow(test_x))
ypredtrall <- rep(0, times=nrow(train_x))

paramList <- read.csv("params.csv")

outdata_te <- list("Id" = test_Id)
outdata_tr <- list("Id" = train_Id)
outdata_tr[["Hazard"]] <- train_y
for (par in 1:nrow(paramList)) 
{
  # Set xgboost parameters
  param <- list("objective" = "reg:linear",
                "eta" = paramList$eta[par],
                "min_child_weight" = paramList$min_child_weight[par],
                "subsample" = paramList$subsample[par],
                "colsample_bytree" = paramList$colsample_bytree[par],
                "scale_pos_weight" = 1.0,
                "max_depth" = paramList$max_depth[par])

  for (fold in 1:folds) 
  {
    from <- (fold-1)*split + 1
    to <- from + split
  
    xgtrain <- xgb.DMatrix(data = train_x[-(from:to),], label= train_y[-(from:to)])
    xgval <-  xgb.DMatrix(data = train_x[from:to,], label= train_y[from:to])

    # setup watchlist to enable train and validation, validation must be first for early stopping
    watchlist <- list(val=xgval, train=xgtrain)

    # Now fit again but this time evaulate using Normalized Gini
    bst2 <- xgb.train(params = param, 
                      data = xgtrain, 
                      feval = evalgini, 
                      nround=num_rounds,              
                      print.every.n = 20, 
                      watchlist=watchlist, 
                      early.stop.round = 50, 
                      maximize = TRUE)

    bst2$bestScore
    bst2$bestInd

    ypred <- ypred + predict(bst2, xgtest)
    ypredtrall[from:to] <- predict(bst2, xgval)
  }

  ypred <- ypred / folds

  outdata_te[[paste("H",par,sep="")]] <- ypred
  outdata_tr[[paste("H",par,sep="")]] <- ypredtrall
}

print ('finish training')

outfile_te <- 'test-results.csv'
write.csv(outdata_te, file = outfile_te, quote=FALSE, row.names=FALSE)

outfile_tr <- 'train-results.csv'
write.csv(outdata_tr, file = outfile_tr, quote=FALSE, row.names=FALSE)

