# Marketing Campaign Performance Analysis

Marketing campaign performance and profitability analysis built with **SQL, Google BigQuery, and Tableau**.

## Dashboard

**Tableau Public:**
[View the interactive dashboard](https://public.tableau.com/views/MarketingCampaignPerformanceDashboard_17883366654750/CampaignPerformance?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## What was analyzed

* Advertising spend, impressions, and clicks
* User installs
* Subscription and ad revenue
* Profitability of marketing campaigns
* CPI, CTR, ROAS, and ROI

## Data

The data mart was built in **Google BigQuery** by aggregating and joining:

* `cost_table`
* `non_org_installs_report`
* `in_app_events_report`
* `ad_revenue_raw`

The tables were joined using `campaign_id`.

## Repository

```text
marketing-campaign-analysis/
├── marketing_mart.sql
└── README.md
```

## Tools

**SQL · BigQuery · Tableau**
