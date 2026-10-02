# Validate arguments without coercing malformed student input.
check_character_scalar <- function(value, argument) {
  if (!is.character(value) || length(value) != 1L || is.na(value) ||
    !nzchar(value)) {
    stop("`", argument, "` must be one non-empty character string.", call. = FALSE)
  }
  invisible(value)
}

check_language <- function(lang) {
  check_character_scalar(lang, "lang")
  if (!lang %in% c("fr", "en")) {
    stop("`lang` must be 'fr' or 'en'.", call. = FALSE)
  }
  lang
}
