-- ── Analysis 1: Overall funnel conversion rates ──────────────────────────────
SELECT
    SUM(total_sessions)             AS total_sessions,
    SUM(sessions_with_product_view) AS product_views,
    SUM(sessions_with_add_to_cart)  AS add_to_carts,
    SUM(sessions_with_checkout)     AS checkouts,
    SUM(sessions_with_purchase)     AS purchases,
    ROUND(SUM(sessions_with_purchase) / SUM(total_sessions) * 100, 2) AS overall_conversion_pct
FROM `product-funnel-analytics.ga4_staging_marts.fct_funnel`;

-- ── Analysis 2: Conversion by device ────────────────────────────────────────
SELECT
    device_category,
    SUM(total_sessions)             AS sessions,
    SUM(sessions_with_purchase)     AS purchases,
    ROUND(SUM(sessions_with_purchase) / SUM(total_sessions) * 100, 2) AS conversion_pct,
    ROUND(SUM(total_revenue), 2)    AS revenue
FROM `product-funnel-analytics.ga4_staging_marts.fct_funnel`
GROUP BY 1
ORDER BY revenue DESC;

-- ── Analysis 3: Top revenue channels ────────────────────────────────────────
SELECT
    first_touch_source,
    first_touch_medium,
    users,
    conversions,
    total_revenue,
    avg_order_value
FROM `product-funnel-analytics.ga4_staging_marts.fct_revenue_attribution`
WHERE total_revenue > 0
ORDER BY total_revenue DESC
LIMIT 10;
