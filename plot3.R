library(ggplot2)
library(tidyverse)

SCC <- readRDS("D:/r-projects/Source_Classification_Code.rds")
NEI <- readRDS("D:/r-projects/summarySCC_PM25.rds")

data <- NEI %>%
  filter(fips == "24510") %>%
  group_by(type, year) %>%
  summarize(avg = mean(Emissions, na.rm = TRUE))

png(filename = "plot3.png")
data %>% ggplot(aes(year, avg, col = type)) + 
  geom_point() + 
  geom_line() +
  labs(x="year", y=expression("Total PM2.5 Emission in Baltimore City (in tonnes)"))
dev.off()