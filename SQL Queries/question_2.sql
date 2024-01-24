SELECT month_name AS "Month", year AS "Year",
SUM(country_region.sale_price * country_region.product_quantity) AS "Total Revenue"
FROM dim_date d
INNER JOIN country_region ON d.date = country_region.dates
WHERE year = 2022
GROUP BY d.date, month_name, year
ORDER BY "Total Revenue" DESC
LIMIT 1

