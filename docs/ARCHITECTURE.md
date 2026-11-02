# Architecture
- `lib/main.dart` : démarrage, thème, langue et navigation.
- `assets/branding/` : icône et identité visuelle.
- `test/` : tests widget.
- `.github/workflows/` : automatisation APK.

Extensions prévues :
- `lib/core/` : configuration, stockage et internationalisation.
- `lib/features/catalog/` : cycles, niveaux, matières, chapitres.
- `lib/features/lessons/` : leçons, exemples, vidéos et fiches.
- `lib/features/practice/` : exercices et corrections.
- `lib/features/exams/` : évaluations et examens.
- `lib/features/progress/` : progression locale.

## Pédagogie interactive et professeur Nibras
- `lib/1ap_math_curriculum.dart` : lecteur local et point de contrôle pédagogique synchronisé avec la vidéo.
- `lib/nibras_tutor_service.dart` : client Flutter HTTPS, URL injectée à la compilation, sans secret embarqué.
- Aide guidée locale : indices, reformulation et correction contextualisée sans réseau.
- `backend/main.py` : API FastAPI du professeur conversationnel, compatible API Chat Completions.
- `backend/.env.example`, `backend/Dockerfile`, `backend/README.md` : configuration et déploiement du serveur.
- La clé fournisseur reste dans l'environnement serveur. Avant ouverture publique : HTTPS, authentification, quotas, limitation de débit et politique de confidentialité adaptées aux mineurs.
- L'intégration conversationnelle est un socle technique ; elle ne devient un professeur IA génératif actif qu'après configuration et déploiement du serveur et du fournisseur de modèle.
