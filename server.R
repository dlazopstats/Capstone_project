
# N- grams
bi_gram <- readRDS("bigram.RData")
tre_gram <- readRDS("trigram.RData")
four_gram <- readRDS("quadgram.RData")

# bad words 
badWordsFile <- "bad_words.txt"
con <- file(badWordsFile, open = "r")
profanity <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
profanity <- iconv(profanity, "latin1", "ASCII", sub = "")
close(con)

predictive_model <- function(userInput, ngrams) {
    if (ngrams > 3) {
        userInput3 <- paste(userInput[length(userInput) - 2],
                            userInput[length(userInput) - 1],
                            userInput[length(userInput)])
        dataTokens <- four_gram %>% filter(variable == userInput3)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        return(predictive_model(userInput, ngrams - 1))
    }
    if (ngrams == 3) {
        userInput1 <- paste(userInput[length(userInput)-1], userInput[length(userInput)])
        dataTokens <- tre_gram %>% filter(variable == userInput1)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        return(predictive_model(userInput, ngrams - 1))
    }
    if (ngrams < 3) {
        userInput1 <- userInput[length(userInput)]
        dataTokens <- bi_gram %>% filter(variable == userInput1)
        return(dataTokens$outcome[1:3])
    }
    return(NA)
}

cleaning <- function(input) {
    if (input == "" | is.na(input)) {
        return("")
    }
    input <- tolower(input)
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case = FALSE, perl = TRUE)
    input <- removeWords(input, profanity)
    input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("^\\s+|\\s+$", "", input)
    input <- stripWhitespace(input)
    if (input == "" | is.na(input)) {
        return("")
    }
    input <- unlist(strsplit(input, " "))
    return(input)
}

predict_word <- function(input, word = 0) {
    
    input <- cleaning(input)
    
    if (input[1] == "") {
        output <- ""
    } else if (length(input) == 1) {
        output <- predictive_model(input, ngrams = 2)
    } else if (length(input) == 2) {
        output <- predictive_model(input, ngrams = 3)
    } else if (length(input) > 2) {
        output <- predictive_model(input, ngrams = 4)
    }
    
    if (word == 0) {
        return(output)
    } else if (word == 1) {
        return(output[1])
    } else if (word == 2) {
        return(output[2])
    } else if (word == 3) {
        return(output[3])
    }
    
}

shinyServer(function(input, output) {
    output$userSentence <- renderText({input$userInput});
    observe({
        numPredictions <- input$numPredictions
        if (numPredictions == 1) {
            output$prediction1 <- reactive({predict_word(input$userInput, 1)})
            output$prediction2 <- NULL
            output$prediction3 <- NULL
        } else if (numPredictions == 2) {
            output$prediction1 <- reactive({predict_word(input$userInput, 1)})
            output$prediction2 <- reactive({predict_word(input$userInput, 2)})
            output$prediction3 <- NULL
        } else if (numPredictions == 3) {
            output$prediction1 <- reactive({predict_word(input$userInput, 1)})
            output$prediction2 <- reactive({predict_word(input$userInput, 2)})
            output$prediction3 <- reactive({predict_word(input$userInput, 3)})
        }
    })
    
})