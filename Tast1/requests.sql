--connect to server: psql -h pg -d studs

--получить очки счатья после просмотра экспонатов.
SELECT * FROM (SELECT e.name as exhibit_name, happiness_score * HAPPINESS_RATIO_PER_VIEWING AS viewing_result, ee.name as exhibition_name     
FROM visitors v                                    
INNER JOIN tickets t ON v.visitor_id = t.visitor_id
INNER JOIN exhibitions ee ON t.exhibition_id = ee.exhibition_id
INNER JOIN exhibition_content ec ON ee.exhibition_id = ec.exhibition_id
INNER JOIN exhibits e ON ec.exhibit_id = e.exhibit_id) AS temp WHERE viewing_result > 10;

--получить среднее значение очков счастья за посещения выставки.
SELECT exhibition_name, avg(viewing_result) as happiness_avg FROM (SELECT e.name as exhibit_name, happiness_score * HAPPINESS_RATIO_PER_VIEWING AS viewing_result, ee.name as exhibition_name     
FROM visitors v                                    
INNER JOIN tickets t ON v.visitor_id = t.visitor_id
INNER JOIN exhibitions ee ON t.exhibition_id = ee.exhibition_id
INNER JOIN exhibition_content ec ON ee.exhibition_id = ec.exhibition_id
INNER JOIN exhibits e ON ec.exhibit_id = e.exhibit_id) AS temp group by exhibition_name;
