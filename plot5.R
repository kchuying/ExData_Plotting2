#Ensure plot5.R and data file (unzipped with 2 .RDS files in folder) is in current working directory

#load library
library(lattice)
library(plyr)

#Read in data file from the folder containing the data files
setwd("exdata-data-NEI_data//")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#From SCC dataset, get all records related to motor vehicle sources
toMatch <- c("motorcycles", "motor vehicle")
SCC.motor <- grep(paste(toMatch,collapse="|"), SCC$Short.Name, ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.identifiers <- as.character(SCC.motor$SCC)

#From NEI dataset, get all records where emission source is from Baltimore City
bcdata<- NEI[which(NEI$fips == "24510"), ]

#Sieve out records from NEI dataset that matches motor records' identifier
bcdata$SCC <- as.character(bcdata$SCC)
bcdata.motor <- NEI[bcdata$SCC  %in% SCC.identifiers, ]

#Sum the emissions based on subset data where source is from Motor Vehicle Sources (in Baltimore City)
aggregate.motor <- with(bcdata.motor, aggregate(Emissions, by = list(year), sum))
colnames(aggregate.motor) <- c("year", "Emissions")

#generate plot and png
png("plot5.png", width = 480, height = 480) 

plot(aggregate.motor, type = "o", ylab = expression("Total Emissions, PM"[2.5]), 
     xlab = "Year", main = "Total Emissions from Motor Sources for Baltimore City", 
     xlim = c(1999, 2008))

dev.off()

#Q5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
#Ans: The emissions from motor vehicle sources have continuously decreased from 1999-2008