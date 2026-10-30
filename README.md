#- [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Analyze Olist order delivery performance and explore how delivery timing relates to customer review scores using PostgreSQL and Power BI.

## Tools and dataset

- PostgreSQL for storing and analyzing the data with SQL
- Power BI Desktop for the dashboard
- Brazilian E-Commerce Public Dataset by Olist

## Key findings

- The dataset contains 99,441 orders; 97.02% have a delivered status.
- The overall average review score is 4.09 out of 5.
- For delivered orders with both delivery dates and a review, on-time or early deliveries averaged 4.29, while late deliveries averaged 2.57.
- This comparison shows an association between delivery timing and review scores; it does not prove that late delivery caused lower ratings.

## Analysis workflow

1. Loaded the Olist customer, order, and review CSV files into PostgreSQL.
2. Used SQL to check the data, measure delivery performance, and compare review scores by delivery group.
3. Connected Power BI to PostgreSQL and built a dashboard showing order counts and average review scores.

## Limitations

- Delivery groups are assigned only when both the actual and estimated delivery dates are available.
- The review-score comparison includes delivered orders that also have a review.
- These results describe an association; they do not prove that delivery timing alone caused the difference in scores.

## Dashboard

[View the dashboard (PDF)](OLIST%20DELIVERY%20PERFORMANCE.pdf)

