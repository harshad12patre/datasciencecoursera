library(NLP)
library(tm)
library(RColorBrewer)
library(wordcloud)
library(dplyr)
library(stringi)
library(stringr)
library(RWeka)
library(ggplot2)
library(ngram)
library(quanteda)
library(gridExtra)

############

set.seed(1, sample.kind = "Rounding")

############

# blogs
blogs_file <- file("C:/Users/harsh/Desktop/en_US/en_US.blogs.txt","r")
suppressWarnings(blogs <- readLines(blogs_file, encoding="UTF-8"))
close(blogs_file)
# news
news_file <- file("C:/Users/harsh/Desktop/en_US/en_US.news.txt","r")
suppressWarnings(news <- readLines(news_file, encoding="UTF-8"))
close(news_file)
# twitter
twitter_file <- file("C:/Users/harsh/Desktop/en_US/en_US.twitter.txt","r")
suppressWarnings(twitter <- readLines(twitter_file, encoding="UTF-8"))
close(twitter_file)
# bad words
bad_words_file <- file("C:/Users/harsh/Desktop/en_US/bad-words.txt","r")
suppressWarnings(profanity <- readLines(bad_words_file, encoding="UTF-8"))
close(bad_words_file)

#############

sampleBlogs <- blogs[sample(1:length(blogs), 0.001*length(blogs), replace=FALSE)]
sampleNews <- news[sample(1:length(news), 0.001*length(news), replace=FALSE)]
sampleTwitter <- twitter[sample(1:length(twitter), 0.001*length(twitter), replace=FALSE)]
sampleBlogs <- iconv(sampleBlogs, "UTF-8", "ASCII", sub="")
sampleNews <- iconv(sampleNews, "UTF-8", "ASCII", sub="")
sampleTwitter <- iconv(sampleTwitter, "UTF-8", "ASCII", sub="")
data.sample <- c(sampleBlogs,sampleNews,sampleTwitter)
data.sample <- removeWords(data.sample, profanity)
build_corpus <- function (x = data.sample) {
    sample_c <- VCorpus(VectorSource(x)) # Create corpus dataset
    sample_c <- tm_map(sample_c, content_transformer(tolower)) # all lowercase
    sample_c <- tm_map(sample_c, removePunctuation) # Eleminate punctuation
    sample_c <- tm_map(sample_c, removeNumbers) # Eliminate numbers
    sample_c <- tm_map(sample_c, stripWhitespace) # Strip Whitespace
}

corpusData <- build_corpus(data.sample)

#############

getTermTable <- function(corpusData, ngrams = 1, lowfreq = 50) {
    tokenizer <- function(x) {
        NGramTokenizer(x, Weka_control(min = ngrams, max = ngrams))
    }
    tdm <- TermDocumentMatrix(corpusData, control = list(tokenize = tokenizer))
    top_terms <- findFreqTerms(tdm,lowfreq)
    top_terms_freq <- rowSums(as.matrix(tdm[top_terms,]))
    top_terms_freq <- data.frame(word = names(top_terms_freq), frequency = top_terms_freq)
    top_terms_freq <- arrange(top_terms_freq, desc(frequency))
}

tt.Data <- list(3)
for (i in 1:3) {
    tt.Data[[i]] <- getTermTable(corpusData, ngrams = i, lowfreq = 10)
}

tokenFrequency <- function(corpus, n = 1, rem_stopw = NULL) {
    corpus <- dfm(corpus, ngrams = n)
    corpus <- colSums(corpus)
    total <- sum(corpus)
    corpus <- data.frame(names(corpus),
                         corpus,
                         row.names = NULL,
                         check.rows = FALSE,
                         check.names = FALSE,
                         stringsAsFactors = FALSE
    )
    colnames(corpus) <- c("token", "n")
    corpus <- mutate(corpus, token = gsub("_", " ", token))
    corpus <- mutate(corpus, percent = corpus$n / total)
    if (n > 1) {
        corpus$outcome <- word(corpus$token, -1)
        corpus$token <- word(string = corpus$token, start = 1, end = n - 1, sep = fixed(" "))
    }
    setorder(corpus, -n)
    corpus <- getTopThree(corpus)
    return(corpus)
}

freq1ngram <- tt.Data[[1]]
freq2ngram <- tt.Data[[2]]
freq3ngram <- tt.Data[[3]]

predictionMatch <- function(userInput, ngrams) {
    
    # trigram
    if (ngrams == 3) {
        userInput1 <- paste(userInput[length(userInput)-1], userInput[length(userInput)])
        dataTokens <- freq3ngram %>% filter(variable == userInput1)
        ##dataTokens <- freq3ngram %>% filter(token == userInput1)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        # backoff to bigram
        return(predictionMatch(userInput, ngrams - 1))
    }
    
    # bigram
    if (ngrams == 2) {
        userInput1 <- userInput[length(userInput)]
        dataTokens <- freq2ngram %>% filter(variable == userInput1)
        ##dataTokens <- freq2ngram %>% filter(token == userInput1)
        return(dataTokens$outcome[1:3])
        # backoff (1-gram not implemented for enhanced performance)
        # return(match_predict(userInput, ngrams - 1))
    }
    
    # unigram
    if (ngrams == 1) {
        userInput1 <- userInput[length(userInput)]
        dataTokens <- freq2ngram %>% filter(variable == userInput1)
        ##dataTokens <- freq2ngram %>% filter(token == userInput1)
        return(dataTokens$outcome[1:3])
        # backoff (1-gram not implemented for enhanced performance)
        # return(match_predict(userInput, ngrams - 1))
    }
    
}

cleanInput <- function(input) {
    
    # debug
    #print(paste0("input: ", input))
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- tolower(input)
    
    # remove URL, email addresses, Twitter handles and hash tags
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    
    # remove ordinal numbers
    input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case = FALSE, perl = TRUE)
    
    # remove profane words
    input <- removeWords(input, profanity)
    
    # remove punctuation
    input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    
    # remove punctuation (leaving ')
    input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
    
    # trim leading and trailing whitespace
    input <- gsub("^\\s+|\\s+$", "", input)
    input <- stripWhitespace(input)
    
    # debug
    #print(paste0("output: ", input))
    #print("---------------------------------------")
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- unlist(strsplit(input, " "))
    
    return(input)
    
}

predictNextWord <- function(input, word = 0) {
    
    input <- cleanInput(input)
    
    if (input[1] == "") {
        output <- initialPrediction
    } else if (length(input) == 1) {
        output <- predictionMatch(input, ngrams = 1)
    } else if (length(input) == 2) {
        output <- predictionMatch(input, ngrams = 2)
    } else if (length(input) > 2) {
        output <- predictionMatch(input, ngrams = 3)
    }
    
    if (word == 0) {
        return(output)
    } else if (word == 1) {
        return(output[1])
    } else if (word == 2) {
        return(output[2])
    } else if (word == 3) {
        return(output[3])
    }
    
}

shinyServer(function(input, output) {
    
    # original sentence
    output$userSentence <- renderText({input$userInput});
    
    # reactive controls
    observe({
        numPredictions <- input$numPredictions
        if (numPredictions == 1) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- NULL
            output$prediction3 <- NULL
        } else if (numPredictions == 2) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
            output$prediction3 <- NULL
        } else if (numPredictions == 3) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
            output$prediction3 <- reactive({predictNextWord(input$userInput, 3)})
        }
    })
    
})