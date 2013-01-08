require(synapseClient)
require(rGithubClient)

repository <- getRepo(repository="/AAMargolin/AdamTestCode")
sourceRepoFile(repository, "ccleAnalysis/createTumorTypeSummary.R")

curateCellLineAnnotations <- function(inputAnnotEntityId){
  inputAnnotEntity <- loadEntity(inputAnnotEntityId)
  sangerAnnot <- inputAnnotEntity$objects$Annotation
  
  annotationFields <- c("Sample.name", "ID_sample", "Sample.source", "Tumour.source", "Patient.age", "Patient.gender",
                         "Primary.site", "Site.subtype.1", "Site.subtype.2", "Site.subtype.3", "Primary.Histology",
                         "Hist.subtype.1", "Hist.subtype.2", "Hist.subtype.3", "Availability..Institute.Address.Catalogue.Number.")
  
  sangerAnnot_curated <- sangerAnnot[, annotationFields]
  
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "prostate", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "haematopoietic_and_lymphoid_tissue", "Hist.subtype.1")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "urinary_tract", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "kidney", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "central_nervous_system", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "thyroid", "Hist.subtype.1") #### ask about this one
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "skin", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "salivary_gland", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "ovary", "Hist.subtype.1") ### ask about this. Some are NS
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "stomach", "Hist.subtype.1") #### double check
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "lung", "Hist.subtype.1")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "bone", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "autonomic_ganglia", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "endometrium", "Hist.subtype.1") ### ask about this one
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "breast", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "pancreas", "Primary.Histology") ### note all Hist.subtype.1 are ductal_carcinoma
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "upper_aerodigestive_tract", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "cervix", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "large_intestine", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "liver", "Hist.subtype.1") ### check if there's a difference between adenocarcinoma and hepatocellular_carcinoma
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "vulva", "Primary.Histology") ### all squamous_cell_carcinoma. Note, using just carcinoma since for some other tissue types some annotations were missing even if all other Hist.subtype.1 were the same
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "oesophagus", "Hist.subtype.1") ### squamous_cell_carcinoma, metaplasia, adenocarcenoma, and NS
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "gastrointestinal_tract_(site_indeterminate)", "Primary.Histology") ### check on this strange tissue type
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "biliary_tract", "Primary.Histology") ### Hist.subtype.1 adenocarcinoma, undifferentiated_carcinoma, NS
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "soft_tissue", "Hist.subtype.1")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "small_intestine", "Primary.Histology") ### only 1 sample
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "pleura", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "testis", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "adrenal_gland", "Primary.Histology")
  sangerAnnot_curated <- createTumorTypeSummary(sangerAnnot_curated, "eye", "Primary.Histology")
  
  sangerAnnot_curated <- gsub("\\.", "", toupper(make.names(sangerAnnot_curated$Sample.name)))
  
  return(sangerAnnot_curated)
}

# curSite <- "eye"
# sangerAnnot[sangerAnnot$Primary.site == curSite,]$Primary.Histology
# sangerAnnot[sangerAnnot$Primary.site == curSite,]$Hist.subtype.1

