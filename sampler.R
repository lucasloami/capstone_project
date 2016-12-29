# generate sample files from the dataset
# sort -R en_US.blogs.txt | head -n 10000 > sample.blogs.txt
# sort -R en_US.news.txt | head -n 10000 > sample.news.txt
# sort -R en_US.twitter.txt | head -n 10000 > sample.twitter.txt

blogs_path <- "datasets/en_US/sample.blogs.txt"
news_path <- "datasets/en_US/sample.news.txt"
twitter_path <- "datasets/en_US/sample.twitter.txt"

con_blogs <- file(blogs_path,open="r")
con_news <- file(news_path,open="r")
con_twitter <- file(twitter_path,open="r")

blogs <- readLines(con_blogs)
news <- readLines(con_news)
twitter <- readLines(con_twitter)

close(con_blogs)
close(con_news)
close(con_twitter)

final_sample <- c(blogs, news, twitter)

length(final_sample)

final_sample_file_conn <- file("sample_dataset_10000.txt", open="w")
writeLines(final_sample, final_sample_file_conn)
close(final_sample_file_conn)