-- -- Group 6: Thomas Murray, Kyohei Yamaguchi


-- ======================================
-- STUDENTS
-- ======================================

-- SELECT all students
SELECT studentID, firstName, lastName, email, major FROM Students;

-- INSERT a new student
INSERT INTO Students (firstName, lastName, email, major)
VALUES (@firstNameInput, @lastNameInput, @emailInput, @majorInput);

-- UPDATE student's email and/or major
UPDATE Students
SET email = @emailInput, major = @majorInput
WHERE studentID = @studentID;

-- DELETE a student
DELETE FROM Students
WHERE studentID = @studentID;

-- ======================================
-- INSTRUCTORS
-- ======================================

-- SELECT all instructors
SELECT instructorID, firstName, lastName, email FROM Instructors;

-- INSERT a new instructor
INSERT INTO Instructors (firstName, lastName, email)
VALUES (@firstNameInput, @lastNameInput, @emailInput);

-- UPDATE an instructor
UPDATE Instructors
SET firstName = @firstNameInput, lastName = @lastNameInput, email = @emailInput
WHERE instructorID = @instructorID;

-- DELETE an instructor
DELETE FROM Instructors
WHERE instructorID = @instructorID;

-- ======================================
-- COURSES
-- ======================================

-- SELECT all courses with instructor names
SELECT C.courseID, C.courseName, C.courseCode, C.credit,
       CONCAT(I.firstName,' ',I.lastName) AS instructor
FROM Courses C
JOIN Instructors I ON C.instructorID = I.instructorID;

-- INSERT a new course
INSERT INTO Courses (courseName, courseCode, credit, instructorID)
VALUES (@courseNameInput, @courseCodeInput, @creditInput, @instructorID);

-- UPDATE a course
UPDATE Courses
SET courseName = @courseNameInput,
    courseCode = @courseCodeInput,
    credit = @creditInput,
    instructorID = @instructorID
WHERE courseID = @courseID;

-- DELETE a course
DELETE FROM Courses
WHERE courseID = @courseID;

-- ======================================
-- GRADES
-- ======================================

-- SELECT all grades
SELECT gradeID, gradeName, gradePoint FROM Grades;

-- INSERT a new grade
INSERT INTO Grades (gradeName, gradePoint)
VALUES (@gradeNameInput, @gradePointInput);

-- UPDATE a grade
UPDATE Grades
SET gradeName = @gradeNameInput, gradePoint = @gradePointInput
WHERE gradeID = @gradeID;

-- DELETE a grade
DELETE FROM Grades
WHERE gradeID = @gradeID;

-- ======================================
-- STUDENTS_COURSES 
-- ======================================

-- SELECT all student-course enrollments
SELECT enrollmentID, studentID, courseID, gradeID FROM Students_Courses;

-- INSERT a student-course enrollment
INSERT INTO Students_Courses (studentID, courseID, gradeID)
VALUES (@studentID, @courseID, @gradeID);

-- UPDATE an enrollment's grade
UPDATE Students_Courses
SET gradeID = @gradeID
WHERE enrollmentID = @enrollmentID;

-- DELETE an enrollment
DELETE FROM Students_Courses
WHERE enrollmentID = @enrollmentID;
