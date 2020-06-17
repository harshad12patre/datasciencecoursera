library(tidyverse)

SCC <- readRDS("D:/r-projects/Source_Classification_Code.rds")
NEI <- readRDS("D:/r-projects/summarySCC_PM25.rds")

data <- NEI %>%
  group_by(year) %>%
  summarize(avg = mean(Emissions, na.rm = TRUE))

png(filename = "plot1.png")
par(mar = c(5, 5, 1, 1))
plot(data$year, data$avg, xlab = "Year", ylab = "Average PM2.5 Emission in US(in tonnes)", type = "b")
dev.off()