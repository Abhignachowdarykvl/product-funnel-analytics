# Product & Funnel Analytics

End-to-end analytics engineering pipeline: GA4 event data → BigQuery → dbt → Tableau.

## Business Problem

An e-commerce product team needs to understand:
- Where do customers drop off in the purchase funnel?
- Which device and traffic channel converts best?
- Which marketing channels drive the most revenue?
- How many customers come back after their first visit?

## Architecture

```
GA4 Public Dataset (BigQuery) ──► dbt staging (unnest + sessionize)
                                ──► dbt marts (funnel, retention, attribution)
                                ──► Tableau dashboard
                         GitHub Actions runs dbt tests on every push
```

## Data Source

Google Analytics 4 obfuscated sample dataset from the Google Merchandise Store.
Available as a public dataset in BigQuery: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

## Tech Stack

| Layer | Technology |
|---|---|
| Cloud warehouse | Google BigQuery |
| Transformation | dbt Core + dbt_utils |
| Testing | dbt tests, GitHub Actions CI |
| Visualization | Tableau Public |

## Data Model

```
stg_ga4_events      (flat unnested events)
stg_ga4_sessions    (one row per session)
    ├── fct_funnel             (daily conversion funnel by device + channel)
    ├── fct_retention          (weekly cohort retention)
    └── fct_revenue_attribution (first-touch revenue by channel)
```

## Key Findings

> Dashboard: [link coming after Tableau publish]

- 241,752 total sessions analyzed across November–December 2020
- Overall purchase conversion rate: 1.54% (3,733 purchases from 241,752 sessions)
- Funnel drop-off: 53,917 viewed a product → 10,651 added to cart → 3,733 purchased
- Google Organic is the top revenue channel ($83,033), followed by Direct ($58,112)
- Desktop converts best; tablet has the lowest conversion at 1.4%
- Total revenue analyzed: $263,905

## Skills Demonstrated

`BigQuery` `nested/semi-structured data` `UNNEST` `sessionization` `window functions`
`cohort analysis` `funnel analysis` `first-touch attribution` `dbt` `CI/CD` `Tableau`
