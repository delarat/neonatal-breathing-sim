# Newborn Breathing Observation Survey

An eight-scenario, browser-based neonatal breathing observation simulation for controlled technical preview and future faculty-approved research use.

## Current status

This repository hosts a **technical preview only**. The public configuration intentionally has no Supabase URL or key and contains draft consent placeholders. The participant flow therefore stores test activity only in the participant's browser and does not submit research responses to a database. Do not use this site for nurse recruitment or official data collection until the faculty-approved consent information, institution-approved database, secure server endpoint, and clinical review are complete.

## Features

- Eight randomized newborn scenarios with stable scenario IDs and distinct breathing patterns.
- Animated baby visualization, rolling respiratory-rate graph, usual-rate reference line, and seesaw indicator.
- Thirty-second live observation period, changeable green/yellow/red ratings, timestamped selections, confidence and realism questions.
- Final questionnaire, local draft recovery, and a private administrator-dashboard shell.
- Supabase schema and Edge Function source are retained in this repository for owner-managed future setup; no service-role key or database secret is published.

## Open the preview

The GitHub Pages preview will be available at:

`https://just254q.github.io/neonatal-breathing-sim/`

Append `?test=1` to force technical test mode. In the current unconfigured build, preview mode is selected automatically and responses remain in browser local storage.

## Run locally

Requires Python 3 and Node.js 20+.

```bash
npm test
npm run serve
```

Then open `http://localhost:8080/?test=1`.

## Source layout

- `index.html`: participant study information, consent and survey flow.
- `js/scenarios.js`: eight scenario definitions and randomization.
- `js/simulator.js`: breathing engine and canvas visualization.
- `js/app.js`: participant workflow, event timestamps, draft persistence and submission logic.
- `admin.html`, `js/admin.js`, `css/admin.css`: authenticated dashboard shell and exports.
- `config.js`: public frontend configuration only. Never place service-role or secret keys here.
- `supabase/migrations/001_schema.sql`: database schema and access controls.
- `supabase/functions/submit-survey/index.ts`: server-side submission validation; deploy only to an owner-controlled Supabase project.
- `tests/`: automated local tests.
- `.github/workflows/pages.yml`: GitHub Pages deployment workflow.

## GitHub Pages

Repository Settings → Pages → Build and deployment → select **GitHub Actions**. The workflow on pushes to `main` deploys the static frontend. It intentionally excludes Supabase database migrations and Edge Function source from the hosted site artifact.

## Research-use requirements

Before official recruitment, obtain faculty/ethics approval, fill every consent placeholder in `config.js`, secure approval for data residency and retention, review the experimental respiratory stimuli with neonatal clinicians, provision an owner-controlled Supabase project, apply the migration, deploy and test the Edge Function, and verify RLS/admin access. Never publish any Supabase service-role or secret key. See `DEPLOYMENT-CHECKLIST.md` and `PROJECT-HANDOFF.md` for the full checklist.

## Acknowledgement / provenance

This is a separately hosted implementation package prepared for the neonatal breathing-observation project. The teammate-owned repository `iyanuoj-cloud/Clinician-rating-sim_v1` has not been modified. Confirm the original author's permission and any required attribution before wider redistribution or research use.
