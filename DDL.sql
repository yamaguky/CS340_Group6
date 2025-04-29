-- Group 6: Thomas Murray, Kyohei Yamaguchi


SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- Students table
CREATE OR REPLACE TABLE Students (
    studentID INT AUTO_INCREMENT NOT NULL UNIQUE,
    firstName VARCHAR(45) NOT NULL,
    lastName VARCHAR(45) NOT NULL,
    email VARCHAR(145) NOT NULL,
    major VARCHAR(45),
    PRIMARY KEY (studentID)
);

-- Instructors table
CREATE OR REPLACE TABLE Instructors (
    instructorID INT AUTO_INCREMENT NOT NULL UNIQUE,
    firstName VARCHAR(45) NOT NULL,
    lastName VARCHAR(45) NOT NULL,
    email VARCHAR(145) NOT NULL,
    PRIMARY KEY (instructorID)
);

-- Grades table
CREATE OR REPLACE TABLE Grades (
    gradeID INT AUTO_INCREMENT NOT NULL UNIQUE,
    gradeName VARCHAR(3) NOT NULL,
    gradePoint FLOAT NOT NULL,
    PRIMARY KEY (gradeID)
);

-- Courses table
CREATE OR REPLACE TABLE Courses (
    courseID INT AUTO_INCREMENT NOT NULL UNIQUE,
    courseName VARCHAR(45) NOT NULL,
    courseCode VARCHAR(45) NOT NULL,
    credit INT NOT NULL,
    instructorID INT NOT NULL,
    PRIMARY KEY (courseID),
    
    CONSTRAINT fk_Courses_instructorID
        FOREIGN KEY (instructorID)
        REFERENCES Instructors(instructorID)
        ON DELETE RESTRICT 
);

-- Students_Courses table
CREATE OR REPLACE TABLE Students_Courses (
    enrollmentID INT AUTO_INCREMENT NOT NULL UNIQUE,
    studentID INT NOT NULL,
    courseID INT NOT NULL,
    gradeID INT NOT NULL,
    PRIMARY KEY (enrollmentID),

    CONSTRAINT fk_Students_Courses_studentID
        FOREIGN KEY (studentID)
        REFERENCES Students(studentID)
        ON DELETE CASCADE, 

    CONSTRAINT fk_Students_Courses_courseID
        FOREIGN KEY (courseID)
        REFERENCES Courses(courseID)
        ON DELETE CASCADE, 

    CONSTRAINT fk_Students_Courses_gradeID
        FOREIGN KEY (gradeID)
        REFERENCES Grades(gradeID)
        ON DELETE RESTRICT 
);

INSERT INTO Students (studentID, firstName, lastName, email, major)
VALUES (1, 'Alice', 'Johnson', 'alice.johnson@example.com', 'Computer Science'),
(2, 'Brian', 'Smith', 'brian.smith@example.com', 'Mathematics'),
(3, 'Cathy', 'Lee', 'cathy.lee@example.com', 'History');

INSERT INTO Instructors (instructorID, firstName, lastName, email)
VALUES (1, 'David', 'Miller', 'david.miller@example.com'),
(2, 'Emma', 'Brown', 'emma.brown@example.com'),
(3, 'Frank', 'Wilson', 'frank.wilson@example.com');

INSERT INTO Grades (gradeID, gradeName, gradePoint)
VALUES (1, 'A', 4),
(2, 'B', 3),
(3, 'C', 2),
(4, 'D', 1),
(5, 'F', 0),
(6, 'P', 4),
(7, 'NP', 0);

INSERT INTO Courses (courseID, courseName, courseCode, credit, instructorID)
VALUES (1, 'Database Systems', 'CS340', 4, 1),
(2, 'Calculus I', 'MATH101', 3, 2),
(3, 'American History', 'HIST202', 3, 3);


INSERT INTO Students_Courses (enrollmentID, studentID, courseID, gradeID)
VALUES (1, 1, 1, 1), 
(2, 1, 2, 2),
(3, 2, 2, 3),
(4, 3, 3, 1);


SET FOREIGN_KEY_CHECKS=1;
COMMIT; 