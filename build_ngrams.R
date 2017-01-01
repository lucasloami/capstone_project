library(tm)
library(RWeka)
library(SnowballC)
#library(ggplot2)
#library(data.table)

sample_path <- "datasets/sample_dataset_20000.txt"
badwords_path <- "datasets/badwords.txt"
con <- file(sample_path, open="r")
con2 <- file(badwords_path, open="r")
sample_content <- readLines(con)
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
  corpus <- tm_map(corpus, toSpace, "/|@|\\|") #remove mentions
  corpus <- tm_map(corpus, toSpace, "@\\w+") #remove mentions
  corpus <- tm_map(corpus, toSpace, "#\\w+") #remove hashtags
  corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+") #remove links or URLs
  corpus <- tm_map(corpus, toSpace, "(\\b\\S+\\@\\S+\\..{1,3}(\\s)?\\b)")
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, PlainTextDocument)
  corpus <- tm_map(corpus, removeWords, badwords)
  
 return(corpus)
}

print("processing corpus and cleaning it")
corpus <- buildProcessedCorpus(sample_content = sample_content)

rm(sample_content, badwords)

ngram_freqency <- function(tokenized_corpus, low_frequency=5) {
  most_freq_terms <- findFreqTerms(tokenized_corpus, lowfreq = low_frequency)
  print("before as.matrix function")
  a <- as.matrix(tokenized_corpus[most_freq_terms,])
  print("before rowSums")
  term_freq <- sort(rowSums(a), decreasing = TRUE)
  term_freq_df <- data.frame(ngram=names(term_freq), frequency=term_freq)
  return(term_freq_df)
}

unigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
bigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
fourgram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

print("unigram_tokenizer")
unigram <- TermDocumentMatrix(corpus, control=list(tokenize=unigram_tokenizer))
unigram <- removeSparseTerms(unigram, 0.9999)
unigram.freq <- ngram_freqency(unigram, 50)
save(unigram.freq, file="unigrams_df.RData");
rm(unigram.freq)
rm(unigram)

print("bigram_tokenizer");
bigram <- TermDocumentMatrix(corpus, control=list(tokenize=bigram_tokenizer));
bigram <- removeSparseTerms(bigram, 0.9999);
bigram.freq <- ngram_freqency(bigram, 20);
save(bigram.freq, file="bigrams_df.RData");
rm(bigram.freq)
rm(bigram)

print("trigram_tokenizer")
trigram <- TermDocumentMatrix(corpus, control=list(tokenize=trigram_tokenizer))
trigram <- removeSparseTerms(trigram, 0.9999)
trigram.freq <- ngram_freqency(trigram, 10)
save(trigram.freq, file="trigrams_df.RData");
rm(trigram.freq)
rm(trigram)

print("fourgram_tokenizer")
fourgram <- TermDocumentMatrix(corpus, control=list(tokenize=fourgram_tokenizer))
fourgram <- removeSparseTerms(fourgram, 0.9999)
fourgram.freq <- ngram_freqency(fourgram, 10)
save(fourgram.freq, file="fourgrams_df.RData");
rm(fourgram.freq)
rm(fourgram)


# build_plot <- function(df, max_size, title, xLabText, yLabText) {
#   df <- df[1:max_size,]
#   g <- ggplot(df, aes(x=reorder(ngram, frequency), y=frequency)) +
#       geom_bar(stat = "identity") +  coord_flip() +
#       theme(legend.title=element_blank()) +
#       xlab(xLabText) + ylab(yLabText) +
#       labs(title = title)
#   print(g)
# }

# build_plot(unigram.freq, 10, "Top 10 Unigrams distribution", "Unigrams", "Frequency")

