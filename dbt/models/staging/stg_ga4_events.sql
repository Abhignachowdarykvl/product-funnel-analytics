-- Unnest the nested GA4 event structure into flat rows.
-- GA4 stores event parameters as an array of key-value structs.
-- This model extracts the most useful parameters into columns.
--
-- Interview point: UNNEST turns one row with an array into many rows,
-- one per array element. The subquery with MAX(IF(...)) is a pivot
-- that turns rows back into columns — a common BigQuery pattern.

with raw as (
    select
        event_date,
        event_timestamp,
        event_name,
        user_pseudo_id,
        device.category                                     as device_category,
        device.operating_system                             as os,
        geo.country                                         as country,
        traffic_source.source                               as traffic_source,
        traffic_source.medium                               as traffic_medium,
        traffic_source.name                                 as campaign,
        ecommerce.purchase_revenue                          as purchase_revenue,
        ecommerce.transaction_id                            as transaction_id,
        -- Extract key event params from the nested array
        (select value.int_value
         from unnest(event_params)
         where key = 'ga_session_id')                       as session_id,
        (select value.string_value
         from unnest(event_params)
         where key = 'page_title')                          as page_title,
        (select value.string_value
         from unnest(event_params)
         where key = 'page_location')                       as page_location,
        (select value.int_value
         from unnest(event_params)
         where key = 'engagement_time_msec')                as engagement_time_msec
    from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    where _table_suffix between '20201101' and '20201231'
),
typed as (
    select
        parse_date('%Y%m%d', event_date)                    as event_date,
        timestamp_micros(event_timestamp)                   as event_timestamp,
        event_name,
        user_pseudo_id,
        session_id,
        device_category,
        os,
        country,
        traffic_source,
        traffic_medium,
        campaign,
        page_title,
        page_location,
        coalesce(purchase_revenue, 0)                       as purchase_revenue,
        transaction_id,
        coalesce(engagement_time_msec, 0)                   as engagement_time_msec
    from raw
)
select * from typed
