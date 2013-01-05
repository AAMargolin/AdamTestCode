
createTumorTypeSummary <- function(annot, primarySite, fieldToAppend){
  annotIndices <- which(annot$Primary.site == primarySite)
  if(primarySite == "haematopoietic_and_lymphoid_tissue"){
    ####### just use the hist subtype for haematopoietic_and_lymphoid_tissue #############
    tumorTypeSummaries <- as.character(annot[annotIndices, fieldToAppend])
  }else{
    tumorTypeSummaries <- paste(annot[annotIndices, "Primary.site"], annot[annotIndices, fieldToAppend], sep="_")
  }
  annot[annotIndices, "Tumor.type.simple"] <- tumorTypeSummaries
  
  return(annot)
}
