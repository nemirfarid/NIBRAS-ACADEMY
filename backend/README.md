# Nibras Tutor API

The Flutter app calls this server; the provider key is stored **only** in the server environment.

## Run locally

```bash
python -m venv .venv
# Windows: .venv\\Scripts\\activate
# Linux/macOS: source .venv/bin/activate
pip install -r requirements.txt
# Set AI_API_KEY, AI_MODEL and optionally AI_BASE_URL in the server environment.
uvicorn main:app --host 0.0.0.0 --port 8000
```

Health check: `GET /health`; tutor: `POST /api/tutor`.

Configure the mobile build with:
```bash
flutter build apk --release --dart-define=NIBRAS_TUTOR_URL=https://YOUR-HOST/api/tutor
```

Do not commit real API keys. Use HTTPS, restrict ALLOWED_ORIGINS to trusted origins,
add authentication/rate limiting before public production deployment, and configure
provider billing/quotas. The app keeps its guided offline help when this service is
unconfigured or unreachable. No learner account or personal data is required by this
minimal endpoint.
