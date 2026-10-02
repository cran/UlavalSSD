test_that("all course prompts are available in both languages", {
  sections <- c(
    "histogramme", "nuage_de_points", "statistiques_descriptives",
    "Visualisation_statistiques_descriptives"
  )
  for (section in sections) {
    expect_type(consulter_taches(section), "character")
    expect_length(consulter_taches(section), 1L)
    expect_false(identical(
      consulter_taches(section),
      consulter_taches(section, lang = "en")
    ))
  }
  expect_match(verifier_valeur_aberrante(6), "193mm", fixed = TRUE)
  expect_match(verifier_valeur_aberrante(11), "37.8 mm", fixed = TRUE)
  expect_match(verifier_valeur_aberrante(11, "en"), "3300 g", fixed = TRUE)
  expect_match(verifier_valeur_aberrante(10, "en"), "not one of the two")
})

test_that("malformed exercise inputs fail informatively", {
  for (input in list(NULL, NA, character(), c("a", "b"), 1, "", "unknown")) {
    expect_error(consulter_taches(input), "section")
  }
  for (input in list(NULL, NA, Inf, NaN, 0, -1, 1.5, 6 + 1i, "6", c(6, 11), TRUE)) {
    expect_error(verifier_valeur_aberrante(input), "ligne")
  }
  for (input in list(NULL, NA, c("fr", "en"), "de", 1)) {
    expect_error(consulter_taches("histogramme", input), "lang")
    expect_error(verifier_valeur_aberrante(6, input), "lang")
  }
})
