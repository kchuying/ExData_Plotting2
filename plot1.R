#Ensure plot2.R and data file (unzipped with 2 .RDS files in folder) is in current working directory

#Read in data file from folder containing the data files
setwd("exdata-data-NEI_data//")
NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## aggregate Emission data based on year
data <- with(NEI, aggregate(Emissions, by = list(year), sum))

## generate plot & png file
png("plot1.png", width = 480, height = 480) 
plot(data, type = "o", ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Total Emissions in the U.S. from 1999 to 2008")
dev.off()

#Q1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Ans: The total emissions from PM2.5 has decreased from 1999 to 2008.