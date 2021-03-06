% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util_ids.R
\name{id_isImg}
\alias{id_isImg}
\alias{id_isCase}
\title{Validation functions for flexibly handling different id scoping}
\usage{
id_isImg(x_chr)

id_isCase(x_chr)
}
\arguments{
\item{x_chr}{character vector to test for id format}
}
\description{
Validation functions for flexibly handling different id scoping
}
\examples{
id_isImg("iu_1_1")
id_isImg("iu")
id_isImg(1)
id_isImg(c("iu_1_1", "iu_4_4"))
id_isCase("iu_1_1")
id_isCase("iu")
id_isCase(1)
id_isCase("1")
id_isCase(c("1", "5", "5000"))
}
