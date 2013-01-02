loadMatrixEntity <- function(entityId){
  print(paste("loading entity", entityId))
  entity <- loadEntity(entityId)
  print(paste("reading entity", entityId, "to matrix"))
  matrixData <- as.matrix(read.delim(file.path(entity$cacheDir, entity$files[[1]]), row.name=1, check.names=F))
  return(matrixData)
}
