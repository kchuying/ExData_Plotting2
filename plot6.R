#Ensure plot6.R and data file (unzipped with 2 .RDS files in folder) is in current working directory

#load libraries
library(plyr)
library(ggplot2)

#Read in data file from the folder containing the data files
setwd("exdata-data-NEI_data//")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#From SCC dataset, get all records related to motor vehicle sources
toMatch <- c("motorcycles", "motor vehicle")
SCC.motor <- grep(paste(toMatch,collapse="|"), SCC$Short.Name,ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.identifiers <- as.character(SCC.motor$SCC)

#Seive all records from NEI where identifier matches motors records in SCC dataset
NEI$SCC <- as.character(NEI$SCC)
NEI.motor <- NEI[NEI$SCC %in% SCC.identifiers, ]

#From previous subset data, sieve all records with motor emissions from: 
bcmotor <- NEI.motor[which(NEI.motor$fips == "24510"), ] #Baltimore City
lamotor <- NEI.motor[which(NEI.motor$fips == "06037"), ] #Los Angeles

#Sum the total emissions from motor vehicles for BC & LAC respectively
# & Add an additional column to indicate city source
bctotal <- with(bcmotor, aggregate(Emissions, by = list(year), sum))
bctotal$city <- rep("Baltimore City", length(bctotal[,1]))

latotal <- with(lamotor, aggregate(Emissions, by = list(year), sum))
latotal$city <- rep("Los Angeles County", length(latotal[,1]))

#combine 2 datasets & rename columns
combinedDF <- rbind(latotal, bctotal)
combinedDF$city <- as.factor(combinedDF$city)
colnames(combinedDF) <- c("Year", "Emissions", "City")

#generate plot and png
png("plot6.png", width = 600, height = 600) 

p <- ggplot(combinedDF, aes(x=Year, y=Emissions, colour=City)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1, method="loess") +
  ggtitle("Motor Vehicle Emissions in Baltimore vs. LA") +
  xlab("Year") +  
  ylab(expression("Total Emissions, PM"[2.5]))  

print(p)

dev.off()

#Q6: Which city has seen greater changes over time in motor vehicle emissions?
#Ans: Los Angeles County has a greater change overtime in total emissions of PM2.5 from motor vehicles overtime.