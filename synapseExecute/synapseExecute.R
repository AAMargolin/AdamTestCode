require(rGithubClient)
require(devtools)
require(RCurl)

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

encap <- function(str, encapper = "'"){
  retVal <- paste(encapper, str, encapper, sep="")
  return(retVal)
}

getOrCreateEntity <- function(name, parentId, entityType){
  entityId <- synapseQuery(paste("select id from entity where entity.parentId ==", encap(parentId), "AND entity.name ==", encap(name)))
  
  if (is.null(entityId)){
    entity <- do.call(entityType, list(name=name, parentId=parentId))
    entity <- storeEntity(entity)
  }else{
    entity <- getEntity(entityId$entity.id)
  }
  
  return(entity)
}

createGithubCodeEntity <- function(repoName, sourceFile){
  githubRepo <- getRepo(repository=repoName)
  
  githubCodeProjectId <- "syn1583141"
  
  synapseRepoName <- gsub("/", "+", repoName)
  synapseSourceFile <- gsub("/", "+", sourceFile)
  
  repoEntity <- getOrCreateEntity(name=synapseRepoName, parentId=githubCodeProjectId, entityType="Folder")
  commitEntity <- getOrCreateEntity(name=as.character(githubRepo@commit), parentId=repoEntity$properties$id, entityType="Folder")
  sourceFileEntity <- getOrCreateEntity(name=synapseSourceFile, parentId=commitEntity$properties$id, entityType="Code")
  
  githubURL <- paste("https://raw.github.com", githubRepo@user, githubRepo@repo, githubRepo@commit, sourceFile, sep="/")
  
  sourceFileEntity$annotations$githubURL <- githubURL
  sourceFileEntity$properties$description <- getURLContent(githubURL)
  sourceFileEntity <- storeEntity(sourceFileEntity)
  
  return(sourceFileEntity)
}


synapseExecute <- function(activityFunctionRef, args, resultParentId, resultEntityProperties = NULL, 
                           resultEntityName=makeProvenanceEntityName(activityFunctionRef, args), functionResult=NULL){
  
  usedEntitiesList <- createUsedEntitiesList(args)
  
  print(paste("Executing function"))
  
  ##### would be better to use Brian's GitHub client to represent a file and not just a repo so we can check for class of type
  ##### GithubFile rather than checking for a list #############
  if (is.list(activityFunctionRef)){
    executionCodeEntity <- createGithubCodeEntity(repoName = activityFunctionRef$repoName, sourceFile = activityFunctionRef$sourceFile)
    executionCode <- source_url(executionCodeEntity$annotations$githubURL)
    functionResult <- do.call(executionCode$value, args)
    
    usedEntitiesList[[length(usedEntitiesList)+1]] <- list(entity=executionCodeEntity$properties$id, wasExecuted=TRUE)
    
    activity <- Activity(list(name = activityFunctionRef$sourceFile, used = usedEntitiesList))
    activity <- createEntity(activity)
    
  }else if (is.character(activityFunctionRef) || is.function(activityFunctionRef)){
    
    functionResult <- do.call(activityFunctionRef, args)
  }
#   executionCode <- loadEntity(executionCodeId)
#   functionResult <- do.call(executionCode$objects[[1]], args)
  
  print(paste("Executing of function complete"))

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
