# UlavalSSD

[![R-CMD-check](https://github.com/AurelienNicosiaULaval/UlavalSSD/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AurelienNicosiaULaval/UlavalSSD/actions/workflows/R-CMD-check.yaml)

Données québécoises et outils pour l'initiation à la science des données.
Le package accompagne le [cours STT-1100 de l'Université Laval](https://aureliennicosiaulaval.github.io/STT-1100_notes_de_cours/).
Les données sont des instantanés historiques : aucune connexion n'est nécessaire
pour les utiliser.

Quebec teaching snapshots and tools for introductory data science. Function
help and the introductory vignette are in English; exercise messages default
to French and support `lang = "en"`.

## Installation pour le cours

Le package n'est pas encore distribué sur le CRAN. Pour installer la version
stable publiée sur GitHub, sans dépendre d'un jeton GitHub enregistré :

```r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}
remotes::install_url(
  "https://github.com/AurelienNicosiaULaval/UlavalSSD/archive/refs/heads/main.tar.gz",
  upgrade = "never"
)
library(UlavalSSD)
packageVersion("UlavalSSD")
```

Si `install_github()` affiche `HTTP error 401. Bad credentials`, utilisez
l'archive publique ci-dessus. Cette méthode ne modifie pas les identifiants
GitHub enregistrés. Si elle échoue, conservez le message complet et le résultat
de `sessionInfo()` pour le diagnostic.

## Fonctions et dépendances

Les données et les fonctions d'exercice fonctionnent avec R seul. Dans la
version 0.3.1, le diagnostic de style utilise le package facultatif `lintr` :

```r
install.packages("lintr", repos = "https://cloud.r-project.org")
```

Les dépendances de documentation et de test sont facultatives pour l'utilisation
courante. R 4.1.0 ou plus récent est requis par cette version.

## Données et exemples

```r
library(UlavalSSD)
weather <- as.data.frame(MeteoQuebec)
weather$date <- as.Date(with(weather, paste(year, month, day, sep = "-")))
head(weather[c("date", "min_temp", "max_temp")])
colSums(is.na(weather))

records <- as.data.frame(listecondamnation)
range(as.Date(records$Date_publication))
```

- `MeteoQuebec` : 20 111 observations quotidiennes du 1er janvier 1970 au
  22 janvier 2025, avec les mesures manquantes conservées. Le changement de
  station est identifié; l'homogénéité de la série doit être évaluée avant
  toute analyse des tendances climatiques.
- `listecondamnation` : 1 712 enregistrements historiques publiés du
  13 février 2023 au 10 février 2025. Ils ne décrivent pas la situation actuelle
  des établissements et ne constituent pas un échantillon représentatif.

Les deux fichiers de données sont conservés à l'identique depuis la version
0.2.1. Leurs colonnes, types et limites sont décrits dans l'aide de R.

```r
consulter_taches("histogramme")
consulter_taches("histogramme", lang = "en")
verifier_valeur_aberrante(6)
```

`verifier_valeur_aberrante()` consulte le corrigé des deux erreurs introduites
dans l'aventure 2. Le numéro de ligne doit correspondre au fichier d'origine.
Ce n'est pas un outil de détection statistique des valeurs aberrantes.

Le diagnostic `eval_tidyverse_style()` renvoie les problèmes de style avec leurs
numéros de ligne. Son score est un indicateur formatif, pas une note validée.
Un fichier vide ou invalide n'obtient aucun score; la pertinence des commentaires
et du raisonnement exige une lecture humaine.
L'analyse statique repose sur `lintr`, décrit par
[Hester et al. (2025), Static Code Analysis for R](https://doi.org/10.21105/joss.07240).

## Documentation, sources et contribution

Consultez l'aide avec `help(package = "UlavalSSD")` et la vignette
`vignette("getting-started", package = "UlavalSSD")` si les vignettes ont été
construites à l'installation (`build_vignettes = TRUE`).

Le code est sous licence MIT. Les données de tiers gardent leurs conditions
d'origine. L'attribution et les limites de provenance sont consignées dans
le [fichier d'attribution](https://github.com/AurelienNicosiaULaval/UlavalSSD/blob/f1fa8711921fedca506d5df4ff5811713e19c760/inst/COPYRIGHTS)
et la [documentation de provenance](https://github.com/AurelienNicosiaULaval/UlavalSSD/blob/f1fa8711921fedca506d5df4ff5811713e19c760/data-raw/README.md).
Dans le package installé, le fichier d'attribution est accessible avec
`system.file("COPYRIGHTS", package = "UlavalSSD")`.

Signalez un problème reproductible dans les
[issues du dépôt](https://github.com/AurelienNicosiaULaval/UlavalSSD/issues),
avec la version du package, le code minimal et le message d'erreur complet.
