suppressMessages(suppressWarnings(library(NLP)))
suppressMessages(suppressWarnings(library(tm)))
suppressMessages(suppressWarnings(library(RColorBrewer)))
suppressMessages(suppressWarnings(library(wordcloud)))
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(stringi)))
suppressMessages(suppressWarnings(library(RWeka)))
suppressMessages(suppressWarnings(library(ggplot2)))
suppressMessages(suppressWarnings(library(ngram)))
suppressMessages(suppressWarnings(library(quanteda)))
suppressMessages(suppressWarnings(library(gridExtra)))

# # blogs
# blogs_file <- "C:/Users/harsh/Desktop/en_US/en_US.blogs.txt"
# cnxn <- file(blogs_file, open="rb")
# suppressWarnings(blogs_lines <- readLines(cnxn, encoding="UTF-8"))
# close(cnxn)
# 
# # news
# news_file <- "C:/Users/harsh/Desktop/en_US/en_US.news.txt"
# cnxn <- file(news_file, open="rb")
# suppressWarnings(news_lines <- readLines(cnxn, encoding="UTF-8"))
# close(cnxn)
# 
# # twitter
# twitter_file <- "C:/Users/harsh/Desktop/en_US/en_US.twitter.txt"
# cnxn <- file(twitter_file, open="rb")
# suppressWarnings(twitter_lines <- readLines(cnxn, encoding="UTF-8"))
# close(cnxn)
# 
# rm(cnxn)
# 
# #File Summary
# summary <- sapply(list(blogs_lines,news_lines,twitter_lines),function(x) summary(stri_count_words(x))[c('Min.','Mean','Max.')])
# rownames(summary) <- c('Min','Mean','Max')
# stats <- data.frame(
#   FileName=c("en_US.blogs","en_US.news","en_US.twitter"),      
#   t(rbind(sapply(list(blogs_lines,news_lines,twitter_lines),stri_stats_general)[c('Lines','Chars'),],  Words=sapply(list(blogs_lines,news_lines,twitter_lines),stri_stats_latex)['Words',], summary)))
# head(stats)
# 
# # Get file sizes
# blogs_size <- file.info(blogs_file)$size / 1024 ^ 2
# news_size <- file.info(news_file)$size / 1024 ^ 2
# twitter_size <- file.info(twitter_file)$size / 1024 ^ 2

# Summary of dataset
df<-data.frame(Doc = c("blogs", "news", "twitter"), Size.MB = c(blogs_size, news_size, twitter_size), Num.Lines = c(length(blogs_lines), length(news_lines), length(twitter_lines)), Num.Words=c(sum(nchar(blogs_lines)), sum(nchar(news_lines)), sum(nchar(twitter_lines))))
df

# Sampling data from the corpus
sampleBlogs <- blogs_lines[sample(1:length(blogs_lines), 0.001*length(blogs_lines), replace=FALSE)]
sampleNews <- news_lines[sample(1:length(news_lines), 0.001*length(news_lines), replace=FALSE)]
sampleTwitter <- twitter_lines[sample(1:length(twitter_lines), 0.001*length(twitter_lines), replace=FALSE)]

# Cleaning sampled data
sampleBlogs <- iconv(sampleBlogs, "UTF-8", "ASCII", sub="")
sampleNews <- iconv(sampleNews, "UTF-8", "ASCII", sub="")
sampleTwitter <- iconv(sampleTwitter, "UTF-8", "ASCII", sub="")
data.sample <- c(sampleBlogs,sampleNews,sampleTwitter)

