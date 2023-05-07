SELECT artist, sum(starts) AS total_starts
FROM audio
WHERE date >= '2023-01-01'
AND artist in ('ANNA ASTI', 'Три дня дождя', 'MACAN')
GROUP BY artist
HAVING total_starts > 1000000
ORDER BY total_starts DESC

---


SELECT date, artist, track, starts, starts / SUM(starts) OVER(PARTITION BY date, artist) AS track_total_ratio
FROM audio
WHERE date >= '2023-01-01'
AND artist in ('ANNA ASTI', 'Три дня дождя', 'MACAN')


---

SELECT age_bucket, AVG(users) AS avg_daily_users, AVG(starts) AS avg_daily_starts
FROM
(
SELECT a.date, COUNT(a.user_id) AS users, SUM(a.starts) AS starts,
CASE
    WHEN u.age BETWEEN 1 AND 14 THEN '1-14'
    WHEN u.age BETWEEN 14 AND 25 THEN '15-25'
    WHEN u.age BETWEEN 26 AND 35 THEN '26-35'
    WHEN u.age BETWEEN 36 AND 55 THEN '36-55'
    WHEN u.age BETWEEN 56 AND 100 THEN '56-100'    
END AS age_bucket
FROM audio a
LEFT JOIN users u on a.user_id = u.user_id
WHERE a.date BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
AND a.starts > 0
GROUP BY a.date, age_bucket
) AS T1
GROUP BY age_bucket
ORDER BY age_bucket