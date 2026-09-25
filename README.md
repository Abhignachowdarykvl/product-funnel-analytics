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

- Overall purchase conversion rate: TBD after running models
- Mobile vs desktop conversion difference: TBD
- Top revenue channel: TBD

## Skills Demonstrated

`BigQuery` `nested/semi-structured data` `UNNEST` `sessionization` `window functions`
`cohort analysis` `funnel analysis` `first-touch attribution` `dbt` `CI/CD` `Tableau`
