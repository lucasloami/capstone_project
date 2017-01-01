library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Capstone project - Data Science Specialization"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      p("This application predict the next word the user would write in the text. To use it, just type your text in the box below and hit the 'Predict' button."), 
      p("The app uses a ngram language model based in a corpus composed by blogs' texts, tweets and news' texts. For this project, I used unigrams, bigrams, trigrams and 4-grams and their frequencies to build a dataframe."),
      p("Moreover, this app uses 'stupid backoff' in its predictions."), 
      textInput('iTextVal', 'Insert your text here', ""),
      submitButton("Predict")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h4("You entered:"),
      verbatimTextOutput("oTextVal"),
      h4("The word predicted is:"),
      verbatimTextOutput("oPredictedWord")
    )
  )
))