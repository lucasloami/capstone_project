library(data.table)
library(tm)
library(stringr)

load("unigrams_df.RData")
load("bigrams_df.RData")
load("trigrams_df.RData")
load("fourgrams_df.RData")

sent1 <- "The guy in front of me just bought a pound of bacon a bouquet and a case of";
sent2 <- "You're the reason why I smile everyday. Can you follow me please? It would mean the"
sent3 <- "Very early observations on the Bills game: Offense still struggling but the"
sent4 <- "Be grateful for the good times and keep the faith during the"

cleanSentence <- function(sentence) {
  Encoding(sentence) <- "UTF-8";
  badwords_path <- "datasets/badwords.txt"
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
  print(sentence)
  sentArray <- unlist(strsplit(sentence, split=" "));
  sentLen <- length(sentArray);

  sentence <- cleanSentence(sentence);

  subsetIndex <- (sentLen - 2):sentLen
  res <- predictBasedNGram(sentArray, subsetIndex, fourgram.freq);
  if(res != -1) {
    print("return in fourgram evaluation")
    return(word(res, -1))
  }

  subsetIndex <- (sentLen - 1):sentLen
  res <- predictBasedNGram(sentArray, subsetIndex, trigram.freq);
  if(res != -1) {
    print("return in trigram evaluation")
    return(word(res, -1))
  }

  subsetIndex <- sentLen
  res <- predictBasedNGram(sentArray, subsetIndex, bigram.freq);
  if(res != -1) {
    print("return in bigram evaluation")
    return(word(res, -1))
  }

  print("return in unigram evaluation")
  return(unigram.freq[1,1])
}

predictedWord <- predictNextWord(sent1);
print(predictedWord)
predictedWord <- predictNextWord(sent2);
print(predictedWord)
predictedWord <- predictNextWord(sent3);
print(predictedWord)
predictedWord <- predictNextWord(sent4);
print(predictedWord)