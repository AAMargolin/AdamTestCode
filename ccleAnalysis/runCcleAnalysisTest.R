require(synapseClient)
require(predictiveModeling)

featureDataId <- "syn1571209"
responseDataId <- "syn1571205"
className <- "GlmnetModel"

predictions <- ccleAnalysisTest(featureDataId, responseDataId, className)

testModelEntity <- Data(name=className, parentId="syn1571652")
testModelEntity <- addObject(testModelEntity, predictions, name="predictions")

snmNormScriptEntity <- loadEntity("syn1571221")
activity <- Activity(list(name="Train Model", used=list(list(entity=featureDataEntity,wasExecuted=F),
                                                        list(entity=responseDataEntity, wasExecuted=F),
                                                        list(entity=snmNormScriptEntity,wasExecuted=T)
                                                        )))
activity <- createEntity(activity)
generatedBy(testModelEntity) <- activity

testModelEntity <- storeEntity(testModelEntity)