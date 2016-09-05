# Load required library
library(data.table)
library(ggplot2)

# set wd to dir where files are downloaded
# setwd("C:\\coursera\\course4\\project")
setwd(".")

# download zip file
#url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#zipName <- file.path(getwd(), "input_data.zip")
#download.file(url, zipName)
#unzip(zipName, overwrite = TRUE)

## This first line will likely take a few seconds. Be patient!
#NEI <- readRDS("summarySCC_PM25.rds")

#> dim(NEI)
#[1] 6497651       6
#> 

#SCC <- readRDS("Source_Classification_Code.rds")
#> dim(SCC)
#[1] 11717    15
#> 

dtnei <- data.table(NEI)
dtscc <- data.table(SCC)

# extract logical vector of acol related sources
iscoalSCC <- grepl("coal", tolower(dtscc$Short.Name))
coalSCC <- dtscc[which(iscoalSCC),]

# use the above vector to get pm data only for coal sources

dtneicoal <- subset(dtnei, dtnei$SCC %in% coalSCC$SCC)

#> dim(dtneicoal)
#[1] 53400     6

dfres <- dtneicoal[,sum(as.numeric(Emissions), na.rm = TRUE), by = list(year)]

# now plot
p <- qplot(year,V1, data = dfres , geom="line", xlab="year" 
      , ylab ="Total Coal related emission in tons"
      )

p <- p + ggtitle("Total emission in US for Coal combustion-related sources") 

p <- p + theme(plot.title = element_text(size=10, face="bold", margin = margin(10, 0, 10, 0)))

print(p)

ggsave("plot4.png")

# Don't forget to close the PNG device!
dev.off()
