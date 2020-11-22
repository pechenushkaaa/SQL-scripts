--connect to server: psql -h pg -d ucheb

--1
SELECT О.КОД, В.ДАТА 
FROM Н_ОЦЕНКИ О 
LEFT JOIN Н_ВЕДОМОСТИ В ON В.ОЦЕНКА = О.КОД 
WHERE О.КОД = '2' AND В.ЧЛВК_ИД = 142390;

--2
SELECT Л.ОТЧЕСТВО, В.ЧЛВК_ИД, С.УЧГОД 
FROM Н_ЛЮДИ Л 
RIGHT JOIN Н_ВЕДОМОСТИ В ON Л.ИД = В.ЧЛВК_ИД 
RIGHT JOIN Н_СЕССИЯ С ON Л.ИД = С.ЧЛВК_ИД 
WHERE Л.ИМЯ = 'Владимир' AND В.ЧЛВК_ИД > 163249 AND date(С.ДАТА) = '2002-01-04';

--3
SELECT COUNT(ФАМИЛИЯ) FROM 
	(SELECT ФАМИЛИЯ 
		FROM Н_ЛЮДИ 
		GROUP BY ФАМИЛИЯ) 
AS РЕЗУЛЬТАТ;

--4
SELECT ГРУППА 
FROM (SELECT ПЛАН_ИД, ЧЛВК_ИД, ГРУППА, ПРИЗНАК, СОСТОЯНИЕ, ВИД_ОБУЧ_ИД, 
		EXTRACT(year FROM (НАЧАЛО)) AS ГОД_НАЧ, 
		EXTRACT(year FROM (КОНЕЦ)) AS ГОД_КОН 
		FROM Н_УЧЕНИКИ У
		JOIN Н_ВИДЫ_ОБУЧЕНИЯ ВО ON ВО.ИД = У.ВИД_ОБУЧ_ИД
		WHERE АББРЕВИАТУРА IN ('Осн', 'Втор обр') 
		AND ПРИЗНАК = 'обучен' 
		AND СОСТОЯНИЕ = 'утвержден') AS У  
WHERE ГОД_НАЧ <= '2011' 
AND ГОД_КОН >= '2011'
AND ПЛАН_ИД IN 
	(SELECT П.ИД 
	FROM Н_ПЛАНЫ П 
	JOIN Н_ОТДЕЛЫ О ON П.ОТД_ИД_ЗАКРЕПЛЕН_ЗА = О.ИД 
	WHERE О.КОРОТКОЕ_ИМЯ = 'ВТ' 
	AND П.УЧЕБНЫЙ_ГОД IN ('2010/2011', '2011/2012')) 
GROUP BY У.ГРУППА 
HAVING COUNT(DISTINCT У.ЧЛВК_ИД) = 5;

--5
SELECT ГРУППА, FLOOR(AVG(DATE_PART('year', AGE(ДАТА_РОЖДЕНИЯ)))) AS СРЕДНИЙ_ВОЗРАСТ 
FROM (SELECT DISTINCT Л.ИД, У.ГРУППА, ДАТА_РОЖДЕНИЯ
		FROM Н_ЛЮДИ Л
		JOIN Н_УЧЕНИКИ У ON У.ЧЛВК_ИД = Л.ИД
		WHERE У.ВИД_ОБУЧ_ИД IN (1, 2)) AS СТУДЕНТЫ 
GROUP BY ГРУППА 
HAVING FLOOR(AVG(DATE_PART('year', AGE(ДАТА_РОЖДЕНИЯ)))) > 
	(SELECT MIN(DATE_PART('year', AGE(Л.ДАТА_РОЖДЕНИЯ)))
	FROM Н_УЧЕНИКИ У 
	JOIN Н_ЛЮДИ Л ON Л.ИД = У.ЧЛВК_ИД 
	WHERE У.ГРУППА = '1101' 
	AND У.ВИД_ОБУЧ_ИД IN (1, 2));

--6
SELECT У.ГРУППА, У.ИД, Л.ФАМИЛИЯ, Л.ИМЯ, Л.ОТЧЕСТВО, У.П_ПРКОК_ИД
FROM Н_УЧЕНИКИ У
JOIN Н_ЛЮДИ Л ON Л.ИД = У.ЧЛВК_ИД
WHERE У.ПРИЗНАК = 'отчисл'
AND У.СОСТОЯНИЕ = 'утвержден'
AND DATE(У.КОНЕЦ) < '2012-09-01'
AND У.ПЛАН_ИД IN 
	(SELECT П.ИД 
	FROM Н_ПЛАНЫ П
	JOIN Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ Н ON Н.ИД = П.НАПС_ИД
	JOIN Н_НАПР_СПЕЦ НС ON НС.ИД = Н.НС_ИД 
	WHERE П.ФО_ИД IN (1, 3)
	AND П.УЧЕБНЫЙ_ГОД = '2011/2012' 
	AND НС.НАИМЕНОВАНИЕ = 'Программная инженерия');

--7
SELECT COUNT(DISTINCT ЧЛВК_ИД) FROM Н_УЧЕНИКИ У
WHERE ПЛАН_ИД IN 
	(SELECT П.ИД FROM Н_ПЛАНЫ П
	JOIN Н_ОТДЕЛЫ О ON П.ОТД_ИД = О.ИД
	WHERE КОРОТКОЕ_ИМЯ = 'КТиУ')
AND ЧЛВК_ИД IN 
	(SELECT ЧЛВК_ИД
		FROM (SELECT ЧЛВК_ИД, CASE
		WHEN ОЦЕНКА = '5' THEN 5
		WHEN ОЦЕНКА = '4' THEN 4
		WHEN ОЦЕНКА = '3' THEN 3
		WHEN ОЦЕНКА = '2' THEN 2
		WHEN ОЦЕНКА = 'зачет' THEN 5
		WHEN ОЦЕНКА = 'незач' THEN 2
		WHEN ОЦЕНКА = 'осв' THEN 5
		WHEN ОЦЕНКА = 'неявка' THEN 2
		ELSE 1
		END ОЦЕНКА FROM Н_ВЕДОМОСТИ) AS ВЕДОМОСТИ 
	GROUP BY ЧЛВК_ИД HAVING AVG(ОЦЕНКА) = 5);