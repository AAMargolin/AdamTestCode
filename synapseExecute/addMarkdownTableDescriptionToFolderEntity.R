require(synapseClient)

addMarkdownTableDescriptionToFolderEntity <- function(folderEntityId, annot){
  desc <- "<table>"
  folderEntity <- loadEntity(folderEntityId) 
  childEntityIds <- synapseQuery(paste("select id from entity where entity.parentId == '", folderEntityId, "'"))
  
  ###print the header#######
  curEntity <- getEntity(childEntityIds$entity.id[1])
  desc <- paste("Entity")
  for (curAnnotName in annotationNames(curEntity)){
    desc <- paste(desc, " | ", curAnnotName, sep="")
  }
  desc <- paste(desc, "\n", sep="")
  
  for (entityId in childEntityIds$entity.id){
    desc <- paste(desc, "-", sep=" ")
    for (curAnnotName in annotationNames(curEntity)){
      desc <- paste(desc, " | ", "-", sep="")
    }
    desc <- paste(desc, "\n")
  }
  
  for (entityId in childEntityIds$entity.id){
    curEntity <- getEntity(entityId)
    print(paste("entity", curEntity$properties$name))
    desc <- paste(desc, curEntity$properties$id, sep=" ")
    for (curAnnotName in annotationNames(curEntity)){
      print(curAnnotName)
      desc <- paste(desc, " | ", curEntity$annotations[[curAnnotName]], sep="")
    }
    desc <- paste(desc, "\n")
  }
  
  folderEntity$properties$description <- desc
  folderEntity <- storeEntity(folderEntity)
  return(desc)
}
