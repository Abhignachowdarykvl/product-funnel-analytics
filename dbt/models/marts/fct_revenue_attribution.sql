-- First-touch revenue attribution by traffic source.
-- Business question: which channel drives the most revenue?
--
-- Interview point: first-touch = credit the channel that brought
-- the user for the first time, not the last session before purchase.

with sessions as (
    select * from {{ ref('stg_ga4_sessions') }}
),
first_touch as (
    select
        user_pseudo_id,
        any_value(traffic_source) as first_touch_source,
        any_value(traffic_medium) as first_touch_medium,
        any_value(campaign)       as first_touch_campaign
    from (
        select *,
            row_number() over (
                partition by user_pseudo_id
                order by session_start
            ) as rn
        from sessions
    )
    where rn = 1
    group by user_pseudo_id
)
select
    f.first_touch_source,
    f.first_touch_medium,
    count(distinct s.user_pseudo_id)                        as users,
    count(distinct case when s.converted then s.session_id end) as conversions,
    round(sum(s.session_revenue), 2)                        as total_revenue,
    round(avg(case when s.converted then s.session_revenue end), 2) as avg_order_value
from sessions s
join first_touch f using (user_pseudo_id)
group by 1, 2
order by total_revenue desc
