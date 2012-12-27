synapseExecute <- function(executionCodeId, args, resultParentId){
  executionCode <- loadEntity(executionCodeId)
  functionResult <- do.call(executionCode$objects[[1]], args)
  
  usedEntitiesList <- list()
  usedEntitiesList[[1]] <- list(entity=executionCode, wasExecuted=TRUE)
  
  for (arg in unlist(args)){
    if(substr(arg, 1, 3) == "syn"){
      usedEntitiesList[[length(usedEntitiesList)+1]] <- list(entity=arg, wasExecuted=FALSE)
    }
  }
  
  activity <- Activity(list(name = executionCode$properties$name, used = usedEntitiesList))
#   activity$annotations$args <- args
  activity <- createEntity(activity)
  
  result <- Data(name=executionCode$properties$name, parentId = resultParentId)
  generatedBy(result) <- activity
  result <- storeEntity(result)
}