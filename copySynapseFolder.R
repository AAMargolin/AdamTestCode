library(synapseClient)

origParentId = "syn424131"
newParentId = "syn1571238"

copySynapseFolder <- function(origParentId, newParentId){
  childrenIds <- synapseQuery(paste("select id from entity where entity.parentId == '", origParentId, "'"))
  for (entityCtr in 1:nrow(childrenIds)){
    print(paste("processing", childrenIds$entity.id[entityCtr]))
    origEntity <- loadEntity(childrenIds$entity.id[entityCtr])
    if(class(origEntity) == "Data"){
      print("copying entity")
      newEntity <- copyEntity(origEntity, newParentId, origEntity$properties$name)
      storeEntity(newEntity)
    }
  }
}
