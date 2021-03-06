% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/module_annotationReportOutput.R
\name{annotationReportOutput}
\alias{annotationReportOutput}
\alias{annotationReportModule}
\title{Show statistics of a user's saved annotations data}
\usage{
annotationReportOutput(id)

annotationReportModule(input, output, session, app, userName)
}
\arguments{
\item{id}{chr(1) namespace for the module, decided by the caller at the time the module is used}

\item{input, output, session}{standard args to shiny server routine}

\item{app}{chr(1) name of application data directory in candiOpt(app_data_dir)}

\item{userName}{reactive that returns a chr(1) with the users name of data to fetch}
}
\value{
\code{\link[shiny]{tagList}} of ui components
}
\description{
Show statistics of a user's saved annotations data
}
\examples{
shinyApp(
    ui = fluidPage(
        shinyjs::useShinyjs(),
        shiny::textInput("user_name", "User Name", "Marcus"),
        annotationReportOutput("ann_rpt")
    ),
    server = function(input, output, session) {
        callModule(annotationReportModule, "ann_rpt", app = "rad_case", userName = reactive(input$user_name))
    }
)
}
