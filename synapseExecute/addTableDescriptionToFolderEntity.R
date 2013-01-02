addTableDescriptionToFolderEntity <- function(folderEntityId){
  desc <- "<table>"
  folderEntity <- loadEntity(folderEntityId) 
  childEntityIds <- synapseQuery(paste("select id from entity where entity.parentId == '", folderEntityId, "'"))
  
  ###print the header#######
  curEntity <- getEntity(childEntityIds$entity.id[1])
  desc <- paste(desc, "<tr>", sep="")
  desc <- paste(desc, "<td>", "Entity", "</td>", sep="")
  for (curAnnotName in annotationNames(curEntity)){
    desc <- paste(desc, "<td>", curAnnotName, "</td>", sep="")
  }
  desc <- paste(desc, "</tr>", sep="")
                         
  for (entityId in childEntityIds$entity.id){
    curEntity <- getEntity(entityId)
    desc <- paste(desc, "<tr>", sep="")
    desc <- paste(desc, "<td>", curEntity$properties$id, "</td>", sep="")
    for (curAnnotName in annotationNames(curEntity)){
      desc <- paste(desc, "<td>", curEntity$annotations[[curAnnotName]], "</td>", sep="")
    }
    desc <- paste(desc, "</tr>", sep="")
  }
  desc <- paste(desc, "</table>", sep="")
  
  folderEntity$properties$description <- desc
  folderEntity <- storeEntity(folderEntity)
  return(desc)
}
