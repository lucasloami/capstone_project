Data Science Specialization
========================================================
author: Lucas Lo Ami
date: 01/01/2017
autosize: true



Introduction
========================================================

This presentation aims to explain how the Coursera Data Science Specialization's Capstone Project was developed during the last six weeks. The objective was to create a machine that predicts next most likely word to be inputted by a user in a text. In other words, the code create works similar to the [SwiftKey App](https://swiftkey.com). A dataset with 60k entries was created using subsets of equal sizes of data from Twitter, news and blogs. Appropriate cleaning techniques were used in the dataset. Also, a n-gram model was used in the dataset as well as a predictive algorithm based on 'Stupid Backoff'. 

- This is an application of Natural Language Processing (NLP).
- A Shiny App was developed as a deliverable for this project. One can find it [here](https://lucasloami.shinyapps.io/capstone_app/). 
- One just need to click in the app link above and follow the instructions described in it. 


Cleaning and storing data
========================================================
The steps to clean and store the dataset properly are:

1. Merge a subset of the SwiftKey's dataset into one file (60k sentences)
2. Clean this new dataset using 'tm' library of R. Profanity words are also removed using [this dataset](http://www.bannedwordlist.com/)
3. Tokenize the dataset and create a Term Document Matrix (TDM). I created 1-gram, 2-gram, 3-gram and 4-gram.
4. Remove sparse itens
5. Transform the TDM's into simple dataframes containing ngrams and their accumulated frequencies (one dataframe per ngram type)
6. Save each dataframe in a RData file

Prediction
========================================================
The algorithm created perform the following steps:

1. Load ngrams RData files into memory
2. Receive sentence input from user (in Shiny App)
3. Clean the input using the same strategies used in training data (described in the previous slide)
4. If the sentence inputted have more than 3 words, try to perform prediction using 4-gram. It captures the last three sentence's words, try to find some 4-gram that contains this substring and, if it finds, return the last word in 4-gram.
5. If the program doesn't find the combinantion of words in 4-gram dataframe, it performs a 'stupid backoff' to the 3-gram dataframe and perform similar actions. 
6. If the program cannot find any combination of ngrams into the training dataset, it returns the most frequent unigram.

Future work
========================================================

Ideas on how to make the application better:

- Use Katz's Back-off model (KBO)
- Benchmark different smoothing techniques in order to check which one performs better in the project
- Improve the corpus and the model based on the user input history
