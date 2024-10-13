{{ config(materialized='view') }}

WITH base AS (
    SELECT
       *
    FROM {{ ref('fact_leads') }}
),

case_metrics AS (
    SELECT
        date_key,
        account_key,
        user_key,
        contact_key,
        status,
        COUNT(*) AS total_leads,
        SUM(CASE WHEN is_converted THEN 1 ELSE 0 END) AS converted_leads,
        SUM(CASE WHEN is_converted THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0) AS conversion_rate
    FROM base
    GROUP BY
        date_key,
        account_key,
        user_key,
        contact_key,
        status
)

SELECT * FROM case_metrics

