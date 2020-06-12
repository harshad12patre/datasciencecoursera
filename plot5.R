library(ggplot2)
library(tidyverse)

SCC <- readRDS("D:/r-projects/Source_Classification_Code.rds")
NEI <- readRDS("D:/r-projects/summarySCC_PM25.rds")

veh <- grepl("veh", SCC$EI.Sector, ignore.case=TRUE)
vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
combSCC <- data.frame(SCC = SCC$SCC[veh & vehicle])
combNEI <- NEI[NEI$SCC %in% combSCC$SCC,]

data <- combNEI %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarize(avg = mean(Emissions, na.rm = TRUE))

png(filename = "plot5.png")
data %>% ggplot(aes(year, avg)) +
  geom_point() +
  geom_line() +
  labs(x="year", y=expression("Total PM2.5 Emission in Baltimore City (in tonnes)"))
dev.off()