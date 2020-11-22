--connect to server: psql -h pg -d studs

--стержень
CREATE TABLE VISITORS (
	VISITOR_ID serial PRIMARY KEY,
	NAME varchar(20) NOT NULL,
	SURNAME varchar(30),
	AGE smallint,
	SEX varchar(1) CHECK(SEX = 'М' OR SEX = 'Ж'),
	HAPPINESS_SCORE float DEFAULT 1 CHECK(HAPPINESS_SCORE >= 1) 
);

--стержень
CREATE TABLE EXHIBITIONS (
	EXHIBITION_ID serial PRIMARY KEY,
	NAME varchar(50) NOT NULL UNIQUE
);

--стержень
CREATE TABLE EXHIBITS (
	EXHIBIT_ID serial PRIMARY KEY,
	NAME varchar(50) NOT NULL,
	THEME varchar(200),
	RECEIPT_DATE date DEFAULT CURRENT_DATE,
	ORIGIN_HISTORY text,
	COPIES integer NOT NULL,
	HAPPINESS_RATIO_PER_VIEWING float NOT NULL
);

--стержень
CREATE TABLE EXHIBITION_LOCATION (
	LOCATION_ID serial PRIMARY KEY,
	LOCATION varchar(50) NOT NULL UNIQUE
);

--ассоциация
CREATE TABLE EXHIBITION_CONTENT (
	EXHIBITION_ID integer REFERENCES EXHIBITIONS ON UPDATE RESTRICT ON DELETE RESTRICT,
	EXHIBIT_ID integer REFERENCES EXHIBITS ON UPDATE RESTRICT ON DELETE RESTRICT,
	LOCATION_ID integer REFERENCES EXHIBITION_LOCATION ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRIMARY KEY(EXHIBITION_ID, EXHIBIT_ID, LOCATION_ID)
);

--стержень
CREATE TABLE EMOTIONS (
	EMOTION_ID serial PRIMARY KEY,
	STATE VARCHAR(20) DEFAULT('ничего особого')
);

--ассоциация
CREATE TABLE VISITORS_EMOTIONS (
	VISITOR_ID integer REFERENCES VISITORS ON UPDATE RESTRICT ON DELETE RESTRICT,
	EMOTION_ID integer REFERENCES EMOTIONS ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRIMARY KEY(VISITOR_ID, EMOTION_ID)	
);

--ассоциация
CREATE TABLE TICKETS (
	TICKET_ID serial PRIMARY KEY,
	VISITOR_ID integer NOT NULL REFERENCES VISITORS ON UPDATE RESTRICT ON DELETE RESTRICT,
	EXHIBITION_ID integer NOT NULL REFERENCES EXHIBITIONS ON UPDATE RESTRICT ON DELETE RESTRICT,
	PRICE integer,
	PURCHASE_DATE timestamp DEFAULT CURRENT_TIMESTAMP
	CHECK(PURCHASE_DATE <= CURRENT_TIMESTAMP)
); 

