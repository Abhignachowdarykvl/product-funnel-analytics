-- Conversion funnel: how many sessions reach each stage?
-- Business question: where do customers drop off?
--
-- Interview point: each stage is a COUNT of sessions that reached it.
-- Drop-off = (previous stage - current stage) / previous stage.

with sessions as (
    select * from {{ ref('stg_ga4_sessions') }}
)
select
    session_date,
    device_category,
    traffic_source,
    count(*)                                                as total_sessions,
    countif(page_views > 0)                                 as sessions_with_pageview,
    countif(product_views > 0)                              as sessions_with_product_view,
    countif(add_to_carts > 0)                               as sessions_with_add_to_cart,
    countif(checkouts > 0)                                  as sessions_with_checkout,
    countif(purchases > 0)                                  as sessions_with_purchase,
    -- Conversion rates
    round(countif(product_views > 0) / count(*) * 100, 2)  as pct_view_item,
    round(countif(add_to_carts > 0) / count(*) * 100, 2)   as pct_add_to_cart,
    round(countif(checkouts > 0) / count(*) * 100, 2)      as pct_checkout,
    round(countif(purchases > 0) / count(*) * 100, 2)      as pct_purchase,
    sum(session_revenue)                                    as total_revenue
from sessions
group by 1, 2, 3
