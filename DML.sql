-- STUDENTS

-- SELECT
SELECT studentID, firstName, lastName, email, major
FROM Students;

-- INSERT
INSERT INTO Students (firstName, lastName, email, major)
VALUES (@firstName, @lastName, @studentEmail, @major);

-- UPDATE
UPDATE Students
SET email = @newEmail,
    major = @newMajor
WHERE studentID = (
      SELECT studentID FROM Students WHERE email = @studentEmail
);

-- DELETE
DELETE FROM Students
WHERE studentID = (
      SELECT studentID FROM Students WHERE email = @studentEmail
);

-- INSTRUCTORS

SELECT instructorID, firstName, lastName, email
FROM Instructors;

INSERT INTO Instructors (firstName, lastName, email)
VALUES (@firstName, @lastName, @instructorEmail);

UPDATE Instructors
SET firstName = @newFirstName,
    lastName  = @newLastName,
    email     = @newEmail
WHERE instructorID = (
      SELECT instructorID FROM Instructors WHERE email = @instructorEmail
);

DELETE FROM Instructors
WHERE instructorID = (
      SELECT instructorID FROM Instructors WHERE email = @instructorEmail
);

-- COURSES

-- SELECT with instructor name
SELECT C.courseID, C.courseName, C.courseCode, C.credit,
       CONCAT(I.firstName, ' ', I.lastName) AS instructor
FROM Courses C
JOIN Instructors I ON C.instructorID = I.instructorID;

-- INSERT (lookup instructor by email)
INSERT INTO Courses (courseName, courseCode, credit, instructorID)
VALUES (@courseName, @courseCode, @credit,
        (SELECT instructorID FROM Instructors WHERE email = @instructorEmail));

-- UPDATE
UPDATE Courses
SET courseName   = @newCourseName,
    courseCode   = @newCourseCode,
    credit       = @newCredit,
    instructorID = (SELECT instructorID FROM Instructors WHERE email = @newInstructorEmail)
WHERE courseID = (
      SELECT courseID FROM Courses WHERE courseCode = @courseCode
);

-- DELETE
DELETE FROM Courses
WHERE courseID = (
      SELECT courseID FROM Courses WHERE courseCode = @courseCode
);

-- GRADES

SELECT gradeID, gradeName, gradePoint
FROM Grades;

INSERT INTO Grades (gradeName, gradePoint)
VALUES (@gradeName, @gradePoint);

UPDATE Grades
SET gradePoint = @newGradePoint
WHERE gradeID = (
      SELECT gradeID FROM Grades WHERE gradeName = @gradeName
);

DELETE FROM Grades
WHERE gradeID = (
      SELECT gradeID FROM Grades WHERE gradeName = @gradeName
);

-- STUDENTS_COURSES

-- SELECT
SELECT enrollmentID,
       studentID,
       courseID,
       gradeID
FROM Students_Courses;

-- INSERT (fully dynamic)
INSERT INTO Students_Courses (studentID, courseID, gradeID)
VALUES (
    (SELECT studentID  FROM Students  WHERE email      = @studentEmail),
    (SELECT courseID   FROM Courses   WHERE courseCode = @courseCode),
    (SELECT gradeID    FROM Grades    WHERE gradeName  = @gradeName )
);

-- UPDATE grade
UPDATE Students_Courses
SET gradeID = (SELECT gradeID FROM Grades WHERE gradeName = @newGradeName)
WHERE enrollmentID = @enrollmentID;

-- DELETE
DELETE FROM Students_Courses
WHERE enrollmentID = @enrollmentID;
