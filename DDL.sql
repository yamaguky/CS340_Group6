-- Group 6: Thomas Murray, Kyohei Yamaguchi
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

CREATE OR REPLACE TABLE Students (
    studentID   INT AUTO_INCREMENT PRIMARY KEY,
    firstName   VARCHAR(45) NOT NULL,
    lastName    VARCHAR(45) NOT NULL,
    email       VARCHAR(145) NOT NULL,
    major       VARCHAR(45)
);

CREATE OR REPLACE TABLE Instructors (
    instructorID INT AUTO_INCREMENT PRIMARY KEY,
    firstName    VARCHAR(45) NOT NULL,
    lastName     VARCHAR(45) NOT NULL,
    email        VARCHAR(145) NOT NULL
);

CREATE OR REPLACE TABLE Grades (
    gradeID    INT AUTO_INCREMENT PRIMARY KEY,
    gradeName  VARCHAR(3) NOT NULL,  
    gradePoint FLOAT NOT NULL
);

CREATE OR REPLACE TABLE Courses (
    courseID     INT AUTO_INCREMENT PRIMARY KEY,
    courseName   VARCHAR(45) NOT NULL,
    courseCode   VARCHAR(45) NOT NULL,
    credit       INT NOT NULL,
    instructorID INT NOT NULL,
    CONSTRAINT fk_Courses_instructor
      FOREIGN KEY (instructorID)
      REFERENCES Instructors(instructorID)
      ON DELETE RESTRICT
);

CREATE OR REPLACE TABLE Students_Courses (
    enrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    studentID INT NOT NULL,
    courseID  INT NOT NULL,
    gradeID   INT NOT NULL,
    CONSTRAINT fk_SC_student
      FOREIGN KEY (studentID) REFERENCES Students(studentID)  ON DELETE CASCADE,
    CONSTRAINT fk_SC_course
      FOREIGN KEY (courseID)  REFERENCES Courses(courseID)   ON DELETE CASCADE,
    CONSTRAINT fk_SC_grade
      FOREIGN KEY (gradeID)   REFERENCES Grades(gradeID)     ON DELETE RESTRICT
);


-- Students
INSERT INTO Students (firstName, lastName, email, major) VALUES
  ('Alice', 'Johnson', 'alice.johnson@example.com', 'Computer Science'),
  ('Brian', 'Smith',   'brian.smith@example.com',   'Mathematics'),
  ('Cathy', 'Lee',     'cathy.lee@example.com',     'History');

-- Instructors
INSERT INTO Instructors (firstName, lastName, email) VALUES
  ('David', 'Miller', 'david.miller@example.com'),
  ('Emma',  'Brown',  'emma.brown@example.com'),
  ('Frank', 'Wilson', 'frank.wilson@example.com');

-- Grades
INSERT INTO Grades (gradeName, gradePoint) VALUES
  ('A', 4), ('B', 3), ('C', 2), ('D', 1), ('F', 0), ('P', 4), ('NP', 0);

-- Courses  
INSERT INTO Courses (courseName, courseCode, credit, instructorID) VALUES
  ('Database Systems', 'CS340',    4,
     (SELECT instructorID FROM Instructors WHERE email = 'david.miller@example.com')),
  ('Calculus I',        'MATH101', 3,
     (SELECT instructorID FROM Instructors WHERE email = 'emma.brown@example.com')),
  ('American History',  'HIST202', 3,
     (SELECT instructorID FROM Instructors WHERE email = 'frank.wilson@example.com'));

-- Students_Courses
INSERT INTO Students_Courses (studentID, courseID, gradeID) VALUES
  ( (SELECT studentID  FROM Students  WHERE email = 'alice.johnson@example.com'),
    (SELECT courseID   FROM Courses   WHERE courseCode = 'CS340'),
    (SELECT gradeID    FROM Grades    WHERE gradeName  = 'A') ),

  ( (SELECT studentID  FROM Students  WHERE email = 'alice.johnson@example.com'),
    (SELECT courseID   FROM Courses   WHERE courseCode = 'MATH101'),
    (SELECT gradeID    FROM Grades    WHERE gradeName  = 'B') ),

  ( (SELECT studentID  FROM Students  WHERE email = 'brian.smith@example.com'),
    (SELECT courseID   FROM Courses   WHERE courseCode = 'MATH101'),
    (SELECT gradeID    FROM Grades    WHERE gradeName  = 'C') ),

  ( (SELECT studentID  FROM Students  WHERE email = 'cathy.lee@example.com'),
    (SELECT courseID   FROM Courses   WHERE courseCode = 'HIST202'),
    (SELECT gradeID    FROM Grades    WHERE gradeName  = 'A') );

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
