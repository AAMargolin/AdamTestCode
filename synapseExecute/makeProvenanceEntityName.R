makeProvenanceEntityName <- function(activityFunctionRef, functionArgs, isFirstCall=TRUE){
  entityName = ""
  for (curArgName in names(functionArgs)){
    if (is.list(functionArgs[[curArgName]])){
      entityName <- paste(entityName, makeProvenanceEntityName(activityFunctionRef, functionArgs[[curArgName]], isFirstCall=FALSE))
    }else if (class(functionArgs[[curArgName]]) %in% c("Code", "Data", "Folder")){
      entityName <- paste(entityName, curArgName, functionArgs[[curArgName]]$properties$id)
    }else{
      entityName <- paste(entityName, curArgName, functionArgs[[curArgName]])
    }
  }
  
  if(isFirstCall){
    if(is.list(activityFunctionRef)){
      entityName <- paste( gsub("/","+", activityFunctionRef$sourceFile), entityName)
    }
  }
  
  return(entityName)
}
