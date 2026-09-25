-- Weekly retention cohort analysis.
-- Cohort = the week a user first visited.
-- Retention = did they come back in subsequent weeks?
--
-- Interview point: DATE_TRUNC groups dates into weeks.
-- The join finds returning users by matching their cohort week
-- to subsequent activity weeks.

with sessions as (
    select * from {{ ref('stg_ga4_sessions') }}
),
first_visit as (
    select
        user_pseudo_id,
        date_trunc(min(session_date), week)                 as cohort_week
    from sessions
    group by user_pseudo_id
),
user_weeks as (
    select
        s.user_pseudo_id,
        f.cohort_week,
        date_trunc(s.session_date, week)                    as activity_week,
        date_diff(
            date_trunc(s.session_date, week),
            f.cohort_week,
            week
        )                                                   as weeks_since_first_visit
    from sessions s
    join first_visit f using (user_pseudo_id)
)
select
    cohort_week,
    weeks_since_first_visit,
    count(distinct user_pseudo_id)                          as active_users
from user_weeks
group by 1, 2
order by 1, 2
