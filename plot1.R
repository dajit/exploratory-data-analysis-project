# Load required library
library(data.table)
library(base)

# set wd to dir where files are downloaded
# setwd("C:\\coursera\\course4\\project")
setwd(".")

# download zip file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipName <- file.path(getwd(), "input_data.zip")
download.file(url, zipName)
unzip(zipName, overwrite = TRUE)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
#> dim(NEI)
#[1] 6497651       6
#> 

SCC <- readRDS("Source_Classification_Code.rds")
#> dim(SCC)
#[1] 11717    15
#> 

# convert to data table
dtnei <- data.table(NEI)
dtscc <- data.table(SCC)

dfres <- dtnei[, sum(as.numeric(Emissions)),by = 'year']

# create a plot 
with(dfres, plot(year,V1, type = "o" , pch = 16 ))

# title
title(main = "Total PM2.5 Emission (tons) from all source by Year", xlab = "Year", ylab = "Total PM2.5 Emission (tons)")

# Copy my plot to a PNG file
dev.copy(png, file = "plot1.png")

# Don't forget to close the PNG device!
dev.off()
