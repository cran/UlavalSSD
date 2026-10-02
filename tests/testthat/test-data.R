test_that("weather retains the course schema and complete date index", {
  weather <- as.data.frame(MeteoQuebec)
  expect_identical(dim(weather), c(20111L, 11L))
  expect_identical(names(weather), c(
    "...1", "year", "month", "day", "max_temp",
    "mean_temp", "min_temp", "total_precip", "total_rain", "total_snow",
    "snow_grnd"
  ))
  expect_type(weather$month, "character")
  expect_type(weather$day, "character")
  dates <- as.Date(with(weather, paste(year, month, day, sep = "-")))
  expect_equal(dates, seq(as.Date("1970-01-01"), as.Date("2025-01-22"),
    by = "day"
  ))
  expect_identical(
    unname(colSums(is.na(weather))),
    c(0, 0, 0, 0, 53, 54, 40, 97, 10490, 10587, 8912)
  )
})

test_that("administrative snapshot retains raw text and UTC dates", {
  records <- as.data.frame(listecondamnation)
  expect_identical(dim(records), c(1712L, 10L))
  expect_identical(names(records), c(
    "Nom_exploitant", "Raison_sociale",
    "Description_infraction", "Adresse_lieu_infraction", "Type_etablissement",
    "Date_infraction", "Date_jugement", "Date_publication", "Amende",
    "SOC_NOM_ARTCL_INFRC"
  ))
  expect_type(records$Amende, "character")
  for (column in c("Date_infraction", "Date_jugement", "Date_publication")) {
    expect_s3_class(records[[column]], "POSIXct")
    expect_identical(attr(records[[column]], "tzone"), "UTC")
  }
  expect_equal(
    range(as.Date(records$Date_publication)),
    as.Date(c("2023-02-13", "2025-02-10"))
  )
})
