-- Build one row per session from the flat events.
-- A session = one continuous visit by a user identified by
-- user_pseudo_id + session_id.
--
-- Interview point: we aggregate events UP to the session level here.
-- The session is the unit of analysis for funnels and conversion.

with events as (
    select * from {{ ref('stg_ga4_events') }}
),
sessions as (
    select
        user_pseudo_id,
        session_id,
        min(event_date)                                     as session_date,
        min(event_timestamp)                                as session_start,
        max(event_timestamp)                                as session_end,
        countif(event_name = 'page_view')                   as page_views,
        countif(event_name = 'view_item')                   as product_views,
        countif(event_name = 'add_to_cart')                 as add_to_carts,
        countif(event_name = 'begin_checkout')              as checkouts,
        countif(event_name = 'purchase')                    as purchases,
        max(purchase_revenue)                               as session_revenue,
        any_value(device_category)                          as device_category,
        any_value(traffic_source)                           as traffic_source,
        any_value(traffic_medium)                           as traffic_medium,
        any_value(campaign)                                  as campaign,
        any_value(country)                                   as country,
        sum(engagement_time_msec) / 1000                    as engagement_seconds
    from events
    where session_id is not null
    group by user_pseudo_id, session_id
)
select
    *,
    case when purchases > 0 then true else false end        as converted,
    timestamp_diff(session_end, session_start, second)      as session_duration_seconds
from sessions
