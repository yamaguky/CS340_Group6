-- DML: CS340 Project - DML matching Stored Procedures
-- Group 6: Thomas Murray, Kyohei Yamaguchi

-- SELECT all students
SELECT studentID, firstName, lastName, email, major FROM Students;

-- INSERT a student using procedure
CALL sp_createStudent('Alice', 'Johnson', 'alice.johnson@example.com', 'Computer Science');

-- UPDATE a student's email and major
CALL sp_updateStudent(1, 'alice.new@example.com', 'Data Science');

-- DELETE a student by ID
CALL sp_deleteStudent(1);


-- SELECT all instructors
SELECT instructorID, firstName, lastName, email FROM Instructors;

-- INSERT an instructor
CALL sp_createInstructor('David', 'Miller', 'david.miller@example.com');

-- UPDATE an instructor's name or email
CALL sp_updateInstructor(1, 'Dave', NULL, 'dave.miller@example.com');

-- DELETE an instructor directly
CALL sp_deleteInstructor(1);

-- DELETE instructor and dependent courses
CALL sp_deleteInstructorWithCourses(2);

-- Reassign courses before deleting instructor
CALL sp_reassignCoursesAndDeleteInstructor(3, 1);


-- SELECT all courses with instructor name
SELECT C.courseID, C.courseName, C.courseCode, C.credit,
       CONCAT(I.firstName, ' ', I.lastName) AS instructor
FROM Courses C
JOIN Instructors I ON C.instructorID = I.instructorID;

-- INSERT a course using procedure
CALL sp_createCourse('Database Systems', 'CS340', 4, 1);

-- UPDATE a course’s information
CALL sp_updateCourse(1, 'Advanced DB Systems', NULL, NULL, NULL);

-- DELETE a course
CALL sp_deleteCourse(1);
