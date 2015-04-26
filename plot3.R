#Ensure plot3.R and data file (unzipped with 2 .RDS files in folder) is in current working directory

#load library
library(ggplot2)
library(plyr)

#Read in data file from the folder containing the data files
setwd("exdata-data-NEI_data//")
NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

#Retrieve all records with source from Baltimore City
bcdata<- NEI[which(NEI$fips == "24510"), ]

#Aggregate the emissions by year for each source type
bctype <- ddply(bcdata, .(type, year), summarize, Emissions = sum(Emissions))

## generate plot & png file
png("plot3.png", width = 480, height = 480) 

p <- ggplot(bctype, aes(x=year, y=Emissions, colour=type)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1, method="loess") +
  ggtitle("Total Emissions in Baltimore City (by Type of Source)") +
  xlab("Year") +  
  ylab(expression("Total Emissions, PM"[2.5]))  

print(p)
dev.off()


#Q3: Which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008?
#Ans: All four sources depicts a decrease in emissions, however for source "point", there was an increase from 1999 - 2005, before it started decreasing in emissions.