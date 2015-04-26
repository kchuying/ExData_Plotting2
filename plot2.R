#Ensure plot2.R and data file (unzipped with 2 .RDS files in folder) is in current working directory

#Read in data file from the folder containing the data files
setwd("exdata-data-NEI_data//")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

bc<- NEI[which(NEI$fips == "24510"), ]
data <- with(bc, aggregate(Emissions, by = list(year), sum))
colnames(data) <- c("year", "Emissions")

## generate plot & png file
png("plot2.png", width = 480, height = 480) 
plot(data, type = "o", ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Total Emissions for Baltimore City", xlim = c(1999,2008))
dev.off()

#Q2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#Ans: Overall, the total emissions from PM2.5 has decreased in Baltimore City except from year 2002-2005.