-- CREATE TABLE Users
-- (
--     ID INT PRIMARY KEY,
--     FirstName NVARCHAR(50) NOT NULL,
--     LastName NVARCHAR(50) NOT NULL,
--     Email NVARCHAR(100) NOT NULL,
--     Gender BIT,
--     JoinDate DATETIME,
--     PhotoUrl NVARCHAR(MAX),
--     UserName NVARCHAR(50),
--     Verified BIT,
-- );

-- ALTER TABLE Users
-- ADD CONSTRAINT VerifiedState DEFAULT 0 FOR Verified

-- SELECT * FROM Users

-- CREATE TABLE Followers
-- (
--     FollowerID INT,
--     FollowedID INT,
--     FollowedDate DATETIME DEFAULT GETDATE(),
--     PRIMARY KEY (FollowerID, FollowedID),
--     FOREIGN KEY (FollowerID) REFERENCES Users(ID),
--     FOREIGN KEY (FollowedID) REFERENCES Users(ID),
-- );

-- CREATE TABLE Posts
-- (
--     ID INT PRIMARY KEY,
--     AuthorID INT,
--     Title NVARCHAR(MAX),
--     Body NVARCHAR(MAX),
--     Images NVARCHAR(MAX),
--     Videos NVARCHAR(MAX),
--     PublishDate DATETIME DEFAULT GETDATE(),
--     ParentPostID INT,
--     FOREIGN KEY (AuthorID) REFERENCES Users(ID),
--     FOREIGN KEY (ParentPostID) REFERENCES Posts(ID),
-- );

-- CREATE TABLE Reactions
-- (
--     ID INT PRIMARY KEY,
--     PostID INT,
--     ReactionType NVARCHAR,
--     ReactionDate DATETIME DEFAULT GETDATE(),
--     FOREIGN KEY (PostID) REFERENCES Posts(ID),
-- );