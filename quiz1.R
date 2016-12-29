library(tm)
library(RWeka)
library(SnowballC)

sample_path <- "datasets/sample_dataset_10000.txt"
badwords_path <- "datasets/badwords.txt"
con <- file(sample_path, open="r")
con2 <- file(badwords_path, open="r")
sample_content <- readLines(con, encoding="UTF-8", skipNul=TRUE)
badwords <- readLines(con2, encoding="UTF-8", skipNul=TRUE)
close(con)
close(con2)
rm(con)
rm(con2)

# Create corpus from sample
buildProcessedCorpus <- function(sample_content) {
  corpus <- VCorpus(VectorSource(sample_content))
  
  # preprocess corpus removing unnecessary information
  toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
  corpus <- tm_map(corpus, toSpace, "@[^\\s]+") #remove mentions
  corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+") #remove links or URLs
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, PlainTextDocument)
  corpus <- tm_map(corpus, removeWords, badwords)
  # summary(corpus)
  # inspect(corpus)
  
 return(corpus)
}

corpus <- buildProcessedCorpus(sample_content = sample_content)

uniGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
triGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))

uniGramTDM <- TermDocumentMatrix(corpus, control = list(tokenize = NGramTokenizer))
biGramTDM <- TermDocumentMatrix(corpus, control = list(tokenize = biGramTokenizer))
triGramTDM <- TermDocumentMatrix(corpus, control = list(tokenize = triGramTokenizer))
