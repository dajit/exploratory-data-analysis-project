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

# alternate way to find motor vehicle category in SCC
mvSCC <- dtscc[grepl("motor.*vehicle",dtscc$Short.Name,ignore.case = TRUE)]


# use the above vector to get pm data only for motor vehicle sources
dtneimv <- subset(df, df$SCC %in% mvSCC$SCC)

#> df[df$SCC %in% aa,]
#fips        SCC Pollutant Emissions     type year
#1: 24510 2810050000  PM25-PRI     10.17 NONPOINT 2002
#2: 24510 2810050000  PM25-PRI     10.17 NONPOINT 2005
#> 

# looks likesome proble only 2 records are returned
# because the NEI data conatins a CHARCATER at the end ex.220100125B
# or 220100125T 

#> df[df$type == "ON-ROAD"]
#fips        SCC Pollutant   Emissions    type year
#1: 24510 220100123B  PM25-PRI  7.38000000 ON-ROAD 1999
#2: 24510 220100123T  PM25-PRI  2.78000000 ON-ROAD 1999
#3: 24510 220100123X  PM25-PRI 11.76000000 ON-ROAD 1999
#4: 24510 220100125B  PM25-PRI  3.50000000 ON-ROAD 1999
#5: 24510 220100125T  PM25-PRI  1.32000000 ON-ROAD 1999
#---                                                    
#  1115: 24510 2201070310  PM25-PRI  0.01415230 ON-ROAD 2008
#1116: 24510 2230074170  PM25-PRI  0.00781482 ON-ROAD 2008
#1117: 24510 2201020250  PM25-PRI  0.07883690 ON-ROAD 2008
#1118: 24510 2201001310  PM25-PRI  0.59761100 ON-ROAD 2008
#1119: 24510 2230001250  PM25-PRI  0.01152120 ON-ROAD 2008
#> 

# and all these sub categories mapto 
# correponding on road catgory in SCC
# ex.
#> dtscc[dtscc$SCC == "2201001250"]
#SCC Data.Category
#1: 2201001250        Onroad
#Short.Name
#1: Highway Veh - Gasoline - Light Duty Vehicles (LDGV) - Urban Other Freeways & Expressways: Total
#EI.Sector Option.Group Option.Set  SCC.Level.One
#1: Mobile - On-Road Gasoline Light Duty Vehicles                         Mobile Sources
#SCC.Level.Two                     SCC.Level.Three
#1: Highway Vehicles - Gasoline Light Duty Gasoline Vehicles (LDGV)
#SCC.Level.Four Map.To Last.Inventory.Year Created_Date
#1: Urban Other Freeways and Expressways: Total     NA                  NA             
#Revised_Date Usage.Notes
#1:                         
  #> 

# So look for ON-ROAD in Baltimore data as per NEI website ON-ROAD is motor vehcile related sources
dfonroad <- df[df$type == "ON-ROAD"]

# aggregrate
dfres <- dfonroad[,sum(as.numeric(Emissions), na.rm = TRUE), by = list(year)]

# now plot
p <- qplot(year,V1, data = dfres , geom="line", xlab="year" 
      , ylab ="Total Motor Vehicle related emission in tons"
      , main = )

p <- p + ggtitle("Total emission in Baltimore for Motor Vehicle related sources") 

p <- p + theme(plot.title = element_text(size=10, face="bold", margin = margin(10, 0, 10, 0)))

print(p)

ggsave("plot5.png")

# Don't forget to close the PNG device!
dev.off()
