
cclAnalysisTest <- function(featureDataId, responseDataId, className, drugId){
  
  featureDataEntity <- loadEntity(featureDataId)
  featureData <- featureDataEntity$objects[[1]]
  featureData <- exprs(featureData)
  featureData <- t(featureData)
  
  responseDataEntity <- loadEntity(responseDataId)
  responseData <- responseDataEntity$objects[[1]]
  responseData <- responseData[, drugId, drop=FALSE]
  
  responseData <- responseData[which(!is.na(responseData)), , drop=FALSE]
  
  commonCellLines <- intersect(rownames(featureData), rownames(responseData))
  
  featureData_new <- featureData[commonCellLines,]
  responseData_new <- responseData[commonCellLines, ,drop=FALSE]
  responseData_new <- scale(responseData_new)
  
  featureData_new <- featureData_new[,1:1000]
  featureData_new <- scale(featureData_new)
  
  model <- new(className)
  model$customTrain(featureData_new, responseData_new)
  
  predictions <- model$customPredict(featureData_new)
  
  return(predictions)
}
