require(synapseClient)
require(predictiveModeling)
require(rGithubClient)

repository <- getRepo(repository="/AAMargolin/AdamTestCode")
sourceRepoFile(repository, "ccleAnalysis/makeCellLineModelingData.R")
sourceRepoFile(repository, "ccleAnalysis/crossValidatePredictiveModel_synapse.R")
sourceRepoFile(repository, "synapseExecute/synapseExecute.R")
sourceRepoFile(repository, "synapseExecute/makeProvenanceEntityName.R")

###### arguments for makeCellLineModelingData #######################
exprDataId <- "syn1571209"
copyDataId <- "syn1571218"
featureDataIdList <- list(expr = exprDataId, copy = copyDataId)
responseDataId = "syn1571205"

responseDataEntity <- loadEntity(responseDataId)
allCompoundNames <- colnames(responseDataEntity$objects[[1]])

# for (i in 3:24){
  i=1
  compound = allCompoundNames[i]
  
  modelingDataResultParentId <- "syn1583154"
  
  makeModelingData_functionArgs <- list(featureDataIdList = featureDataIdList,
                                        responseDataId = responseDataId,
                                        compound = compound)
  
  modelingDataEntity <- synapseExecute("makeCellLineModelingData",
                                       makeModelingData_functionArgs,
                                       resultParentId = modelingDataResultParentId)
  
  modelingData <- modelingDataEntity$objects$functionResult
  className <- "GlmnetModel"
  
  cvResultsEntity <- synapseExecute("crossValidatePredictiveModel_synapse", list(modelDataSynapseId=modelingDataEntity$properties$id,
                                                                 model=className),
                              resultParentId = "syn1571652")
  cvResultsEntity$annotations$exprDataId <- exprDataId
  cvResultsEntity$annotations$copyDataId <- copyDataId
  cvResultsEntity$annotations$compound <- compound
  cvResultsEntity$annotations$model <- className
  cvResultsEntity$annotations$r2 <- cvResultsEntity$objects$functionResult$getR2()
  
  cvResultsEntity <- storeEntity(cvResultsEntity)
# }
