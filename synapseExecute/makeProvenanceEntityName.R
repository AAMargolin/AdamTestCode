makeProvenanceEntityName <- function(functionName, functionArgs, isFirstCall=TRUE){
  entityName = ""
  for (curArgName in names(functionArgs)){
    if (is.list(functionArgs[[curArgName]])){
      entityName <- paste(entityName, makeProvenanceEntityName(functionName, functionArgs[[curArgName]], isFirstCall=FALSE))
    }else{
      entityName <- paste(entityName, curArgName, functionArgs[[curArgName]])
    }
  }
  
  if(isFirstCall){
    entityName <- paste(functionName, entityName)
  }
  
  return(entityName)
}
