require(synapseClient)
require(predictiveModeling)
require(devtools)

crossValidatePredictiveModel_synapse <- function(modelDataSynapseId, model, ...){
  modelDataEntity <- loadEntity(modelDataSynapseId)
  modelData <- modelDataEntity$objects$functionResult
  if(class(model) == "Code"){
    model <- source_url(modelCodeEntity$annotations$githubURL)$value$new()
  }
  res <- crossValidatePredictiveModel(modelData$featureData, modelData$responseData, model=model)
  return(res)
}
