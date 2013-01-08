require(synapseClient)
require(predictiveModeling)

syn_createCellLineFeatureMatrix <- function(annotationsEntityId){
  annotationsEntity <- loadEntity(annotationsEntityId)
  annotations <- annotationsEntity$objects[["functionResult"]]
  annotations[, "Tumor.type.simple"]
  featureMatrix <- convertDataFrameToFeatureMatrix(annotations)
  colnames(featureMatrix) <- sub("Tumor.type.simple_", "", colnames(featureMatrix))
  return(featureMatrix)
}
