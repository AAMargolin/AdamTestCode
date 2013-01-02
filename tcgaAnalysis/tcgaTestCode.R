lungData <- synapseQuery("select * from entity where entity.benefactorId == 'syn300013' && entity.acronym == 'LUSC'", blockSize=100)$collectAll()

clinicalData <- synapseQuery('select * from entity where entity.parentId == "syn395688" AND entity.acronym == "LUSC" AND entity.dataSubType=="clinical" 
                             AND entity.freeze == "tcga_pancancer_v4"',
                             blockSize=100)$collectAll()

clinicalData <- unique(clinicalData)

clinicalAliquotEntityId <- synapseQuery('select id from entity where entity.name == "tcga_LUSC_clinical.aliquot.whitelist"')
clinicalAliquotEntity <- loadEntity(clinicalAliquotEntityId$entity.id[1])
clinicalAliquotData <- read.delim(file.path(clinicalAliquotEntity$cacheDir, clinicalAliquotEntity$files[[1]]), row.name=1, check.names=F)

clinicalPatientEntityId <- synapseQuery('select id from entity where entity.name == "tcga_LUSC_clinical.patient.whitelist"')
clinicalPatientEntity <- loadEntity(clinicalPatientEntityId$entity.id[1])
clinicalPatientData <- read.delim(file.path(clinicalPatientEntity$cacheDir, clinicalPatientEntity$files[[1]]), row.name=1, check.names=F)

rnaSeqEntityIds <- synapseQuery('select * from entity where entity.parentId == "syn395688" AND entity.acronym == "LUSC" 
                              AND entity.platform == "IlluminaHiSeq_RNASeq"',
                                blockSize=100)$collectAll()
rnaSeqEntityIds <- unique(rnaSeqEntityIds)

rnaSeqMatrix_1 <- loadMatrixEntity(rnaSeqEntityIds$entity.id[1])
rnaSeqMatrix_2 <- loadMatrixEntity(rnaSeqEntityIds$entity.id[2])