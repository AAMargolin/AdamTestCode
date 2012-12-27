require(synapseClient)
require(predictiveModeling)

executionCodeId <- "syn1571659"

args <- list(featureDataId = "syn1571209",
                     responseDataId = "syn1571205",
                     className = "GlmnetModel",
                     drugId = 1)

resultParentId <- "syn1571652"

synapseExecute(executionCodeId, functionArgs, resultParentId)
