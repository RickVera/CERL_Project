##Ricardo Vera
##Last Updated 04 Dec 2017
##Vehicle Prediction File to ArcMap-portable .csv file converter
##for Speed Map creation.

#Import library needed for str_extract_all function
library(stringr)

#Set working directory to wherever this source code is located
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#Import .pred file names from working directory
nrmm<- list.files(pattern="*nrmm.pred")


#Create naming convention for output files
fileName <- substring(nrmm, 4) #Renames from 4th character onward
fileName <- sapply(strsplit(fileName, "_nrmm"), "[", 1) #Removes characters after nrmm
fileName <- paste(fileName, ".csv", sep="") #Pastes rest of name and extension to str


#Loops through all relevant Slip files
i = 1
n = length(nrmm)
while (i <= n) {
   y <- file(nrmm[i]) #import file
   x <- readLines(y) #translates each row to string in data.frame column
   close(y)
   x <- x[-c(1:10)] #remove first ten columns
   x <- str_extract_all(x,"\\(?[0-9,.-]+\\)?") #convert single string of numbers to seperate rows
   X = as.matrix(sapply(x, as.numeric)) #convert data.frame strings to floating point matrix
   remove(x)
   X = t(X); #transpose matrix so categories are in column and values by row
   X = X[,-c(2:8)] #remove unwanted data columns
   colnames(X) <- c("NTU", "Up_Speed", "Up_RC", "Level_Speed", "Level_RC", "Down_Speed", "Down_RC")
   write.csv(X, file = fileName[i], row.names=FALSE)
   i = i + 1
}
remove()
