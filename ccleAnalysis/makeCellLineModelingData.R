require(synapseClient)
require(predictiveModeling)

makeCellLineModelingData <- function(featureDataIdList, responseDataId, compound){
  ########### load the Synapse entities corresponding to the feature data and store them ###################
  ########### in a list ##########################
  featureDataList <- list()
  for (featureDataName in names(featureDataIdList)){
    featureDataEntity <- loadEntity(featureDataIdList[[featureDataName]])
    featureDataList[[featureDataName]] <- featureDataEntity$objects[[1]]
  }
  
  featureData <- createAggregateFeatureDataSet(featureDataList)
  
  ######### transpose data so features are on columns ##############
  featureData <- t(featureData)
  
  ######### load repsonse data and extract the vector corresponding to the given drug #############
  responseDataEntity <- loadEntity(responseDataId)
  responseDataMatrix <- responseDataEntity$objects[[1]]
  responseData <- responseDataMatrix[, compound, drop=TRUE]
  
  ############# pre process data to prepare for precitive modeling ######################
  ############# may want to streamline ######################
  featureData <- filterNasFromMatrix(featureData, filterBy="columns")
  featureAndResponseDataList <- createFeatureAndResponseDataList(featureData, responseData)
  filteredDataList <- filterPredictiveModelData(featureAndResponseDataList$featureData, featureAndResponseDataList$responseData, 
                                                featureVarianceThreshold = 0.01, corPValThresh = 0.1)
  filteredFeatureData  <- filteredDataList$featureData
  filteredFeatureData  <- t(unique(t(filteredFeatureData)))
  filteredResponseData <- filteredDataList$responseData
  
  ## scale these data   
  filteredFeatureDataScaled <- scale(filteredFeatureData)
  ########### converts to vector with [,] ####################
  filteredResponseDataScaled <- scale(filteredResponseData)[,]
  
  retVal <- list(featureData = filteredFeatureDataScaled, responseData = filteredResponseData)
  return(retVal)
}
