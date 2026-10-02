style_result <- function(text, extension = ".R") {
  skip_if_not_installed("lintr", minimum_version = "3.4.0")
  path <- tempfile(fileext = extension)
  on.exit(unlink(path))
  writeLines(text, path, useBytes = TRUE)
  eval_tidyverse_style(path)
}

test_that("valid code is checked syntactically and scores are bounded", {
  clean <- style_result(c(
    'message_text <- "A = B"',
    "average <- mean(c(2, 4), na.rm = TRUE)"
  ))
  expect_equal(clean$total, 20)
  expect_true(is.na(clean$scores$coherence))
  expect_true(is.na(clean$scores$commentaires))
  expect_equal(nrow(clean$diagnostics), 0)
  bad <- style_result("BadName=1;")
  expect_equal(bad$scores$assignation, 0)
  expect_equal(bad$scores$nommage_objets, 0)
  expect_equal(bad$scores$conventions, 0)
  expect_true(bad$total >= 0 && bad$total <= 20)
  expect_true(all(bad$diagnostics$line == 1L))
})

test_that("empty and unparseable submissions receive no grade", {
  for (text in list(character(), "", "# Only a comment")) {
    result <- style_result(text)
    expect_identical(result$status, "empty")
    expect_true(is.na(result$total))
    expect_true(all(is.na(unlist(result$scores))))
  }
  broken <- style_result("x <-")
  expect_identical(broken$status, "parse_error")
  expect_true(is.na(broken$total))
  expect_true(any(broken$diagnostics$type == "error"))
})

test_that("Quarto prose, non-R fences and options do not affect style", {
  text <- c(
    "---", "title: A Long Title", "---", strrep("Prose ", 50),
    "```{python}", "BAD = 1", "```", "```{r label}",
    "#| eval: false", 'value <- "Text = Fine"', "```",
    "~~~{r}", "other=2", "~~~"
  )
  result <- style_result(text, ".qmd")
  expect_identical(result$status, "ok")
  expect_equal(result$scores$longueur_lignes, 2)
  expect_equal(result$scores$nommage_objets, 2)
  expect_true(all(result$diagnostics$line == 13L))
  expect_identical(style_result("Only prose.", ".qmd")$status, "empty")
  expect_error(style_result(c("```{r}", "x <- 1"), ".qmd"), "Unclosed")
  # Each chunk must parse independently, just as it must during a render.
  broken <- style_result(
    c("```{r}", "x <-", "```", "```{r}", "1", "```"),
    ".qmd"
  )
  expect_identical(broken$status, "parse_error")
})

test_that("inspection executes neither source code nor project configuration", {
  skip_if_not_installed("lintr", minimum_version = "3.4.0")
  directory <- tempfile()
  dir.create(directory)
  on.exit(unlink(directory, recursive = TRUE))
  marker <- file.path(directory, "must-not-exist")
  command <- paste0("file.create(", encodeString(marker, quote = '"'), ")")
  writeLines(paste0("linters: ", command), file.path(directory, ".lintr"))
  path <- file.path(directory, "submission.R")
  writeLines(command, path)
  result <- eval_tidyverse_style(path)
  expect_identical(result$status, "ok")
  expect_false(file.exists(marker))
})

test_that("file validation rejects unsuitable inputs", {
  for (value in list(NULL, NA, "", c("a.R", "b.R"))) {
    expect_error(eval_tidyverse_style(value), "file_path")
  }
  expect_error(eval_tidyverse_style("example.txt"), "extension")
  expect_error(eval_tidyverse_style(tempfile(fileext = ".R")), "readable")
})


test_that("chunk options retain line positions inside a chunk", {
  result <- style_result(c("```{r}", "x <- 1", "#| echo: true", "y=2", "```"),
                         ".qmd")
  expect_true(all(result$diagnostics$line == 4L))
})
