## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----load---------------------------------------------------------------------
library(UlavalSSD)

## ----weather------------------------------------------------------------------
weather <- as.data.frame(MeteoQuebec)
weather$date <- as.Date(with(weather, paste(year, month, day, sep = "-")))
range(weather$date)
head(weather[c("date", "min_temp", "max_temp")])

## ----missing------------------------------------------------------------------
measurements <- c(
  "max_temp", "mean_temp", "min_temp", "total_precip",
  "total_rain", "total_snow", "snow_grnd"
)
data.frame(
  variable = measurements,
  missing = vapply(weather[measurements], function(x) sum(is.na(x)), integer(1)),
  missing_proportion = vapply(
    weather[measurements], function(x) mean(is.na(x)),
    numeric(1)
  ),
  row.names = NULL
)

## ----plot, fig.width=6, fig.height=3.5, fig.alt="Daily minimum temperatures during 2024 in the historical teaching snapshot."----
one_year <- weather[weather$year == 2024, , drop = FALSE]
plot(one_year$date, one_year$min_temp,
  type = "l",
  xlab = "Date", ylab = "Daily minimum temperature (degrees C)"
)

## ----records------------------------------------------------------------------
records <- as.data.frame(listecondamnation)
range(as.Date(records$Date_publication))
head(sort(table(records$Type_etablissement), decreasing = TRUE))

## ----amounts------------------------------------------------------------------
amount_text <- c("1 500 $", "250,50 $", NA_character_)
amount_clean <- gsub("[ $]", "", amount_text)
amount_clean <- sub(",", ".", amount_clean, fixed = TRUE)
valid <- is.na(amount_clean) | grepl("^[0-9]+([.][0-9]{1,2})?$", amount_clean)
stopifnot(all(valid))
amount <- as.numeric(amount_clean)
data.frame(amount_text, amount)

## ----prompts------------------------------------------------------------------
consulter_taches("histogramme", lang = "en")
verifier_valeur_aberrante(11, lang = "en")

## ----style--------------------------------------------------------------------
if (requireNamespace("lintr", quietly = TRUE)) {
  path <- tempfile(fileext = ".R")
  writeLines(c("daily_mean <- mean(c(2, 4, 6))", "print(daily_mean)"), path)
  feedback <- eval_tidyverse_style(path)
  feedback[c("total", "status", "diagnostics")]
  unlink(path)
}

## ----attribution--------------------------------------------------------------
system.file("COPYRIGHTS", package = "UlavalSSD")

