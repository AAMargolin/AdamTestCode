repository <- getRepo(repository="/AAMargolin/AdamTestCode")
repoName <- "/AAMargolin/AdamTestCode"
sourceFile <- "ccleAnalysis/makeCellLineModelingData.R"
sourceRepoFile(repository, myFile)

myURL <- paste("https://raw.github.com", repository@user, repository@repo, repository@commit, sourceFile, sep="/")

myCode <- Code(name="githubExternalTest4", parentId="syn1571220")

myLocations <- c(myURL, "external")
names(myLocations) <- c("path", "type")
myLocationsList <- list(myLocations)
myCode$properties$locations <- myLocationsList

myCode <- createEntity(myCode)




myCode <- addGithubTag(myCode, myURL)

myCode$properties$locations <- list(path=myURL, type="external")

myCode <- storeEntity(myCode)

testCode <- loadEntity("syn1583140")