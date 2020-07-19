library(shiny)
library(shinythemes)
library(markdown)
library(dplyr)
library(tm)

shinyUI(
    navbarPage("NATURAL LENGUAGE PROCESSING",
               theme = shinytheme("sandstone"),
               tabPanel("Word Prediction",
                        fluidPage(
                            titlePanel(""),
                            sidebarLayout(
                                sidebarPanel(
                                    textInput("userInput",
                                              "Enter a word or phrase:",
                                              value =  "",
                                              placeholder = "Enter text here"),
                                    br(),
                                    radioButtons("numPredictions", h3("Number of Predictions:"),
                                                 choices = list("1 word" = 1, "2 words" = 2,
                                                                "3 words" = 3),selected = 1)
                                    
                                ),
                                mainPanel(
                                     h4("Input text"),
                                    verbatimTextOutput("userSentence"),
                                    br(),
                                    h4("Results"),
                                    h4("The predicted word(s)with highest probability is (are):"),
                                    verbatimTextOutput("prediction1"),
                                    verbatimTextOutput("prediction2"),
                                    verbatimTextOutput("prediction3")
                                )
                            )
                        )
               ),
               tabPanel("README",
                        h3("Word Predicting Modelling"),
                        br(),
                        div("The Webapp uses a natural lenguage processing algorithm to predict the next word(s)
                            based on text entered.",
                            br(),
                            br(),
                            "When entering text, please allow a few
                            seconds for the output to appear. You can select up to three next word predictions."),
                        br(),
                        h3("About Me"),
                        br(),
                        div("My name is Diego Lazo and I am a Data Scientist at TASA ",
                            br(),
                            br(),
                            "My work includes statistical modelling and machine learning",
                            br(),
                            br(),
                            "I have a degree in Industrial Engineering and a Master degree in Mathematics",
                            br(),
                            br(),
                            "I graduated from Saint Peter University, Arequipa,Peru.")
               )
    )
)