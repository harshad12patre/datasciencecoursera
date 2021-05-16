Next Word Prediction Web Application
========================================================
author: Harshad Barapatre
date: May 16, 2021
autosize: true

</br>
<h4>Data Science Specialization: Capstone Project</h4>
<h4>By John Hopkins University</h4>
<h4>On Coursera Platform</h4>

Introduction
========================================================

</br>
</br>
For this Capstone Project, I have created a Next Word Prediction Web Application using Natural Language Processing techniques.

The link to the web application is <https://harshad12patre.shinyapps.io/next-word-predictor/>

Getting and Cleaning Data and EDA
========================================================

- The data used to create this product was obtained from Swiftkey. 
- The data contains text from Twitter, news, and blogs.
- The text from these corpora were cleaned and combined into one large corpus.
- Text in the corpus was converted to lower case, stripped of white space, gotten rid of punctuation and special characters, and profane words were removed.
- Tokenization of data (unigrams, bigrams, trigrams, and quadgrams).
- Bar Graphs and Word Cloud to understand the n-grams better.


Next Word Prediction Model
========================================================

- n-grams were loaded from saved .Rds file (unigrams, bigrams, trigrams, and quadgrams).
- The prediction is initially based on the quadgrams (Predict fourth word).
- If that fails, the model uses a backoff strategy to lower n-gram i.e. trigram. 
- If that fails too, the model will use bigrams.
- Unigrams are not used to predict the next word.


How to Use Web Application
========================================================

1.  When the application loads up, click on the text input field and wait until "NULL" is displayed as prediction. Once it is done, the web app is ready to run.
2.  Enter a partially complete sentence to get prediction.

The link to the web application is <https://harshad12patre.shinyapps.io/next-word-predictor/>
