# UlavalSSD 0.3.1

- Remove the README link to submission notes excluded from the source archive.
  Use permanent repository links for data-provenance and copyright documents.
- Cite Hester et al. (2025), the peer-reviewed description of 'lintr', in the
  package description and style-diagnostic help.
- Check file URIs in the built source archive and fail validation for any
  unexpected NOTE. Add R-devel on Windows to the check matrix.
- No changes to the functions or datasets from version 0.3.0.

# UlavalSSD 0.3.0

- Replace line-based regular expressions in `eval_tidyverse_style()` with
  optional `lintr` diagnostics. Empty or invalid code has no score; subjective
  criteria are `NA`. The seven observable criteria are rescaled to 20 points.
  Scores are formative indicators and are not comparable to version 0.2.1.
- Inspect only fenced R chunks in Quarto files, preserving source line numbers.
  Do not execute submitted code or local `.lintr` settings.
- Validate exercise inputs and document all four prompt keys. Add English
  feedback through `lang = "en"`, retaining French defaults and existing keys.
- Clarify that row feedback is an exercise answer key, not outlier detection.
- Correct dataset schemas, date ranges and provenance limitations; preserve
  both `.rda` files byte for byte.
- Add an offline introductory vignette, explicit exports and regression tests.
- Update maintainer contact and package metadata for CRAN preparation.

- Independently reconstruct and verify all weather columns against the ECCC
  GeoMet service, with station history, source manifest and current attribution.

- Record the maintainer-confirmed origin of the historical administrative
  snapshot: the official MAPAQ dataset distributed through Donnees Quebec.

# UlavalSSD 0.2.1

- Suppression de la dépendance inutilisée à `stringr`.
- Correction du nom du fichier du module 2 et de l'encodage des chaînes pour
  améliorer la portabilité, sans modifier les messages retournés.
- Exclusion de la configuration GitHub de l'archive R.
- Ajout de tests de chargement des données et d'utilisation des fonctions.
- Instructions d'installation sans mise à jour des autres packages et méthode
  de secours par téléchargement direct de l'archive GitHub.

Les jeux de données sont inchangés.
