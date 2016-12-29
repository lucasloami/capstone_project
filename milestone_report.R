library(tm)
library(RWeka)
library(SnowballC)
library(ggplot2)

sample_path <- "datasets/sample_dataset_10000.txt"
badwords_path <- "datasets/badwords.txt"
con <- file(sample_path, open="r")
con2 <- file(badwords_path, open="r")
sample_content <- readLines(con)
sample_content <- (sample_content[!is.na(sample_content)])
# sample_content <- iconv(sample_content, 'UTF-8', 'ASCII')
badwords <- readLines(con2)
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
  corpus <- tm_map(corpus, toSpace, "#[^\\s]+") #remove hashtags
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

summary(corpus)

uniGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
triGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))

uniGramTDM <- TermDocumentMatrix(corpus, control = list(tokenize = uniGramTokenizer))
biGramTDM <- TermDocumentMatrix(corpus, control = list(tokenize = biGramTokenizer))
triGramTDM <- TermDocumentMatrix(corpus, control = list(tokenize = triGramTokenizer))

# print("cheguei ao final")

uniGramTDM <- removeSparseTerms(uniGramTDM, 0.9999)
biGramTDM <- removeSparseTerms(biGramTDM, 0.9999)
triGramTDM <- removeSparseTerms(triGramTDM, 0.9999)

uniGramFreqTerms <- findFreqTerms(uniGramTDM, lowfreq = 2000)
termFrequency <- rowSums(as.matrix(uniGramTDM[uniGramFreqTerms,]))
termFrequency <- data.frame(unigram=names(termFrequency), frequency=termFrequency)

# Print most frequent unigrams 
g <- ggplot(termFrequency, aes(x=reorder(unigram, frequency), y=frequency)) +
    geom_bar(stat = "identity") +  coord_flip() +
    theme(legend.title=element_blank()) +
    xlab("Unigram") + ylab("Frequency") +
    labs(title = "Top Unigrams by Frequency")
print(g)
