DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;

-- This is the Course table
 
DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
Crs_Code 	INT UNSIGNED NOT NULL,
Crs_Title 	VARCHAR(255) NOT NULL,
Crs_Enrollment INT UNSIGNED,
PRIMARY KEY (Crs_code));


INSERT INTO Course VALUES 
(100,'BSc Computer Science', 150),
(101,'BSc Computer Information Technology', 20),
(200, 'MSc Data Science', 100),
(201, 'MSc Security', 30),
(210, 'MSc Electrical Engineering', 70),
(211, 'BSc Physics', 100);


-- This is the student table definition


DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
URN INT UNSIGNED NOT NULL,
Stu_FName 	VARCHAR(255) NOT NULL,
Stu_LName 	VARCHAR(255) NOT NULL,
Stu_DOB 	DATE,
Stu_Phone 	VARCHAR(12),
Stu_Course	INT UNSIGNED NOT NULL,
Stu_Type 	ENUM('UG', 'PG'),
PRIMARY KEY (URN),
FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code)
ON DELETE RESTRICT);


INSERT INTO Student VALUES
(612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'UG'),
(612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'UG'),
(612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'UG'),
(612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'UG'),
(612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'UG'),
(612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'UG'),
(612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'UG'),
(612352, 'Tom', 'Jones', '2001-10-24',  '01483456789', 101, 'UG'),
(612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'UG'),
(612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'UG');

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE Undergraduate (
UG_URN 	INT UNSIGNED NOT NULL,
UG_Credits   INT NOT NULL,
CHECK (60 <= UG_Credits <= 150),
PRIMARY KEY (UG_URN),
FOREIGN KEY (UG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);

INSERT INTO Undergraduate VALUES
(612345, 120),
(612346, 90),
(612347, 150),
(612348, 120),
(612349, 120),
(612350, 60),
(612351, 60),
(612352, 90),
(612353, 120),
(612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE Postgraduate (
PG_URN 	INT UNSIGNED NOT NULL,
Thesis  VARCHAR(512) NOT NULL,
PRIMARY KEY (PG_URN),
FOREIGN KEY (PG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);


-- Please add your table definitions below this line.......
CREATE TABLE Hobby (
URN INT UNSIGNED NOT NULL,
Name VARCHAR(255) NOT NULL,
Description VARCHAR(255),
Category VARCHAR(255),
PRIMARY KEY(URN, Name),
FOREIGN KEY (URN) REFERENCES Student(URN));

INSERT INTO Hobby(URN, Name, Description, Category) VALUES
(612345, 'Painting', 'Creating artwork using paint on surfaces and canvases', 'Art'),
(612345, 'Hiking', 'Walking long distances in nature', 'Outdoor'),
(612347, 'Woodworking', 'Crafting objects from wood', 'Crafts'),
(612348, 'Playing Guitar', 'Performing music using a guitar', 'Music'),
(612348, 'Gardening', 'Growing and taking care of plants and flowers', 'Outdoor'),
(612348, 'Cycling', 'Riding bicycles for leisure or sport', 'Fitness'),
(612349, 'Knitting', 'Creating fabrics by interlocking loops of yarn', 'Crafts');

CREATE TABLE Campaign (
CampaignID INT NOT NULL AUTO_INCREMENT,
Title VARCHAR(32),
Description VARCHAR(255),
Theme VARCHAR(255),
GameSystem VARCHAR(255) NOT NULL,
PlayerNum TINYINT,
DayRanOn ENUM("MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"),
NewPlayerFriendly BOOL,
CurrentLevel TINYINT,
PRIMARY KEY(CampaignID));

INSERT INTO Campaign(Title, Description, Theme, GameSystem, PlayerNum, DayRanON, NewPlayerFriendly, CurrentLevel) VALUES
('Clockwork Citadel', 'The Great Exhibition was meant to show the might of the nation, proving they were strong too. Alas, the Grand Covenant broke and the automatons rampage throughout the city.', 'Mystery and Steampunk', 'Dungeons & Dragons 5.5e', 4, "TUESDAY", TRUE, 17),
('Cyber Heist', 'The crew must infiltrate the heavily guarded Neon Tower to retrieve a stolen AI core. The line between ally and enemy blurs as secrets unravel.', 'Sci-Fi', 'Shadowrun', 4, "FRIDAY", FALSE, 5),
('Echoes of Eternity', 'A forgotten prophecy awakens, leading adventurers into the desolate ruins of the Eternal Spire. The fate of time itself hangs in the balance.', 'Fantasy', 'Pathfinder 2e', 6, "WEDNESDAY", TRUE, 3),
('Void Horizon', 'A derelict spaceship drifts on the edge of known space. Its distress signal leads to an expedition, uncovering ancient alien mysteries and dangers.', 'Sci-Fi and Horror', 'Starfinder', 5, "THURSDAY", FALSE, 8),
('Curse of Black Hollow', 'The small town of Black Hollow is shrouded in darkness, plagued by whispers of a witch’s curse. Only the brave can uncover the truth.', 'Horror', 'Dungeons & Dragons 5e', 4, "TUESDAY", FALSE, 13),
('Tempest’s Wrath', 'The Sea Lord’s Trident, a mythical artifact, is said to calm the raging seas. The crew must navigate dangerous waters and rival pirates to claim it.', 'Action and Adventure', '7th Sea', 5, "MONDAY", TRUE, 2),
('Titanfall Legacy', 'The world trembles as ancient war machines, known as Titans, awaken. A desperate mission begins to uncover their origins and stop their wrath.', 'Action', 'MechWarrior', 3, "SUNDAY", FALSE, 10),
('Sylvan Shadows', 'The enchanted forest of Eldergrove holds secrets long forgotten. As its magic begins to fade, heroes must venture deep to restore the balance.', 'Fantasy', 'Dungeons & Dragons 4e', 5, "SATURDAY", TRUE, 1);
