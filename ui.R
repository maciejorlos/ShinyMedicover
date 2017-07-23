library(shinydashboard)



header <- dashboardHeader(title = "Medicover Reservation",  
                dropdownMenuOutput("messageMenu"),
                dropdownMenuOutput("notificationMenu")
)


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Log Panel", icon = icon("th"), tabName = "logpanel",
             badgeLabel = "Do it first", badgeColor = "green")
  ,
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
  )
)



body <- dashboardBody(

  fluidRow(
    singleton(
      tags$head(tags$script(src = "message-handler.js"))
    ),
  tabItems(
    tabItem(tabName = "logpanel",
            solidHeader = TRUE,
            collapsible = TRUE,
            h2("Log into Medicover"),
            box(
                h3("Submit your credentials"),
                textInput("login", "Login"),
                textInput("pass", "Password"),
                actionButton("go", "Go")
            )),
    tabItem(tabName = "dashboard",
            fluidRow(
              box(plotOutput("plot1", height = 250))
            )
            )
  )
)
)


dashboardPage(
              header,
              sidebar,
              body
              )
