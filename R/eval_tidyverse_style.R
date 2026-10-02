#' Static Style Feedback for R and Quarto Files
#'
#' Inspect R code without executing it, using a fixed set of 'lintr' checks.
#' The result is a formative indicator, not a validated grade or a measure of
#' statistical correctness. Project-specific '.lintr' settings are ignored.
#'
#' @param file_path Path to an existing UTF-8 `.R` or `.qmd` file.
#' @details Each of seven observable criteria receives 2 points if its linters
#'   report no issue and 0 otherwise. `total` rescales these points to 0--20.
#'   `coherence` and `commentaires` are always `NA`: meaningful comments and
#'   reasoning require human review. Empty, comment-only or syntactically
#'   invalid code receives `NA` for every score and for `total`.
#'
#'   In Quarto documents, only fenced R chunks are inspected. Backtick and tilde
#'   fences of at least three characters, with up to three leading spaces, are
#'   supported. Prose, inline R, chunk options and other languages are excluded.
#'   An unclosed R fence is an error. Diagnostic line numbers refer to the
#'   original file. Chunks are inspected statically even when `eval: false`.
#'
#'   The criteria cover indentation; operator, comma and parenthesis spacing;
#'   80-character lines; assignment with `<-`; snake-case object names; braces;
#'   and trailing whitespace and semicolons. A criterion with no applicable
#'   construct has no reported issue. The score therefore cannot compare the
#'   difficulty or completeness of different submissions.
#'
#' @return A list with `scores` (the nine named criteria retained from earlier
#'   versions), `total`, `max_total` (20), `status` (`"ok"`, `"empty"`, or
#'   `"parse_error"`), and `diagnostics`, a data frame of line, column, type,
#'   message and linter. The optional package 'lintr' must be installed.
#' @references Hester, J., Angly, F., Chirico, M., Hyde, R., Kun, R., Patil, I.,
#'   and Rosenstock, A. (2025). Static Code Analysis for R. Journal of Open
#'   Source Software, 10(108), 7240. \doi{10.21105/joss.07240}.
#' @examples
#' if (requireNamespace("lintr", quietly = TRUE)) {
#'   path <- tempfile(fileext = ".R")
#'   writeLines(c("daily_mean <- mean(c(2, 4, 6))", "print(daily_mean)"), path)
#'   result <- eval_tidyverse_style(path)
#'   result$total
#'   unlink(path)
#' }
#' @export
eval_tidyverse_style <- function(file_path) {
  check_character_scalar(file_path, "file_path")
  extension <- tolower(tools::file_ext(file_path))
  if (!extension %in% c("r", "qmd")) {
    stop("`file_path` must have an .R or .qmd extension.", call. = FALSE)
  }
  if (!file.exists(file_path) || isTRUE(file.info(file_path)$isdir) ||
    file.access(file_path, 4L) != 0L) {
    stop("`file_path` must be a readable file.", call. = FALSE)
  }
  if (!requireNamespace("lintr", quietly = TRUE)) {
    stop("Install the optional package 'lintr' to use this function.",
      call. = FALSE
    )
  }
  lines <- readLines(file_path, warn = FALSE, encoding = "UTF-8")
  if (extension == "qmd") {
    lines <- extract_r_chunks(lines)
  }
  chunk_ids <- attr(lines, "chunk_ids")
  chunks <- if (is.null(chunk_ids)) {
    list(lines)
  } else {
    lapply(
      split(which(chunk_ids > 0L), chunk_ids[chunk_ids > 0L]),
      function(indices) c(rep("", min(indices) - 1L), lines[indices])
    )
  }
  criterion_names <- c(
    "syntaxe_indentation", "espaces_lisibilite", "longueur_lignes",
    "assignation", "nommage_objets", "style_fonctions", "coherence",
    "commentaires", "conventions"
  )
  result <- list(
    scores = as.list(stats::setNames(rep(NA_real_, 9L), criterion_names)),
    total = NA_real_, max_total = 20, status = "empty",
    diagnostics = data.frame(
      line = integer(), column = integer(), type = character(),
      message = character(), linter = character(), stringsAsFactors = FALSE
    )
  )
  # Parse only: neither student code nor project configuration is evaluated.
  parsed <- lapply(chunks, function(chunk) {
    tryCatch(parse(text = chunk, keep.source = TRUE), error = identity)
  })
  parse_error <- any(vapply(parsed, inherits, logical(1), what = "error"))
  if (!parse_error && all(lengths(parsed) == 0L)) {
    return(result)
  }
  groups <- list(
    syntaxe_indentation = "indentation_linter",
    espaces_lisibilite = c(
      "infix_spaces_linter", "commas_linter",
      "function_left_parentheses_linter", "paren_body_linter"
    ),
    longueur_lignes = "line_length_linter",
    assignation = "assignment_linter",
    nommage_objets = "object_name_linter",
    style_fonctions = "brace_linter",
    conventions = c("trailing_whitespace_linter", "semicolon_linter")
  )
  checks <- list(
    indentation_linter = lintr::indentation_linter(indent = 2L),
    infix_spaces_linter = lintr::infix_spaces_linter(),
    commas_linter = lintr::commas_linter(),
    function_left_parentheses_linter =
      lintr::function_left_parentheses_linter(),
    paren_body_linter = lintr::paren_body_linter(),
    line_length_linter = lintr::line_length_linter(length = 80L),
    assignment_linter = lintr::assignment_linter(operator = "<-"),
    object_name_linter = lintr::object_name_linter(styles = "snake_case"),
    brace_linter = lintr::brace_linter(),
    trailing_whitespace_linter = lintr::trailing_whitespace_linter(),
    semicolon_linter = lintr::semicolon_linter()
  )
  lints <- do.call(c, lapply(chunks, function(chunk) {
    lintr::lint(
      text = chunk, linters = checks, cache = FALSE, parse_settings = FALSE
    )
  }))
  if (length(lints)) {
    result$diagnostics <- do.call(rbind, lapply(lints, function(item) {
      data.frame(
        line = as.integer(item$line_number),
        column = as.integer(item$column_number),
        type = item$type, message = item$message,
        linter = item$linter, stringsAsFactors = FALSE
      )
    }))
    rownames(result$diagnostics) <- NULL
  }
  if (parse_error || any(result$diagnostics$type == "error")) {
    result$status <- "parse_error"
    return(result)
  }
  for (criterion in names(groups)) {
    has_issue <- any(result$diagnostics$linter %in% groups[[criterion]])
    result$scores[[criterion]] <- if (has_issue) 0 else 2
  }
  result$total <- 20 * sum(unlist(result$scores), na.rm = TRUE) / 14
  result$status <- "ok"
  result
}

