if (!require("pacman")) install.packages("pacman")

pacman::p_load(shinydashboard)
pacman::p_load(devtools)
devtools::install_github("maciejorlos/medicover")
pacman::p_load(medicover)
pacman::p_load(readr)

pacman::p_load(RSelenium)
pacman::p_load(data.table)
pacman::p_load(rvest)
pacman::p_load(XML)


server <- function(input, output, session) {
  # 
  # rD <- rsDriver(port = 4565L, browser = "chrome", check = F)
  # 
  # 
  # remDr <<- rD[["client"]]
  # medicover::log_into_medicover()
  # 
  observeEvent(input$go, {
    print(nchar(input$login))
    print(nchar(input$login) > 0 & nchar(input$pass) > 0)
    if (nchar(input$login) > 0 & nchar(input$pass) > 0) {    
      
      write.table(x = paste(input$login,
                            input$pass, sep= " "), file = "logloglog.txt",
                row.names = F, quote = F, col.names = F)
      
       
       
      rD <- rsDriver(port = 4565L, browser = "chrome", check = F)
      remDr <<- rD[["client"]]
      
      medicover::log_into_medicover(url = "https://mol.medicover.pl",
                                    credentials_path = "logloglog.txt",
                                    submit_id = "//*[@id=\"oidc-submit\"]")
      medicover::dynamic_url(doctor = "ortopeda", region ="warszawa")
      Sys.sleep(15)
      
      medicover_data <- get_reservation_data(sleep_time = 12, click_break = 5)
      
      
      doctor_names <- unique(medicover_data$doctor_name)
      
      data <- lapply(doctor_names, scrap_doctor_rate)
      data <- rbindlist(data)
      setkey(data, doctor_name)
      setkey(medicover_data, doctor_name)
      full_data <- data[medicover_data]
      
      
      
      
      
      
    } else {
      observe({session$sendCustomMessage(type = 'testmessage',
                                message = "Please enter user name and password"  )  
      })
    }
  })
  
  
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    messageData <- data.frame(from ="Ala", message = "dupa")
    
    
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]])
    })
    
    # This is equivalent to calling:
    #   dropdownMenu(type="messages", msgs[[1]], msgs[[2]], ...)
    dropdownMenu(type = "messages", .list = msgs)
  })
  
  
  output$notificationMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    noteData <- data.frame(status ="danger", text = "dupa zbita")
    
    
    notification <- apply(noteData, 1, function(row) {
      notificationItem(text = row[["text"]], status = row[["status"]],
                       icon = icon("cog", lib = "glyphicon"))
    })
    
    # This is equivalent to calling:
    #   dropdownMenu(type="messages", msgs[[1]], msgs[[2]], ...)
    dropdownMenu(type = "notifications", .list = notification)
  })
  
  
}
