copyEntity <- function(origEntity, newParentId, newEntityName, copyObjects = TRUE, copyFiles = TRUE){
  newEntity <- Data(list(name = newEntityName, parentId = newParentId, description = origEntity$properties$description,
                         disease = origEntity$properties$disease, tissueType = origEntity$properties$tissueType, platform = origEntity$properties$platform,
                         species = origEntity$properties$species, numSamples = origEntity$properties$numSamples))
  
  if (copyObjects){
    for (curObjName in names(origEntity$objects)){
      newEntity <- addObject(newEntity, origEntity$objects[[curObjName]], curObjName)
    }
  }
  
  if (copyFiles){
    for (curFile in origEntity$files){
      newEntity <- addFile(newEntity, paste(origEntity$cacheDir, curFile, sep="/"))
    }
  }
  
  return(newEntity)
}
