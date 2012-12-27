require(synapseClient)

############## load entities ################################
#############################################################
ccleRawExprEntity <- loadEntity("syn1571217")
ccleExprEntity <- loadEntity("syn1571207")
ccleExprEntity_averaged <- loadEntity("syn1571209")

ccleRawCopyEntity <- loadEntity("syn1571231")
ccleCopyEntity <- loadEntity("syn1571213")
ccleCopyEntity_averaged <- loadEntity("syn1571218")

ccleMapEntity <- loadEntity("syn1571211")

snmNormScriptEntity <- loadEntity("syn1571221")
snmNormCopyDataScriptEntity <- loadEntity("syn1571232")
averageReplicatesScriptEntity <- loadEntity("syn1571228")

############## create provenance ################################
#############################################################

##################### expr data #############################
activity <- Activity(list(name="SNM Normalize", used=list(list(entity=snmNormScriptEntity,wasExecuted=T),
                                                          list(entity=ccleRawExprEntity, wasExecuted=F)
                                                          )))
activity <- createEntity(activity)
generatedBy(ccleExprEntity) <- activity

# used(ccleExprEntity) <- list(list(entity=snmNormScriptEntity,wasExecuted=T),
#                              list(entity=ccleRawExprEntity, wasExectuted=F))
ccleExprEntity <- storeEntity(ccleExprEntity)

##################### expr replicate averaged #############################
activity <- Activity(list(name="Average Expression Replicates", used=list(list(entity=averageReplicatesScriptEntity, wasExecuted=T),
                                                                     list(entity=ccleExprEntity, wasExecuted=F),
                                                                     list(entity=ccleMapEntity, wasExecuted=F)
                                                                     )))
activity <- createEntity(activity)
generatedBy(ccleExprEntity_averaged) <- activity
ccleExprEntity_averaged <- storeEntity(ccleExprEntity_averaged)

##################### copy data #############################
activity <- Activity(list(name="SNM Normalize Copy Data", used=list(list(entity=snmNormCopyDataScriptEntity,wasExecuted=T),
                                                          list(entity=ccleRawCopyEntity, wasExecuted=F)
                                                          )))
activity <- createEntity(activity)
generatedBy(ccleCopyEntity) <- activity
ccleCopyEntity <- storeEntity(ccleCopyEntity)

##################### copy data replicate averaged #############################
activity <- Activity(list(name="Average Copy Number Replicates", used=list(list(entity=averageReplicatesScriptEntity, wasExecuted=T),
                                                                          list(entity=ccleCopyEntity, wasExecuted=F),
                                                                          list(entity=ccleMapEntity, wasExecuted=F)
                                                                          )))
activity <- createEntity(activity)
generatedBy(ccleCopyEntity_averaged) <- activity
ccleCopyEntity_averaged <- storeEntity(ccleCopyEntity_averaged)
