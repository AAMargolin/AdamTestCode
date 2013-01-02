require(synapseClient)
require(predictiveModeling)

crossValidatePredictiveModel_synapse <- function(modelDataSynapseId, model, ...){
  modelDataEntity <- loadEntity(modelDataSynapseId)
  modelData <- modelDataEntity$objects$functionResult
  res <- crossValidatePredictiveModel(modelData$featureData, modelData$responseData, model=model)
  return(res)
}
