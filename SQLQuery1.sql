use third_assignment
CREATE DATABASE electionv2
USE electionv2
-- START Table creation statements

CREATE TABLE Election(
id INT PRIMARY KEY IDENTITY(1,1),
election_date DATE NOT NULL,
);

CREATE TABLE Voter(
id INT PRIMARY KEY IDENTITY(1,1),
voter_name VARCHAR(50) NOT NULL,
voter_surname VARCHAR(50) NOT NULL,
sign_picture VARCHAR(50) NOT NULL,
citizenship_id VARCHAR(50) NOT NULL,
voter_address VARCHAR(150) NOT NULL,
election_id INT FOREIGN KEY REFERENCES Election(id)
);

CREATE TABLE Party(
id INT PRIMARY KEY IDENTITY(1,1),
P_Name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE Candidate(
id INT PRIMARY KEY IDENTITY(1,1),
party_id INT FOREIGN KEY REFERENCES Party(id),
election_id INT FOREIGN KEY REFERENCES Election(id)
[state] BIT DEFAULT 1 NOT NULL
);


CREATE TABLE Area(
id INT PRIMARY KEY IDENTITY(1,1),
area_name VARCHAR(50) NOT NULL
);


CREATE TABLE Ballotbox(
id INT PRIMARY KEY IDENTITY(1,1),
ballotBox_no INT NOT NULL,
area_id INT FOREIGN KEY REFERENCES Area(id),
election_id INT FOREIGN KEY REFERENCES Election(id)
);



CREATE TABLE Vote(
id INT PRIMARY KEY IDENTITY(1,1),
candidate_id INT FOREIGN KEY REFERENCES Candidate(id), -- Data that identifies who the voter voted for (Cast in)
ballotbox_id INT FOREIGN KEY REFERENCES Ballotbox(id)
);

-- END Table creation statements


-- START Altering table statements
-- Add voter isA reference
ALTER TABLE Candidate ADD voter_id INT FOREIGN KEY REFERENCES Voter(id);

-- Alter citizenship_id column data type varchar to integer due to unnecessary data size
ALTER TABLE Voter ALTER COLUMN citizenship_id BIGINT NOT NULL

-- Some party name cant fit into 50 chars
ALTER TABLE Party ALTER COLUMN P_Name VARCHAR(150) NOT NULL 
-- END Altering table statements


-- START Insert record statements

INSERT INTO Election(election_date) VALUES ('03.31.2024');

INSERT INTO Voter (voter_name,voter_surname,sign_picture,citizenship_id,voter_address,election_id)
VALUES ('İrem','KUTAY','kutaysign.png',34349961098,'İstanbul/Ataşehir, Kıbrıs Şehitleri Cad./muzaffer İzgi Sk No:9',1),
('Rüya','TAŞLI','ruyasign.png',79452282470,'İstanbul/Ümraniye, Kuşadası Mah. 76/1',1),
('Şahnur','Körmükçü','sahnur.png',60696593026,'İstanbul/Sancaktepe, Samandıra, Osmangazi Mah. Esma Sokak, no 41',1),
('Ferid','Abadan','abadan.png',25632303824,'İstanbul/Bahçelievler,Kocasinan Merkez Mh.',1),
('Emel','Sayın','emel.png',94199249692,'Tarabya Mh. Yeniköy Tarabya Cd. Pk:34457 Sarıyer/istanbul',1),
('Ekrem','İmamoğlu','ekrem.png',46593214868,'İstanbul/Tuzla,  6 İmren Sokak',1),
('Murat','Kurum','kurum.png',24096138508,'İstanbul/Sarıyer,  6 Kordon Boyu Sokak',1),
('Adem','Bayraktar','adem.png',44632299616,'İstanbul/Tuzla 4 B Kubilay Sk.',1),
('Ahmet','Soytürk','ahmet.png',87224568158,'İstanbul/Çamlık, A-5 Blok, 1/5 Piri Reis Caddesi ',1)

INSERT INTO Party (P_Name) 
VALUES ('Cumhuriyet Halk Partisi'),('Adalet Ve Kalkınma Partisi'), ('Türkiye İşçi Partisi'),('Milliyetçi Hareket Partisi'),('Gelecek Partisi'),('Memleket Partisi')

-- Add independent candidate 
INSERT INTO Party (P_Name) VALUES ('Bağımsız Aday')

INSERT INTO Candidate (party_id,election_id,voter_id) 
VALUES (2,1,7),(3,1,8),(4,1,9),(5,1,10)

INSERT INTO Area (area_name) VALUES ('Adalar'),('Arnavutköy'),('Ataşehir'),('Avılar')
,('Bağcılar'),('Bahçelievler'),('Bakırköy'),('Başakşehir'),('Bayrampaşa')
,('Beşiktaş'),('Beykoz'),('Beylikdüzü'),('Beyoğulu'),('Büyükçekmece'),('Çatalca')
,('Çekmeköy'),('Esenler'),('Esenyurt'),('Eyüpsultan'),('Fatih'),('Gaziosmanpaşa'),('Gügören')
,('Kadıköy'),('Kağıthane'),('Kartal'),('Küçükçekmece'),('Maltepe'),('Pendik'),('Sancaktepe')
,('Sarıyer'),('Silivri'),('Sultanbeyli'),('Sultangazi'),('Şile'),('Şişli')
,('Tuzla'),('Ümraniye'),('Üsküdar'),('Zeytinburnu')


-- Drop ballotbox_no column from Ballotbox due to simplyfing the ballotbox identity
-- id is enough for select a record
-- DROP Statement
ALTER TABLE Ballotbox DROP COLUMN ballotBox_no

INSERT INTO Ballotbox (area_id,election_id) 
VALUES (1,1),(2,1),(2,1),(2,1),(3,1),(3,1),(4,1),(4,1),(5,1),(5,1),(6,1),(6,1),(6,1),(6,1),(7,1),(7,1),
(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(17,1),(18,1),(19,1),(20,1),(21,1),
(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),
(37,1),(38,1),(38,1),(38,1),(38,1)

INSERT INTO Vote(candidate_id, ballotbox_id)
VALUES (1,10),(1,11),(3,2),(4,3),(2,30),(3,29),(1,23),(2,17)
-- END Insert record statements

-- START Update record statements

-- AKP alters their candidate
UPDATE Candidate SET voter_id=2 WHERE Candidate.id=2

-- Hash all citizenship id's due to security reasons using 
-- Divide to 2 and decrease 25812334
UPDATE Voter SET citizenship_id=((citizenship_id/2)-25812334)
-- END Update record statements

-- START Delete record statements
-- Delete the parties that does not have any candidate
DELETE FROM Party WHERE id in (6,7,8)

-- Invalid votes deleted for election result
DELETE FROM Vote WHERE id in (5,8)


--Turkish Labor Party is withdrawing from the election and saying that they will support CHP 
-- and withdrawing its candidate, so all votes given to TİP will be considered invalid.
DELETE FROM Vote WHERE candidate_id=3
DELETE FROM Candidate WHERE id=3
DELETE FROM Party WHERE id=4
-- END Delete record statements

-- START Drop statements
-- Remove old database to update foreign key references
-- IDENTITY auto increment function is not work properly due to references, so the old database was removed.
DROP DATABASE third_assignment

-- Drop statement in the top of SQL query
-- ALTER TABLE Ballotbox DROP COLUMN ballotBox_no

-- END Drop statements

-- Withdraw the candidates below the threshold from the selection by setting their state column equal to zero.

-- Procedure
CREATE PROCEDURE barajin_alti
AS BEGIN
	UPDATE Candidate 
	SET [state] = 0
	FROM Candidate c
	-- Join
	LEFT JOIN (
	SELECT candidate_id, COUNT(*) AS total_vote
	FROM Vote
	-- Group By
	GROUP BY candidate_id
	) AS vote_count
	ON candidate_id = vote_count.candidate_id
WHERE vote_count.total_vote <= 1;
END

EXEC barajin_alti

-- Get Winner
-- Procedure
CREATE PROCEDURE get_winner
AS BEGIN
	-- Top Statement
	SELECT TOP 1 COUNT(candidate_id) as total_vote, candidate_id, v.voter_name FROM Vote JOIN Candidate AS c 
	ON candidate_id=c.id 
	-- Join
	JOIN Voter as v ON v.id=c.voter_id
	-- Group By
	GROUP BY candidate_id,voter_name
END

EXEC get_winner

-- To inhibit data lose delete statement banned from Candidate table in system wide by trigger.
CREATE TRIGGER inhibit_delete on Candidate
INSTEAD OF DELETE
AS BEGIN
	DECLARE @candidate_id INT;
	SELECT @candidate_id=id FROM DELETED
	UPDATE Candidate SET [state]=0 WHERE id=@candidate_id
END


-- DELETE and UPDATE statements are not possible due to security reasons.
CREATE TRIGGER votes_cant_change ON Vote
INSTEAD OF DELETE,UPDATE
AS BEGIN
PRINT('Votes cannot be changed anyway!')
END

-- Checks Voter data
CREATE FUNCTION is_valid_voter(@citizenship_id VARCHAR(50),@election_id INT)
RETURNS BIT
AS BEGIN
	DECLARE @Result INT;
	SELECT @Result=1;
	IF (LEN(@citizenship_id)!=11) SELECT @Result=0
	IF (@election_id NOT IN (SELECT id FROM Election)) SELECT @Result=0
	RETURN @Result
END

-- Insert Voter by procedure
CREATE PROCEDURE insert_voter(@name VARCHAR(50),@surname VARCHAR(50),@sign VARCHAR(50),@citizenship_id VARCHAR(50),@election_id INT)
AS BEGIN
  DECLARE @Result BIT;
      SELECT @Result = dbo.is_valid_voter(@citizenship_id, @election_id);
      IF @Result = 1
      BEGIN
          INSERT INTO Voter(voter_name, voter_surname, sign_picture, citizenship_id, election_id) 
		  VALUES(@name, @surname, @sign, @citizenship_id, @election_id);
	END
	ELSE
	BEGIN
	PRINT('Invalid voter data')
	END
END;

-- Get total votes of areas between 1 and 15. First 15 areas is included to 1st territory
SELECT area_name,COUNT(area_name) as total_vote FROM Vote AS v JOIN Ballotbox AS b ON v.ballotbox_id=b.id 
JOIN Area as a ON b.area_id=a.id GROUP BY area_name,a.id HAVING a.id BETWEEN 1 and 15


-- Calculate parties total vote
CREATE FUNCTION sum_party_votes(@party_id int)
RETURNS INT
AS BEGIN
DECLARE @Result INT;
SELECT @Result=COUNT(candidate_id) FROM Vote v JOIN Candidate c ON c.id=v.candidate_id JOIN Voter voter ON voter.id=c.voter_id 
JOIN Party p ON c.party_id=p.id
GROUP BY candidate_id,voter_name,p.[P_Name],p.id HAVING p.id=@party_id 
RETURN @Result
END


-- Sum of 2 parties vote
CREATE FUNCTION sum_2_party_votes(@party2 int,@party1 int)
RETURNS INT
AS BEGIN
DECLARE @Result INT
DECLARE @party1_vote INT, @party2_vote INT
SELECT @party1_vote=dbo.sum_party_votes(@party1)
SELECT @party2_vote=dbo.sum_party_votes(@party2)
SELECT @Result=SUM(@party1_vote+@party2_vote)
RETURN @Result
END

-- Ballotbox-area join
SELECT election_id,area_name FROM Ballotbox b JOIN Area a ON b.area_id=a.id
-- Candidate
SELECT * FROM Candidate c JOIN Party p ON c.party_id=p.id

-- Create View
CREATE VIEW party_candidate AS SELECT voter_name,voter_surname,P_Name FROM Candidate c JOIN Party p ON c.party_id=p.id JOIN Voter v ON c.voter_id=v.id
SELECT * FROM party_candidate
-- Alter Table -> Add Total Vote to table
ALTER VIEW party_candidate AS SELECT voter_name,voter_surname,P_Name,dbo.sum_party_votes(p.id) as 'Total Vote' FROM Candidate c JOIN Party p ON c.party_id=p.id JOIN Voter v ON c.voter_id=v.id

-- Calculate the party how much candidate has
SELECT COUNT(DISTINCT c.id) AS 'Unique Candidate Number',p.P_Name AS 'Party' FROM Candidate c JOIN Party p ON p.id=c.party_id GROUP BY c.id,p.P_Name

--Order by total vote
CREATE PROCEDURE order_by_total_vote AS SELECT * FROM party_candidate ORDER BY 4 DESC
EXEC order_by_total_vote