# OA Care AI — Osteoarthritis Management Starter App

A full-stack reference project for an **osteoarthritis self-management and clinician-support application**. It includes:

- Vanilla JavaScript responsive frontend
- PHP 8.2 REST API
- MySQL/MariaDB schema and seed data
- Node.js data-ingestion and web-scraping service
- Rule-based AI risk and recommendation engine
- Optional adapter for an external large-language-model provider
- Docker Compose local environment
- Basic tests, validation, audit logging, and safety guardrails

> **Important:** This repository is an educational starter kit. It is **not a medical device**, does not diagnose osteoarthritis, and must not replace a qualified healthcare professional. Any production use involving health data requires clinical validation, security review, consent management, privacy compliance, and regulatory assessment.

## 1. Main use cases

The sample application lets a user:

1. Create a patient profile.
2. Record pain, stiffness, mobility, sleep, activity, medication adherence, and red-flag symptoms.
3. Receive a non-diagnostic risk tier and safe self-management suggestions.
4. View symptom trends.
5. Read curated osteoarthritis education content.
6. Escalate urgent symptoms to a clinician.

The ingestion service can:

- Read trusted-source feeds and APIs.
- Respect `robots.txt` for HTML sources.
- Normalize article metadata.
- Send approved records to the PHP ingestion API.

## 2. Architecture

```text
Browser
  |
  | HTTP/JSON
  v
PHP REST API -------------------- MySQL
  |                                 |
  |                                 +-- patients
  |                                 +-- assessments
  |                                 +-- recommendations
  |                                 +-- education_articles
  |                                 +-- audit_logs
  |
  +-- Risk engine
  +-- Recommendation service
  +-- Optional external AI adapter

Node ingestion service
  |
  +-- PubMed-compatible API client
  +-- HTML scraper with robots.txt check
  +-- Normalizer and deduplicator
  +-- POST /api/v1/education/ingest
```

## 3. Repository layout

```text
oa-care-ai/
├── backend/
│   ├── public/index.php
│   ├── src/
│   │   ├── Controllers/
│   │   ├── Models/
│   │   ├── Services/Ai/
│   │   ├── Services/
│   │   ├── Support/
│   │   ├── Config.php
│   │   ├── Database.php
│   │   └── Router.php
│   ├── bootstrap.php
│   ├── routes.php
│   ├── composer.json
│   └── tests/RiskEngineTest.php
├── database/
│   ├── schema.sql
│   └── seed.sql
├── data/
│   ├── models/risk_model.json
│   └── seed/osteoarthritis_articles.json
├── frontend/
│   ├── index.html
│   ├── css/styles.css
│   └── js/
│       ├── api.js
│       ├── app.js
│       └── components/
├── scraper/
│   ├── src/
│   ├── package.json
│   └── .env.example
├── .env.example
└── docker-compose.yml
```

## 4. Quick start with Docker

### Requirements

- Docker and Docker Compose

### Start

```bash
cp .env.example .env
docker compose up --build
```

Open:

- Frontend: `http://localhost:8080`
- API health check: `http://localhost:8081/api/v1/health`
- Database: `localhost:3307`

Run the ingestion worker:

```bash
docker compose --profile ingestion run --rm scraper npm run ingest
```

## 5. Manual setup

### Database

```bash
mysql -u root -p < database/schema.sql
mysql -u root -p oa_care < database/seed.sql
```

### PHP backend

```bash
cd backend
cp ../.env.example .env
php -S localhost:8081 -t public
```

### Frontend

```bash
cd frontend
python -m http.server 8080
```

### Scraper

```bash
cd scraper
cp .env.example .env
npm install
npm run ingest
```

## 6. API examples

### Health

```bash
curl http://localhost:8081/api/v1/health
```

### Create patient

```bash
curl -X POST http://localhost:8081/api/v1/patients \
  -H 'Content-Type: application/json' \
  -d '{
    "external_id": "demo-001",
    "first_name": "Sam",
    "birth_year": 1968,
    "sex": "female",
    "affected_joint": "knee"
  }'
```

### Submit assessment

```bash
curl -X POST http://localhost:8081/api/v1/assessments \
  -H 'Content-Type: application/json' \
  -d '{
    "patient_id": 1,
    "pain_score": 6,
    "stiffness_minutes": 35,
    "mobility_score": 5,
    "sleep_quality": 4,
    "activity_minutes": 20,
    "medication_adherence": 8,
    "swollen_hot_joint": false,
    "fever": false,
    "unable_to_bear_weight": false,
    "recent_trauma": false,
    "notes": "Pain after long walks"
  }'
```

The response contains:

- `risk_tier`: `low`, `moderate`, `high`, or `urgent`
- `score`: transparent rule-based score
- `factors`: factors used in the score
- `recommendations`: safe, non-diagnostic suggestions
- `disclaimer`: medical safety notice

## 7. AI design

The default “AI” is deliberately transparent and rule based. It combines:

- Pain severity
- Stiffness duration
- Mobility limitation
- Sleep disruption
- Physical activity
- Medication adherence
- Red-flag symptoms

The model configuration lives in `data/models/risk_model.json`.

The engine never claims to diagnose disease. Red flags override the score and return an urgent escalation message.

`ExternalAiClient.php` is an optional adapter for summarizing already-approved recommendations. Keep it disabled by default. Never send personal health information to a third-party AI service without a valid legal basis, consent, a data-processing agreement, and a formal security review.

## 8. Web scraping and data ingestion

The Node worker contains two source types:

1. `pubmed.js`: API-based search for article metadata.
2. `genericHtml.js`: HTML extraction with a `robots.txt` permission check.

Before scraping any website:

- Review its terms of service.
- Respect `robots.txt`.
- Use a descriptive user agent.
- Rate-limit requests.
- Store only permitted metadata.
- Prefer official APIs or RSS feeds.

Only curated, reviewed records should become visible to patients. The included ingestion endpoint supports a shared API key but production systems should use stronger service authentication, network restrictions, signed requests, and human editorial review.

## 9. Security checklist for production

- Use HTTPS everywhere.
- Replace development API keys and passwords.
- Encrypt health data at rest.
- Add real authentication and role-based access control.
- Use CSRF protection for cookie-based sessions.
- Apply strict CORS rules.
- Validate and sanitize every input.
- Keep audit logs immutable and access-controlled.
- Add rate limiting and anomaly detection.
- Perform dependency scanning and penetration testing.
- Define retention and deletion policies.
- Separate identifiable data from analytics data.
- Obtain clinical, legal, and privacy review.

## 10. Clinical safety guardrails

The repository includes these basic controls:

- Emergency red flags override normal recommendations.
- Recommendations are general and conservative.
- The output always includes a disclaimer.
- No medication dose changes are suggested.
- No diagnosis is generated.
- A clinician review path is recommended for persistent or worsening symptoms.

A real clinical product also needs:

- A clinical safety officer.
- Hazard analysis and risk controls.
- Human factors testing.
- Model validation on representative populations.
- Bias and performance monitoring.
- A documented incident-response process.

## 11. Tests

PHP risk-engine test:

```bash
php backend/tests/RiskEngineTest.php
```

Node tests:

```bash
cd scraper
npm test
```

## 12. Suggested next steps

- Add OAuth/OIDC authentication.
- Add clinician dashboard and secure messaging.
- Add FHIR integration through a reviewed interoperability layer.
- Add consent, export, correction, and deletion workflows.
- Add multilingual education content.
- Add validated patient-reported outcome measures.
- Add model monitoring and clinician feedback loops.

## License

MIT for the sample code. Medical content and production deployment remain your responsibility.
