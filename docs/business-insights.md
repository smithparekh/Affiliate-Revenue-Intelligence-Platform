# Business Insights

## Executive Summary

The Affiliate Revenue Intelligence Platform converts affiliate click and conversion
events into a tested analytics layer for performance-marketing analysis.

The current synthetic-scale dataset contains:

- 10,000 affiliate clicks
- 2,000 conversion events
- 1,800 unique clicks that generated at least one conversion
- 5,000 synthetic customers
- 100 merchants
- 50 campaigns
- 20 affiliates

The validated financial totals are:

| KPI | Value |
|---|---:|
| Total Clicks | 10,000 |
| Converted Clicks | 1,800 |
| Conversion Events | 2,000 |
| Click-to-Converted-Click Rate | 18.00% |
| Total Order Value | 638,672.38 |
| Total Commission Earned | 13,877.13 |

These figures are based on the synthetic portfolio dataset and are intended to
demonstrate analytics engineering and business-analysis workflows rather than
represent real production-company performance.

---

## 1. Funnel Analysis

### Core metrics

The platform records 10,000 unique clicks and 1,800 unique clicks that generated
at least one conversion.

This produces:

**Click-to-converted-click rate = 18.00%**

There are 2,000 conversion events, which is greater than the 1,800 converted
clicks.

This is expected because the data model treats:

- `click_id` as the click-event identifier
- `conversion_id` as the conversion-event identifier

Therefore, one click can be associated with multiple conversion events.

### Business interpretation

The funnel should be interpreted in two layers:

1. **Unique-click conversion efficiency**
   - Measures how many distinct clicks generated at least one conversion.
2. **Conversion-event volume**
   - Measures the total number of conversion events produced.

Keeping these definitions separate avoids overstating or understating funnel
performance.

---

## 2. Revenue and Commission

Validated totals:

- Order value: **638,672.38**
- Commission earned: **13,877.13**

The implied commission-to-order-value ratio is:

**2.17%**

Calculation:

```text
13,877.13 / 638,672.38 × 100 = 2.17%
```

This ratio provides a useful portfolio-level view of the amount of commission
generated relative to tracked order value.

It should be treated as a descriptive metric for this synthetic dataset, not as
an industry benchmark.

---

## 3. Affiliate Performance

The affiliate mart is modeled at:

```text
affiliate_id + activity_date
```

The dashboard can therefore be used to analyze:

- traffic volume
- converted clicks
- conversion events
- order value
- commission earned
- conversion rate

### Analytical approach

Affiliate performance should be evaluated using both scale and efficiency.

A high-volume affiliate may generate substantial order value while having a
different conversion profile from a lower-volume affiliate.

Useful metrics include:

```text
Clicks
Converted Clicks
Conversions
Conversion Rate
Order Value
Commission Earned
```

### Business interpretation

Affiliate rankings should not be interpreted from traffic alone.

A useful review compares:

```text
Traffic → Conversion → Revenue → Commission
```

This helps distinguish traffic-generating affiliates from affiliates that also
translate traffic into commercial outcomes.

---

## 4. Merchant Performance

The merchant mart is modeled at:

```text
merchant_id + activity_date
```

Available analysis dimensions include:

- merchant
- merchant category
- clicks
- conversions
- order value
- commission earned

### Business questions

Merchant analysis can identify:

- merchants generating substantial order value
- merchants producing meaningful commission
- differences between merchant categories
- merchants with high traffic but comparatively weak conversion

The merchant mart was reconciled against the conversion fact table after fixing
conversion attribution logic.

Validated merchant totals are:

```text
Conversions:  2,000
Order Value:  638,672.38
Commission:   13,877.13
```

---

## 5. Campaign and Channel Performance

The campaign mart is modeled at:

```text
campaign_id + activity_date
```

Each campaign also carries:

- campaign type
- channel

This enables analysis across both individual campaigns and broader channels.

### Recommended analytical questions

- Which channels generate the most order value?
- Which channels generate the most commission?
- Which campaign types generate the highest conversion volume?
- Which campaigns have high traffic but relatively low conversion?
- Does a channel's revenue contribution come from a small number of campaigns?

The campaign mart was also reconciled against the conversion fact table after
correcting click-to-conversion date attribution.

Validated campaign totals are:

```text
Conversions:  2,000
Order Value:  638,672.38
Commission:   13,877.13
```

---

## 6. Product Performance

The product mart is modeled at:

```text
product_id + product_title + activity_date
```

The additional `product_title` component is intentional because some source
product identifiers are associated with more than one product title.

The product analysis supports:

- product traffic
- conversion events
- order value
- commission
- product category
- brand
- conversion efficiency

