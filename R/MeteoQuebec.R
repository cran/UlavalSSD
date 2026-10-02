#' Historical Daily Weather Observations from Quebec
#'
#' A fixed teaching snapshot of 20,111 daily records, from 1970-01-01 to
#' 2025-01-22 inclusive. Missing observations are retained for data-cleaning
#' exercises. Values, column order and original classes are preserved from
#' version 0.2.1 for compatibility with existing course materials.
#'
#' @format A data frame with classes `spec_tbl_df`, `tbl_df`, `tbl`, and
#'   `data.frame`, containing 20,111 rows and 11 columns:
#' \describe{
#'   \item{...1}{Numeric row identifier in the original export, not a weather
#'     measurement.}
#'   \item{year}{Year, numeric.}
#'   \item{month}{Month as a two-character string, `"01"` to `"12"`.}
#'   \item{day}{Day as a two-character string, `"01"` to `"31"`.}
#'   \item{max_temp}{Daily maximum temperature, degrees Celsius.}
#'   \item{mean_temp}{Daily mean temperature, degrees Celsius.}
#'   \item{min_temp}{Daily minimum temperature, degrees Celsius.}
#'   \item{total_precip}{Daily total precipitation, millimetres.}
#'   \item{total_rain}{Daily rainfall, millimetres.}
#'   \item{total_snow}{Daily snowfall, centimetres.}
#'   \item{snow_grnd}{Snow on the ground, centimetres.}
#' }
#' All measurement columns are numeric and may contain `NA`. Dates have no
#' gaps or duplicates, but this does not imply complete measurements.
#'
#' @details The original teaching snapshot was attributed to 'weathercan'.
#'   An independent reconstruction on 2026-09-22 matched all 11 columns,
#'   including missing values, using the ECCC GeoMet climate-daily service:
#'   station 5251 (climate identifier 7016294) through 1995-12-31, then station
#'   26892 (701S001) from 1996-01-01. The original extraction date is unknown;
#'   the reconstruction and a source manifest are provided in the repository.
#'   It establishes the contents, not the homogeneity of the climate series.
#'   Station changes and missing observations require further assessment before
#'   trend estimation. Rain, snowfall and snow-depth measurements are missing
#'   for substantial portions of the series. There is no automatic refresh.
#' @source Data source: Environment and Climate Change Canada (ECCC).
#'   Daily observations were independently retrieved and verified on 2026-09-22:
#'   <https://api.weather.gc.ca/collections/climate-daily>.
#'   Reproduced under the ECCC Data Services End-use Licence:
#'   <https://eccc-msc.github.io/open-data/licence/readme_en/>.
#'   The package is not endorsed by ECCC. See the installed `COPYRIGHTS` file.
#' @examples
#' weather <- as.data.frame(MeteoQuebec)
#' weather$date <- as.Date(with(weather, paste(year, month, day, sep = "-")))
#' range(weather$date)
#' colSums(is.na(weather))
#' head(weather[c("date", "min_temp", "max_temp")])
"MeteoQuebec"