# Retain blank lines for prose so diagnostic positions match the source file.
extract_r_chunks <- function(lines) {
  code <- rep("", length(lines))
  chunk_ids <- integer(length(lines))
  chunk_number <- 0L
  fence_character <- ""
  fence_length <- 0L
  in_r <- FALSE
  for (i in seq_along(lines)) {
    line <- lines[[i]]
    if (!nzchar(fence_character)) {
      opening <- regexec("^ {0,3}(`{3,}|~{3,})(.*)$", line)
      parts <- regmatches(line, opening)[[1L]]
      if (length(parts)) {
        fence_character <- substr(parts[[2L]], 1L, 1L)
        fence_length <- nchar(parts[[2L]])
        in_r <- grepl("^\\{[rR]([ ,}]|$)", trimws(parts[[3L]]))
        if (in_r) chunk_number <- chunk_number + 1L
      }
    } else {
      closing <- paste0(
        "^ {0,3}", fence_character, "{", fence_length,
        ",}[ \\t]*$"
      )
      if (grepl(closing, line)) {
        fence_character <- ""
        in_r <- FALSE
      } else if (in_r) {
        chunk_ids[[i]] <- chunk_number
        if (!grepl("^[ \\t]*#\\|", line)) code[[i]] <- line
      }
    }
  }
  if (in_r) {
    stop("Unclosed R code fence in the Quarto document.", call. = FALSE)
  }
  attr(code, "chunk_ids") <- chunk_ids
  code
}
