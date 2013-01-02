createUsedEntitiesList <- function(args, usedEntitiesList = list()){  
  for (argName in names(args)){
    argVal <- args[[argName]]
    if(is.character(argVal) && substr(argVal, 1, 3) == "syn"){
      usedEntitiesList[[length(usedEntitiesList)+1]] <- list(entity=argVal, wasExecuted=FALSE)
    }else if (is.list(argVal)){
      usedEntitiesList <- createUsedEntitiesList(argVal, usedEntitiesList)
    }
  }
  return(usedEntitiesList)
}


synapseExecute <- function(functionName, args, resultParentId, resultEntityProperties = NULL, 
                           resultEntityName=makeProvenanceEntityName(functionName, args)){
#   executionCode <- loadEntity(executionCodeId)
#   functionResult <- do.call(executionCode$objects[[1]], args)
  
#   executionCode <- source_url(executionCodeId)
#   functionResult <- do.call(executionCode$value, args)
  
  print(paste("Executing function", functionName))
  functionResult <- do.call(functionName, args)
  print(paste("Executing of function", functionName, "complete"))
  
  
  ###### hack to get function name ##########
#   tester <- strsplit(executionCodeId, "/")
#   executionCodeName <- tester[[1]][[length(tester[[1]])]]
  
  usedEntitiesList <- createUsedEntitiesList(args)
  
  activity <- Activity(list(name = functionName, used = usedEntitiesList))
#   activity$annotations$args <- args
  activity <- createEntity(activity)
  
  resultEntity <- Data(name=resultEntityName, parentId = resultParentId)
  generatedBy(resultEntity) <- activity
  
  resultEntity <- addObject(resultEntity, functionResult, name="functionResult")
  resultEntity <- addObject(resultEntity, args, name="functionArgs")
  if(!is.null(resultEntityProperties)){
    resultEntity <- addObject(resultEntity, resultEntityProperties)
  }
  
  resultEntity <- storeEntity(resultEntity)
  
  return(resultEntity)
}
