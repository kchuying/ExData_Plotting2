#Ensure plot4.R and data file (unzipped with 2 .RDS files in folder) is in current working directory

#load library
library(lattice)
library(plyr)

#Read in data file from the folder containing the data files
setwd("exdata-data-NEI_data//")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#From SCC dataset, get all records which has "coal" in shortname 
SCC.coal <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
SCC.coal <- SCC[SCC.coal, ]
SCC.identifiers <- as.character(SCC.coal$SCC)

#Sieve out records from NEI dataset that matches coal records' identifier
NEI$SCC <- as.character(NEI$SCC)
NEI.coal <- NEI[NEI$SCC %in% SCC.identifiers, ]

#Sum the emissions based on subset data where source is from Coal Combustion
aggregate.coal <- with(NEI.coal, aggregate(Emissions, by = list(year), sum))
colnames(aggregate.coal) <- c("year", "Emissions")

#generate plot and png
png("plot4.png", width = 480, height = 480) 

plot(aggregate.coal, type = "o", ylab = expression("Total Emissions, PM"[2.5]), 
     xlab = "Year", main = "Total Emissions from Coal Combustion for U.S.", 
     xlim = c(1999, 2008))

dev.off()

#Q4: #Across the United States, how have emissions from coal combustion-related sources 
##    changed from 1999-2008?

#Ans: From 1996 to 2002, there was a slight decrease in coal combustion-related sources.
##    Subsequently, there was an increase from 2002-2005, followed by a huge decrease from 2005-2008.
