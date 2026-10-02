#' Prompts for a Penguin Data-Cleaning Exercise
#'
#' Retrieve one of four prompts used in the STT-1100 penguin exercise.
#' French is the default to preserve existing course code.
#'
#' @param section One character string, exactly one of `"histogramme"`,
#'   `"nuage_de_points"`, `"statistiques_descriptives"`, or
#'   `"Visualisation_statistiques_descriptives"` (case-sensitive).
#' @param lang Message language: `"fr"` (default) or `"en"`.
#' @return A character string containing the exercise prompt.
#' @examples
#' consulter_taches("histogramme")
#' consulter_taches("statistiques_descriptives", lang = "en")
#' @export
consulter_taches <- function(section, lang = "fr") {
  check_character_scalar(section, "section")
  lang <- check_language(lang)
  taches <- list(
    "histogramme" = paste(
      "Je veux voir la r\u00e9partition des longueurs de",
      "nageoires des manchots. En effet, quand j'ai regard\u00e9,",
      "il me semblait y avoir une erreur dans les donn\u00e9es.",
      "J'aimerais que tu m'aides \u00e0 la trouver."
    ),
    "nuage_de_points" = paste(
      "Je veux voir la relation entre la longueur du bec et la",
      "masse corporelle sous forme d'un nuage de points. Peux-tu",
      "v\u00e9rifier s'il y a des valeurs aberrantes pour ces",
      "deux variables ?"
    ),
    "statistiques_descriptives" = paste(
      "Quelle esp\u00e8ce de pingouin a le bec le plus long en",
      "moyenne ? Le plus variable?"
    ),
    "Visualisation_statistiques_descriptives" = paste(
      "J'ai commenc\u00e9 \u00e0 faire le ggplot, mais il",
      "resterait a ajouter une annotation indiquant la valeur",
      "moyenne de chaque esp\u00e8ce sur le graphique."
    )
  )
  if (!section %in% names(taches)) {
    stop("Unknown `section`. Choose one of: ",
      paste(names(taches), collapse = ", "), ".",
      call. = FALSE
    )
  }
  if (lang == "en") {
    taches <- list(
      histogramme = paste(
        "Show the distribution of penguin flipper lengths.",
        "There seems to be an error in the data. Can you find it?"
      ),
      nuage_de_points = paste(
        "Plot bill length against body mass in a scatterplot.",
        "Are there unusual values in either variable?"
      ),
      statistiques_descriptives = paste(
        "Which penguin species has the greatest mean bill length?",
        "Which has the most variable bill length?"
      ),
      Visualisation_statistiques_descriptives = paste(
        "Complete the plot by annotating the mean for each species."
      )
    )
  }
  taches[[section]]
}

#' Answer-Key Feedback for the Penguin Exercise
#'
#' Return fixed feedback for the two deliberately altered rows in the course
#' file `manchots_donnees.xlsx` (also named `penguins_mission` in exercises).
#' This function does not inspect data or perform statistical outlier detection.
#'
#' @param ligne One finite positive whole number, giving the row in the original
#'   exercise file, before filtering or reordering.
#' @param lang Message language: `"fr"` (default) or `"en"`.
#' @details The answer key corrects row 6 to a flipper length of 193 mm and
#'   row 11 to a body mass of 3300 g (3.3 kg) and a bill length of 37.8 mm.
#'   Feedback for any other row means only that it is absent from this answer
#'   key. It does not establish that an observation is statistically typical.
#'   The exercise file is distributed with the course, not with this package.
#' @return A character string containing answer-key feedback.
#' @examples
#' verifier_valeur_aberrante(6)
#' verifier_valeur_aberrante(11, lang = "en")
#' @export
verifier_valeur_aberrante <- function(ligne, lang = "fr") {
  if (!is.numeric(ligne) || is.complex(ligne) ||
    length(ligne) != 1L || is.na(ligne) ||
    !is.finite(ligne) || ligne < 1 || ligne != floor(ligne)) {
    stop("`ligne` must be one finite positive whole number.", call. = FALSE)
  }
  lang <- check_language(lang)
  if (lang == "en") {
    if (ligne == 6) {
      return("Exercise correction: flipper length should be 193 mm.")
    }
    if (ligne == 11) {
      return(paste(
        "Exercise correction: body mass should be 3300 g (3.3 kg)",
        "and bill length should be 37.8 mm."
      ))
    }
    return("This row is not one of the two errors in the exercise answer key.")
  }
  if (ligne == 6) {
    return(paste(
      "Oui, cette valeur est bien une aberration ! J'ai pu",
      "v\u00e9rifier mes notes, et \u00e7a devrait \u00eatre",
      "193mm. Merci de modifier la base de donn\u00e9es pour moi",
      "dans le d\u00e9p\u00f4t Github."
    ))
  }
  if (ligne == 11) {
    return(paste(
      "Oui, cette valeur est bien une aberration ! J'ai pu",
      "v\u00e9rifier mes notes, et \u00e7a devrait \u00eatre",
      "corrig\u00e9 par 3.3kg de masse corporelle et 37.8 mm de",
      "longueur de bec. Merci de mettre \u00e0 jour la base de",
      "donn\u00e9es."
    ))
  } else {
    return(paste(
      "Hum, j'ai bien v\u00e9rifi\u00e9, il ne s'agit pas d'une",
      "valeur aberrante, essayez encore !"
    ))
  }
}
