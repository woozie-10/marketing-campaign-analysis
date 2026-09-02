WITH costs AS (
    SELECT
        campaign,
        campaign_id,
        ANY_VALUE(media_source) AS media_source,
        SUM(cost_usd) AS spend,
        SUM(impressions) AS impressions,
        SUM(clicks) AS clicks
    FROM `mornhouse-test-environment.test_app_dataset.cost_table`
    GROUP BY
        campaign,
        campaign_id
),

installs AS (
    SELECT
        campaign_id,
        COUNT(DISTINCT ad_event_id) AS installs
    FROM `mornhouse-test-environment.test_app_dataset.non_org_installs_report`
    WHERE conversion_metric = 'conversion'
    GROUP BY
        campaign_id
),

subscription_revenue AS (
    SELECT
        campaign_id,
        SUM(event_revenue_usd) AS subscription_revenue
    FROM `mornhouse-test-environment.test_app_dataset.in_app_events_report`
    WHERE event_name IN (
        'subscription_renewed',
        'trial_converted',
        'no_trial_sub_started',
        'subscription_refunded'
    )
    GROUP BY
        campaign_id
),

ad_revenue AS (
    SELECT
        campaign_id,
        SUM(event_revenue_usd) AS ad_revenue
    FROM `mornhouse-test-environment.test_app_dataset.ad_revenue_raw`
    WHERE event_name = 'ad_revenue'
    GROUP BY
        campaign_id
)

SELECT
    c.campaign,
    c.campaign_id,
    c.media_source,

    c.spend,
    c.impressions,
    c.clicks,

    COALESCE(i.installs, 0) AS installs,

    COALESCE(sr.subscription_revenue, 0) AS subscription_revenue,
    COALESCE(ar.ad_revenue, 0) AS ad_revenue,

    COALESCE(sr.subscription_revenue, 0)
        + COALESCE(ar.ad_revenue, 0) AS total_revenue,

    total_revenue - spend AS profit,

    SAFE_DIVIDE(c.spend, NULLIF(i.installs, 0)) AS CPI,

    SAFE_DIVIDE(c.clicks, NULLIF(c.impressions, 0)) AS CTR,

    SAFE_DIVIDE(
        COALESCE(sr.subscription_revenue, 0)
        + COALESCE(ar.ad_revenue, 0),
        NULLIF(c.spend, 0)
    ) AS ROAS,

    SAFE_DIVIDE(
        COALESCE(sr.subscription_revenue, 0)
        + COALESCE(ar.ad_revenue, 0) - c.spend,
        NULLIF(c.spend, 0)
    ) * 100 AS ROI

FROM costs c

LEFT JOIN installs i
    ON c.campaign_id = i.campaign_id

LEFT JOIN subscription_revenue sr
    ON c.campaign_id = sr.campaign_id

LEFT JOIN ad_revenue ar
    ON c.campaign_id = ar.campaign_id;