### High-traffic / low-conversion analysis

A useful diagnostic is to identify products with:

```text
Meaningful click volume
+
Relatively low conversion rate
```

These products may warrant further investigation into:

- offer quality
- landing-page experience
- pricing
- promotion strength
- audience targeting
- product availability

These are hypotheses for further investigation, not causal conclusions from this
synthetic dataset.

### Product revenue vs conversion efficiency

The dashboard also compares order value against conversion rate.

This creates four practical analytical segments:

```text
High Revenue + High Conversion
→ strong commercial performance

High Revenue + Lower Conversion
→ investigate scale vs efficiency

Lower Revenue + High Conversion
→ investigate traffic or distribution opportunity

Lower Revenue + Lower Conversion
→ lower immediate commercial contribution
```

The dashboard is intended to support these comparisons without claiming that
conversion rate alone explains revenue.

The product mart was reconciled against the conversion fact table:

```text
Clicks:       10,000
Conversions:   2,000
Order Value:   638,672.38
Commission:     13,877.13
```

---

## 7. Time-Series Observations

The dashboard includes daily order-value and commission trends.

The charts show that performance is not constant from day to day and contains
visible spikes.

This means:

- daily averages can hide short-lived peaks
- individual campaign or merchant events can materially affect daily totals
- trend analysis should be paired with segmentation by affiliate, merchant,
  campaign, and product

For a production environment, these patterns would also justify anomaly
monitoring around:

```text
Clicks
Conversion Rate
Order Value
Commission
```

---

## 8. Data-Quality Finding During Analysis

An important engineering finding occurred while validating the analytics marts.

The initial affiliate, merchant, campaign, and product marts were undercounting
conversion activity because conversion dates were being aligned directly with
click activity dates.

This was incorrect because the conversion event can happen after the original
click.

The correct relationship is:

```text
Click
  │
  └── click_id
        ↓
   Conversion
```

and the performance marts attribute the conversion back to the original click
date.

After correction, all four performance marts reconciled to the same conversion
fact totals:

```text
Conversions:      2,000
Order Value:      638,672.38
Commission:        13,877.13
```

This validation exercise demonstrates why event-grain and attribution logic
must be tested before business metrics are exposed to dashboards.

---

## 9. Key Analytical Takeaways

### Funnel

18.00% of unique clicks generated at least one conversion.

### Conversion events

2,000 conversion events were generated from 1,800 unique converted clicks,
demonstrating that conversion-event volume and converted-click volume represent
different business concepts.

### Commercial value

The synthetic platform generated:

```text
638,672.38 order value
13,877.13 commission
```

within the modeled dataset.

### Attribution

Conversion activity must be linked to the original click through `click_id`
rather than assuming that click and conversion occur on the same calendar date.

### Segmentation

Affiliate, merchant, campaign, channel, brand, and product dimensions allow
business users to move from overall KPIs to specific performance drivers.

---

## 10. Recommended Business Follow-Up

The dashboard can be used as the starting point for a deeper analysis cycle:

```text
1. Identify performance concentration
        ↓
2. Investigate high-traffic / low-conversion segments
        ↓
3. Compare revenue and commission contribution
        ↓
4. Segment by affiliate, merchant, campaign, channel, and product
        ↓
5. Investigate anomalies and changes over time
        ↓
6. Validate findings against event-level data
```

Potential next analyses include:

- earnings per click (EPC)
- average order value (AOV)
- commission margin
- conversion-time analysis
- cohort analysis
- customer segmentation
- traffic-source efficiency
- anomaly detection

---

## 11. Important Limitations

This project uses portfolio-generated synthetic scale data alongside
source-style datasets.

Therefore:

- the numerical results are illustrative
- observed patterns should not be treated as real market benchmarks
- correlations should not be interpreted as causation
- business recommendations would require additional contextual data in a real
  production environment
- attribution rules may differ across real affiliate platforms

---

## Dashboard

The business analysis is exposed through the Metabase dashboard:

**Affiliate Revenue Intelligence — Executive Overview**

The dashboard covers:

- Executive KPIs
- order-value trends
- commission trends
- affiliate performance
- merchant performance
- campaign performance
- channel performance
- product performance
- conversion diagnostics

---

## Conclusion

This project demonstrates the complete path from event-level data to business
decision support:

```text
Source Data
    ↓
Snowflake
    ↓
dbt Transformation
    ↓
Data Quality & Validation
    ↓
Analytics Marts
    ↓
Metabase Dashboard
    ↓
Business Insights
```

The key outcome is not only the dashboard itself, but the ability to trace each
business KPI back to a defined event grain, validated transformation, and
documented analytical definition.
