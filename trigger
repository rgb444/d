CREATE TABLE Library (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(255),
    PublishedYear INT
);

CREATE TABLE Library_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    OperationType VARCHAR(50), -- 'UPDATE' or 'DELETE'
    BookID INT,
    Title VARCHAR(255),
    Author VARCHAR(255),
    PublishedYear INT,
    OperationTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER Before_Library_Update
BEFORE UPDATE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (OperationType, BookID, Title, Author, PublishedYear)
    VALUES ('UPDATE', OLD.BookID, OLD.Title, OLD.Author, OLD.PublishedYear);
END;
$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER Before_Library_Delete
BEFORE DELETE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (OperationType, BookID, Title, Author, PublishedYear)
    VALUES ('DELETE', OLD.BookID, OLD.Title, OLD.Author, OLD.PublishedYear);
END;
$$

DELIMITER ;

INSERT INTO Library (BookID, Title, Author, PublishedYear)
VALUES 
(1, '1984', 'George Orwell', 1949),
(2, 'To Kill a Mockingbird', 'Harper Lee', 1960);

UPDATE Library
SET Author = 'Orwell'
WHERE BookID = 1;

DELETE FROM Library
WHERE BookID = 2;

SELECT * FROM Library_Audit;
