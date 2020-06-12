library(ggplot2)
library(tidyverse)

SCC <- readRDS("D:/r-projects/Source_Classification_Code.rds")
NEI <- readRDS("D:/r-projects/summarySCC_PM25.rds")

comb <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
combSCC <- data.frame(SCC = SCC$SCC[comb & coal])
combNEI <- NEI[NEI$SCC %in% combSCC$SCC,]

data <- combNEI %>%
  group_by(year) %>%
  summarize(avg = mean(Emissions, na.rm = TRUE))

png(filename = "plot4.png")
data %>% ggplot(aes(year, avg)) +
  geom_point() +
  geom_line() +
  labs(x="year", y=expression("Total PM2.5 Emission in US (in tonnes)"))
dev.off()