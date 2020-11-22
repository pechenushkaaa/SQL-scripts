--connect to server: psql -h pg -d studs

INSERT INTO visitors (name, sex) VALUES('Алистра', 'Ж'); 

INSERT INTO emotions (state) VALUES('пораженная');

INSERT INTO visitors_emotions VALUES(1, 1);

INSERT INTO exhibitions (name) VALUES
('СОВРЕМЕННЫЕ ТЕХНОЛОГИИ'),
('Искусство 30-х годов');

INSERT INTO tickets (visitor_id, exhibition_id, price) VALUES(1, 1, 450);

INSERT INTO exhibits (name, theme, copies, happiness_ratio_per_viewing) VALUES 
('ИСЛАНДИЯ', 'ИНФОРМАЦИОННАЯ МАШИНА', 1, 1.4),
('APPLE MAX 1.0', 'ИНФОРМАЦИОННАЯ МАШИНА', 1, 4.6),
('ЧЕРНЫЙ КВАДРАТ', 'КАРТИНА', 1, 0.9),
('IBM360', 'ИНФОРМАЦИОННАЯ МАШИНА', 1, 8.6),
('АСТОРИЯ', 'СКУЛЬПТУРА', 1, 1.7),
('КЕТЧУП ХЙАНЗ', 'КАРТИНА', 1, 0.97);

INSERT INTO exhibition_location (location) VALUES('Вестибюль Зала Совета');

INSERT INTO exhibition_content (exhibition_id, exhibit_id, location_id) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 4, 1),
(2, 3, 1),
(2, 5, 1),
(2, 6, 1);
