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

# extract Baltimore and Los Angeles County data
df <- subset(dtnei,dtnei$fips %in% c("24510", "06037") )
dim(df)

# So look for ON-ROAD in Baltimore data
dfonroad <- df[df$type == "ON-ROAD"]

# aggregrate
dfres <- dfonroad[,sum(as.numeric(Emissions), na.rm = TRUE), by = list(fips, year)]

# create city column
dfres$city[ dfres$fips == "06037"] <- "Los Angeles"
dfres$city[ dfres$fips == "24510"] <- "Baltimore"

# now plot
#qplot(year,V1, data = dfres , facets = . ~ fips , geom="line", xlab="year" 
#      , ylab ="Total Motor Vehicle related emission in tons"
#      , main = "Total emission in Baltimore and Los Angeles for Motor Vehicle related sources from 1999-2008")

#qplot(year,V1, data = dfres, col = fips , geom = "line")

p <- qplot(year,V1, data = a, col = city , geom = "line" ,xlab="year" 
      , ylab ="Total Motor Vehicle related emission in tons"
    )

p <- p + ggtitle("Total emission in Baltimore and Los Angeles for Motor Vehicle related sources") 

p <- p + theme(plot.title = element_text(size=8, face="bold", margin = margin(10, 0, 10, 0)))

print(p)

ggsave("plot6.png")

# Don't forget to close the PNG device!
dev.off()
