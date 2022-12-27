USE DATABASE UDACITY_DA_ND_PROJECT2;


SELECT f.date, b.name, cli.temp_min, cli.temp_max, cli.precipitation, cli.precipitation_normal, AVG(f.stars) AS avg_stars
FROM DWH.fact_review AS f
LEFT JOIN DWH.dim_business AS b ON f.business_id=b.business_id
LEFT JOIN DWH.dim_climate AS cli ON date(f.date)=date(cli.date)
GROUP BY 1,2,3,4,5,6
ORDER BY f.date DESC;