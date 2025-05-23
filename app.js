// Citation for the following:
// Date: 05/06/2025
// Based on:
// Source: Exploration - Web Application Technology
// Authors: Professor Michael Curry
// Section: Web App Design UI
// Subsection: Build app.js

const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 2529;                         
const db = require('./database/db-connector');

const { engine } = require('express-handlebars');
app.engine('.hbs', engine({ extname: '.hbs', helpers: { eq: (a, b) => a === b } }));
app.set('view engine', '.hbs');


app.get('/', (_, res) => res.render('home'));

app.get('/Students', async (_, res) => {
  try {
    const [students] = await db.query('SELECT * FROM Students');
    res.render('students', { students });
  } catch (err) {
    console.error(err);
    res.status(500).send('Query error');
  }
});

app.get('/Instructors', async (_, res) => {
  try {
    const [instructors] = await db.query('SELECT * FROM Instructors');
    res.render('instructors', { instructors });
  } catch (err) {
    console.error(err);
    res.status(500).send('Query error');
  }
});

app.get('/Courses', async (_, res) => {
  try {
    const [courses] = await db.query(`
      SELECT C.courseID, C.courseName, C.courseCode, C.credit,
             CONCAT(I.firstName,' ',I.lastName) AS instructor
        FROM Courses C
        JOIN Instructors I ON I.instructorID = C.instructorID
    `);
    const [instructors] = await db.query('SELECT * FROM Instructors');
    res.render('courses', { courses, instructors });
  } catch (err) {
    console.error(err);
    res.status(500).send('Query error');
  }
});

app.get('/Grades', async (_, res) => {
  try {
    const [grades] = await db.query('SELECT * FROM Grades');
    res.render('grades', { grades });
  } catch (err) {
    console.error(err);
    res.status(500).send('Query error');
  }
});

app.get('/Students_Courses', async (_, res) => {
  try {
    const [students_courses] = await db.query('SELECT * FROM Students_Courses');
    res.render('students_courses', { students_courses });
  } catch (err) {
    console.error(err);
    res.status(500).send('Query error');
  }
});


app.post('/Students', async (req, res) => {
  const { firstName, lastName, email, major } = req.body;
  try {
    await db.query('CALL sp_createStudent(?, ?, ?, ?)', [
      firstName,
      lastName,
      email,
      major || null,
    ]);
    res.redirect('/Students');
  } catch (err) {
    console.error(err);
    res.status(500).send('Insert failed');
  }
});

app.post('/Students/update', async (req, res) => {
  const { studentID, email, major } = req.body;
  try {
    await db.query('CALL sp_updateStudent(?, ?, ?)', [
      studentID,
      email || null,
      major || null,
    ]);
    res.redirect('/Students');
  } catch (err) {
    console.error(err);
    res.status(500).send('Update failed');
  }
});

app.post('/Students/delete', async (req, res) => {
  const { studentID } = req.body;
  try {
    await db.query('CALL sp_deleteStudent(?)', [studentID]);
    res.redirect('/Students');
  } catch (err) {
    console.error(err);
    res.status(500).send('Delete failed');
  }
});


app.post('/Instructors', async (req, res) => {
  const { firstName, lastName, email } = req.body;
  try {
    await db.query('CALL sp_createInstructor(?, ?, ?)', [
      firstName,
      lastName,
      email,
    ]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error(err);
    res.status(500).send('Insert failed');
  }
});

app.post('/Instructors/update', async (req, res) => {
  const { instructorID, firstName, lastName, email } = req.body;
  try {
    await db.query('CALL sp_updateInstructor(?, ?, ?, ?)', [
      instructorID,
      firstName || null,
      lastName || null,
      email || null,
    ]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error(err);
    res.status(500).send('Update failed');
  }
});

app.post('/Instructors/delete', async (req, res) => {
  const { instructorID } = req.body;
  try {
    await db.query('CALL sp_deleteInstructor(?)', [instructorID]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error(err);
    res.status(500).send('Delete failed');
  }
});

app.post('/Instructors/delete-check', async (req, res) => {
  const { instructorID } = req.body;
  try {
    const [assignedCourses] = await db.query(
      'SELECT * FROM Courses WHERE instructorID = ?',
      [instructorID]
    );

    if (assignedCourses.length) {
      const [instructors] = await db.query('SELECT * FROM Instructors');
      res.render('instructor_confirm_delete', {
        instructorID,
        assignedCourses,
        instructors,
      });
    } else {
      await db.query('CALL sp_deleteInstructor(?)', [instructorID]);
      res.redirect('/Instructors');
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Delete check failed');
  }
});

app.post('/Instructors/delete-with-courses', async (req, res) => {
  try {
    await db.query('CALL sp_deleteInstructorWithCourses(?)', [
      req.body.instructorID,
    ]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error(err);
    res.status(500).send('Cascade delete failed');
  }
});

app.post('/Instructors/reassign-courses', async (req, res) => {
  const { instructorID, newInstructorID } = req.body;
  try {
    await db.query('CALL sp_reassignCoursesAndDeleteInstructor(?, ?)', [
      instructorID,
      newInstructorID,
    ]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error(err);
    res.status(500).send('Reassign failed');
  }
});


app.post('/Courses', async (req, res) => {
  const { courseName, courseCode, credit, instructorID } = req.body;
  try {
    await db.query('CALL sp_createCourse(?, ?, ?, ?)', [
      courseName,
      courseCode,
      credit,
      instructorID,
    ]);
    res.redirect('/Courses');
  } catch (err) {
    console.error(err);
    res.status(500).send('Insert failed');
  }
});

app.post('/Courses/update', async (req, res) => {
  const { courseID, courseName, courseCode, credit, instructorID } = req.body;
  try {
    await db.query('CALL sp_updateCourse(?, ?, ?, ?, ?)', [
      courseID,
      courseName || null,
      courseCode || null,
      credit || null,
      instructorID || null,
    ]);
    res.redirect('/Courses');
  } catch (err) {
    console.error(err);
    res.status(500).send('Update failed');
  }
});

app.post('/Courses/delete', async (req, res) => {
  try {
    await db.query('CALL sp_deleteCourse(?)', [req.body.courseID]);
    res.redirect('/Courses');
  } catch (err) {
    console.error(err);
    res.status(500).send('Delete failed');
  }
});


app.get('/reset', (_, res) => res.render('reset'));

app.post('/reset-db', async (_, res) => {
  try {
    await db.query('CALL sp_reset_projectDB()');
    res.redirect('/');
  } catch (err) {
    console.error(err);
    res.status(500).send('Reset failed.');
  }
});

app.listen(PORT, () =>
  console.log(`Express started on http://localhost:${PORT}`)
);
