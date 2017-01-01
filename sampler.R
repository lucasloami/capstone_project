# generate sample files from the dataset
# sort -R en_US.blogs.txt | head -n 10000 > sample.blogs.txt
# sort -R en_US.news.txt | head -n 10000 > sample.news.txt
# sort -R en_US.twitter.txt | head -n 10000 > sample.twitter.txt

blogs_path <- "datasets/en_US/en_US.blogs.txt"
news_path <- "datasets/en_US/en_US.news.txt"
twitter_path <- "datasets/en_US/en_US.twitter.txt"

con_blogs <- file(blogs_path,open="r")
con_news <- file(news_path,open="r")
con_twitter <- file(twitter_path,open="r")

data.blogs <- readLines(con_blogs)
data.news <- readLines(con_news)
data.twitter <- readLines(con_twitter)

close(con_blogs)
close(con_news)
close(con_twitter)

sampleSize <- 20000

sample.blogs <- data.blogs[sample(1:length(data.blogs), sampleSize)]
sample.news <- data.news[sample(1:length(data.news), sampleSize)]
sample.twitter <- data.twitter[sample(1:length(data.twitter), sampleSize)]

final_sample <- c(sample.blogs, sample.news, sample.twitter)

writeLines(final_sample, "datasets/sample_dataset_20000.txt")

length(final_sample)

rm(con_blogs, con_news, con_twitter, data.blogs, data.news, data.twitter, sample.blogs, sample.news, sample.twitter)