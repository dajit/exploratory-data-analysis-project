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

dtnei <- data.table(NEI)
dtscc <- data.table(SCC)

# extract Baltimore data
df <- dtnei[which(dtnei$fips == "24510"),]
dfres <- df[, sum(as.numeric(Emissions)),by = 'year']

# create a line plot 
with(dfres, plot(year,V1, type = "o", pch = 16))

# title
title(main = "Total PM2.5 Emission (tons) in Baltimore by Year", ylab = "Total Emission in Baltimore in tons")

# Copy my plot to a PNG file
dev.copy(png, file = "plot2.png")

# Don't forget to close the PNG device!
dev.off()
