SELECT store_type, SUM(product_quantity * sale_price) AS "Total Revenue"
FROM forquerying2
WHERE country = 'Germany' 
GROUP BY store_type
ORDER BY "Total Revenue" DESC
LIMIT 1;