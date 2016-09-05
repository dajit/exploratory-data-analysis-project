# Load required library
library(data.table)
library(ggplot2)

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

dfres <- df[,sum(as.numeric(Emissions), na.rm = TRUE), by = list(year,type)]

xrange <- range(dfres$year)
yrange <- range(dfres$V1)

p <- qplot(year,V1, data = dfres , col = type, geom=("path"), xlab="year" 
      , ylab ="Total emission in tons"
      , xlim = xrange
      , ylim = yrange
      )

p <- p + ggtitle("Total emission in Baltimore City from 1999-2008 by TYPE") 

p <- p + theme(plot.title = element_text(size=10, face="bold", margin = margin(10, 0, 10, 0)))

print(p)

ggsave("plot3.png")

# Don't forget to close the PNG device!
dev.off()


