library(ggplot2)
library(tidyverse)

SCC <- readRDS("D:/r-projects/Source_Classification_Code.rds")
NEI <- readRDS("D:/r-projects/summarySCC_PM25.rds")

veh <- grepl("veh", SCC$EI.Sector, ignore.case=TRUE)
vehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
combSCC <- data.frame(SCC = SCC$SCC[veh & vehicle])
combNEI <- NEI[NEI$SCC %in% combSCC$SCC,]

data <- combNEI %>%
  filter(fips == "24510" | fips == "06037") %>%
  group_by(fips, year) %>%
  summarize(avg = mean(Emissions, na.rm = TRUE)) %>%
  mutate(city = ifelse(fips == "24510", "Baltimore City", "Los Angeles"))

png(filename = "plot6.png")
data %>% ggplot(aes(year, avg, col = city)) +
  geom_point() +
  geom_line() +
  labs(x="year", y=expression("Total PM2.5 Emission (in tonnes)"))
dev.off()