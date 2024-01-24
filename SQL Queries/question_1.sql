SELECT SUM(staff_numbers) AS "Total Staff UK"
FROM dim_store
WHERE country = 'UK'