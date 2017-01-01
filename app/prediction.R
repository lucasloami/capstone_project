library(data.table)
library(tm)
library(stringr)

load("data/unigrams_df.RData")
load("data/bigrams_df.RData")
load("data/trigrams_df.RData")
load("data/fourgrams_df.RData")

cleanSentence <- function(sentence) {
  Encoding(sentence) <- "UTF-8";
  badwords_path <- "data/badwords.txt"
  con2 <- file(badwords_path, open="r")
  badwords <- readLines(con2)
  close(con2)
  rm(con2)

  #remove non alphanum chars
  sentence <- gsub("[^[:alpha:][:space:][:punct:]]", "", sentence);

  simple_corpus <- VCorpus(VectorSource(sentence))

  toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
  simple_corpus <- tm_map(simple_corpus, toSpace, "@[^\\s]+") #remove mentions
  simple_corpus <- tm_map(simple_corpus, toSpace, "#[^\\s]+") #remove hashtags
  simple_corpus <- tm_map(simple_corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+") #remove links or URLs
  simple_corpus <- tm_map(simple_corpus, tolower)
  simple_corpus <- tm_map(simple_corpus, removePunctuation)
  simple_corpus <- tm_map(simple_corpus, removeNumbers)
  simple_corpus <- tm_map(simple_corpus, stripWhitespace)
  simple_corpus <- tm_map(simple_corpus, removeWords, badwords)

  sentence <- simple_corpus[[1]] 
  rm(badwords, simple_corpus)

  return(sentence)
}

predictBasedNGram <- function(sentArray, subsetIndex, df) {
  search <- paste(sentArray[subsetIndex],  collapse = " ");
  search <- paste("^", search, sep="");

  tmp <- df[grep(search, df$ngram), ];

  if(length(tmp[,1]) > 0) {
    return(tmp[1,1])
  } else {
    return(-1)
  }
}


predictNextWord <- function(sentence) {
  if(sentence == "")
    return()

  sentArray <- unlist(strsplit(sentence, split=" "));
  sentLen <- length(sentArray);

  sentence <- cleanSentence(sentence);

  subsetIndex <- (sentLen - 2):sentLen
  res <- predictBasedNGram(sentArray, subsetIndex, fourgram.freq);
  if(res != -1) {
    return(word(res, -1))
  }

  subsetIndex <- (sentLen - 1):sentLen
  res <- predictBasedNGram(sentArray, subsetIndex, trigram.freq);
  if(res != -1) {
    return(word(res, -1))
  }

  subsetIndex <- sentLen
  res <- predictBasedNGram(sentArray, subsetIndex, bigram.freq);
  if(res != -1) {
    return(word(res, -1))
  }

  return(unigram.freq[1,1])
}