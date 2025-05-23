-- PL.SQL  – Stored Procedures for CS340 Project (Step 4 Draft)
-- Group 6: Thomas Murray, Kyohei Yamaguchi
-- This file defines:
--   1) sp_reset_projectDB  – rebuilds schema & seed data
--   2) deleteSampleStudent – simple DELETE demo for RESET check
--   3) sp_createStudent    – create student
--   4) sp_updateStudent    – update student
--   5) sp_deleteStudent    – delete student
--   6) sp_createInstructor – create instructor
--   7) sp_updateInstructor – update instructor
--   8) sp_deleteInstructor – delete instructor
--   9) sp_createCourse     – create course
--  10) sp_updateCourse     – update course
--  11) sp_deleteCourse     – delete course

DELIMITER //

DROP PROCEDURE IF EXISTS sp_reset_projectDB //
CREATE PROCEDURE sp_reset_projectDB()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    SET AUTOCOMMIT = 0;

    DROP TABLE IF EXISTS Students_Courses;
    DROP TABLE IF EXISTS Courses;
    DROP TABLE IF EXISTS Grades;
    DROP TABLE IF EXISTS Students;
    DROP TABLE IF EXISTS Instructors;

    CREATE TABLE Students (
        studentID INT AUTO_INCREMENT PRIMARY KEY,
        firstName VARCHAR(45) NOT NULL,
        lastName  VARCHAR(45) NOT NULL,
        email     VARCHAR(145) NOT NULL,
        major     VARCHAR(45)
    );

    CREATE TABLE Instructors (
        instructorID INT AUTO_INCREMENT PRIMARY KEY,
        firstName    VARCHAR(45) NOT NULL,
        lastName     VARCHAR(45) NOT NULL,
        email        VARCHAR(145) NOT NULL
    );

    CREATE TABLE Grades (
        gradeID    INT AUTO_INCREMENT PRIMARY KEY,
        gradeName  VARCHAR(3) NOT NULL,
        gradePoint FLOAT NOT NULL
    );

    CREATE TABLE Courses (
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

    CREATE TABLE Students_Courses (
        enrollmentID INT AUTO_INCREMENT PRIMARY KEY,
        studentID INT NOT NULL,
        courseID  INT NOT NULL,
        gradeID   INT NOT NULL,
        CONSTRAINT fk_SC_student  FOREIGN KEY (studentID) REFERENCES Students(studentID)  ON DELETE CASCADE,
        CONSTRAINT fk_SC_course   FOREIGN KEY (courseID)  REFERENCES Courses(courseID)   ON DELETE CASCADE,
        CONSTRAINT fk_SC_grade    FOREIGN KEY (gradeID)   REFERENCES Grades(gradeID)     ON DELETE RESTRICT
    );

    INSERT INTO Students (firstName, lastName, email, major) VALUES
      ('Alice', 'Johnson', 'alice.johnson@example.com', 'Computer Science'),
      ('Brian', 'Smith',   'brian.smith@example.com',   'Mathematics'),
      ('Cathy', 'Lee',     'cathy.lee@example.com',     'History');

    INSERT INTO Instructors (firstName, lastName, email) VALUES
      ('David', 'Miller', 'david.miller@example.com'),
      ('Emma',  'Brown',  'emma.brown@example.com'),
      ('Frank', 'Wilson', 'frank.wilson@example.com');

    INSERT INTO Grades (gradeName, gradePoint) VALUES
      ('A', 4), ('B', 3), ('C', 2), ('D', 1), ('F', 0), ('P', 4), ('NP', 0);

    INSERT INTO Courses (courseName, courseCode, credit, instructorID) VALUES
      ('Database Systems', 'CS340',    4,
         (SELECT instructorID FROM Instructors WHERE email = 'david.miller@example.com')),
      ('Calculus I',        'MATH101', 3,
         (SELECT instructorID FROM Instructors WHERE email = 'emma.brown@example.com')),
      ('American History',  'HIST202', 3,
         (SELECT instructorID FROM Instructors WHERE email = 'frank.wilson@example.com'));

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
END //

-- Simple DELETE for reset check
DROP PROCEDURE IF EXISTS deleteSampleStudent //
CREATE PROCEDURE deleteSampleStudent()
BEGIN
  DELETE FROM Students WHERE email = 'alice.johnson@example.com';
END //

-- CRUD Procedures
DROP PROCEDURE IF EXISTS sp_createStudent //
CREATE PROCEDURE sp_createStudent(IN fn VARCHAR(45), IN ln VARCHAR(45), IN em VARCHAR(145), IN maj VARCHAR(45))
BEGIN
  INSERT INTO Students (firstName, lastName, email, major) VALUES (fn, ln, em, maj);
END //

DROP PROCEDURE IF EXISTS sp_updateStudent //
CREATE PROCEDURE sp_updateStudent(IN sid INT, IN em VARCHAR(145), IN maj VARCHAR(45))
BEGIN
  UPDATE Students SET email = COALESCE(em, email), major = COALESCE(maj, major) WHERE studentID = sid;
END //

DROP PROCEDURE IF EXISTS sp_deleteStudent //
CREATE PROCEDURE sp_deleteStudent(IN sid INT)
BEGIN
  DELETE FROM Students WHERE studentID = sid;
END //

DROP PROCEDURE IF EXISTS sp_createInstructor //
CREATE PROCEDURE sp_createInstructor(IN fn VARCHAR(45), IN ln VARCHAR(45), IN em VARCHAR(145))
BEGIN
  INSERT INTO Instructors (firstName, lastName, email) VALUES (fn, ln, em);
END //

DROP PROCEDURE IF EXISTS sp_updateInstructor //
CREATE PROCEDURE sp_updateInstructor(IN iid INT, IN fn VARCHAR(45), IN ln VARCHAR(45), IN em VARCHAR(145))
BEGIN
  UPDATE Instructors
     SET firstName = COALESCE(fn, firstName),
         lastName  = COALESCE(ln, lastName),
         email     = COALESCE(em, email)
   WHERE instructorID = iid;
END //

DROP PROCEDURE IF EXISTS sp_deleteInstructor //
CREATE PROCEDURE sp_deleteInstructor(IN iid INT)
BEGIN
  DELETE FROM Instructors WHERE instructorID = iid;
END //

DROP PROCEDURE IF EXISTS sp_deleteInstructorWithCourses //
CREATE PROCEDURE sp_deleteInstructorWithCourses(IN iid INT)
BEGIN
  DELETE FROM Courses WHERE instructorID = iid;
  DELETE FROM Instructors WHERE instructorID = iid;
END //

DROP PROCEDURE IF EXISTS sp_reassignCoursesAndDeleteInstructor //
CREATE PROCEDURE sp_reassignCoursesAndDeleteInstructor(
    IN iid INT,
    IN new_iid INT)
BEGIN
  UPDATE Courses SET instructorID = new_iid WHERE instructorID = iid;
  DELETE FROM Instructors WHERE instructorID = iid;
END //


DROP PROCEDURE IF EXISTS sp_createCourse //
CREATE PROCEDURE sp_createCourse(IN cn VARCHAR(45), IN cc VARCHAR(45), IN cr INT, IN iid INT)
BEGIN
  INSERT INTO Courses (courseName, courseCode, credit, instructorID)
  VALUES (cn, cc, cr, iid);
END //

DROP PROCEDURE IF EXISTS sp_updateCourse //
CREATE PROCEDURE sp_updateCourse(IN cid INT, IN cn VARCHAR(45), IN cc VARCHAR(45), IN cr INT, IN iid INT)
BEGIN
  UPDATE Courses
     SET courseName   = COALESCE(cn, courseName),
         courseCode   = COALESCE(cc, courseCode),
         credit       = COALESCE(cr, credit),
         instructorID = COALESCE(iid, instructorID)
   WHERE courseID = cid;
END //

DROP PROCEDURE IF EXISTS sp_deleteCourse //
CREATE PROCEDURE sp_deleteCourse(IN cid INT)
BEGIN
  DELETE FROM Courses WHERE courseID = cid;
END //

DELIMITER ;
