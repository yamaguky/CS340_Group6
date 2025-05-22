// Citation for the following:
// Date: 05/06/2025
// Based on:
// Source: Exploration - Web Application Technology
// Authors: Professor Michael Curry
// Section: Web App Design UI
// Subsection: Build app.js

// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = process.env.PORT || 2529;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs',  engine({
    extname: '.hbs',
    helpers: {
      eq: (a, b) => a === b,
    },
  })
);
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/Students', async function (req, res) {
    try {
        // Create and execute our queries   
        const query1 = `SELECT Students.studentID, Students.firstName, Students.lastName, Students.email, Students.major FROM Students`;
        const [students] = await db.query(query1);

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('students', { students });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Instructors', async function (req, res) {
    try {
        // Create and execute our queries   
        const [instructors] = await db.query(
            'SELECT instructorID, firstName, lastName, email FROM Instructors'
          );
          res.render('instructors', { instructors });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Courses', async function (req, res) {
    try {
        // Create and execute our queries   
        // In query1, we use a JOIN clause to display the names of the homeworlds
        const [courses] = await db.query(`
            SELECT C.courseID, C.courseName, C.courseCode, C.credit,
                   CONCAT(I.firstName,' ',I.lastName) AS instructor
              FROM Courses C
              JOIN Instructors I ON I.instructorID = C.instructorID
          `);
          const [instructors] = await db.query(`
            SELECT instructorID, firstName, lastName FROM Instructors
          `);
          res.render('courses', { courses, instructors });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Grades', async function (req, res) {
    try {
        // Create and execute our queries   
        const [grades] = await db.query(
            'SELECT gradeID, gradeName, gradePoint FROM Grades'
          );
          res.render('grades', { grades });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


app.get('/Students_Courses', async function (req, res) {
    try {
        // Create and execute our queries   
        const [students_courses] = await db.query(
            'SELECT enrollmentID, studentID, courseID, gradeID FROM Students_Courses'
        );
        res.render('students_courses', { students_courses });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// 
// STUDENTS – CREATE
// 
app.post('/Students', async (req, res) => {
  const { firstName, lastName, email, major } = req.body;
  try {
    const sql = `
      INSERT INTO Students (firstName, lastName, email, major)
      VALUES (?, ?, ?, ?);
    `;
    await db.query(sql, [firstName, lastName, email, major || null]);
    res.redirect('/Students');
  } catch (err) {
    console.error('Create student failed:', err);
    res.status(500).send('Insert failed');
  }
});


// 
// STUDENTS – UPDATE
// 
app.post('/Students/update', async (req, res) => {
  console.log("UPDATE req.body:", req.body);
  const { studentID, email, major } = req.body;
  try {
    const sql = `
      UPDATE Students
         SET email = COALESCE(?, email),
             major = COALESCE(?, major)
       WHERE studentID = ?;
    `;
    await db.query(sql, [email || null, major || null, studentID]);
    res.redirect('/Students');
  } catch (err) {
    console.error('Update student failed:', err);
    res.status(500).send('Update failed');
  }
});




// 
// STUDENTS – DELETE
// 
app.post('/Students/delete', async (req, res) => {
  const { studentID } = req.body;
  try {
    const sql = `DELETE FROM Students WHERE studentID = ?;`;
    await db.query(sql, [studentID]);
    res.redirect('/Students');
  } catch (err) {
    console.error('Delete student failed:', err);
    res.status(500).send('Delete failed');
  }
});


app.get('/reset', (req, res) => {
  res.render('reset');
});

app.post('/reset-db', async (req, res) => {
  try {
    await db.query('CALL sp_reset_projectDB();');
    res.redirect('/');
  } catch (err) {
    console.error('Database reset failed:', err);
    res.status(500).send('Reset failed.');
  }
});


// INSTRUCTORS – CREATE
app.post('/Instructors', async (req, res) => {
  const { firstName, lastName, email } = req.body;
  try {
    const sql = `
      INSERT INTO Instructors (firstName, lastName, email)
      VALUES (?, ?, ?);
    `;
    await db.query(sql, [firstName, lastName, email]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error('Create instructor failed:', err);
    res.status(500).send('Insert failed');
  }
});

// INSTRUCTORS – UPDATE
app.post('/Instructors/update', async (req, res) => {
  const { instructorID, firstName, lastName, email } = req.body;
  try {
    const sql = `
      UPDATE Instructors
         SET firstName = COALESCE(?, firstName),
             lastName  = COALESCE(?, lastName),
             email     = COALESCE(?, email)
       WHERE instructorID = ?;
    `;
    await db.query(sql, [firstName || null, lastName || null, email || null, instructorID]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error('Update instructor failed:', err);
    res.status(500).send('Update failed');
  }
});

// INSTRUCTORS – DELETE
app.post('/Instructors/delete', async (req, res) => {
  const { instructorID } = req.body;
  try {
    const sql = `DELETE FROM Instructors WHERE instructorID = ?;`;
    await db.query(sql, [instructorID]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error('Delete instructor failed:', err);
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

    if (assignedCourses.length > 0) {
      // yes → confirm
      const [instructors] = await db.query('SELECT * FROM Instructors');
      res.render('instructor_confirm_delete', { instructorID, assignedCourses, instructors });
    } else {
      // no → del
      await db.query('DELETE FROM Instructors WHERE instructorID = ?', [instructorID]);
      res.redirect('/Instructors');
    }
  } catch (err) {
    console.error('Delete check failed:', err);
    res.status(500).send('Delete check failed');
  }
});

app.post('/Instructors/delete-with-courses', async (req, res) => {
  const { instructorID } = req.body;
  try {
    await db.query('DELETE FROM Courses WHERE instructorID = ?', [instructorID]);
    await db.query('DELETE FROM Instructors WHERE instructorID = ?', [instructorID]);
    res.redirect('/Instructors');
  } catch (err) {
    console.error('Cascade delete failed:', err);
    res.status(500).send('Cascade delete failed');
  }
});


app.post('/Instructors/reassign-courses', async (req, res) => {
  const { instructorID, newInstructorID } = req.body;
  try {
    await db.query(
      'UPDATE Courses SET instructorID = ? WHERE instructorID = ?',
      [newInstructorID, instructorID]
    );

    await db.query('DELETE FROM Instructors WHERE instructorID = ?', [instructorID]);

    res.redirect('/Instructors');
  } catch (err) {
    console.error('Reassign failed:', err);
    res.status(500).send('Reassign failed');
  }
});



// COURSES – CREATE
app.post('/Courses', async (req, res) => {
  const { courseName, courseCode, credit, instructorID } = req.body;
  try {
    const sql = `
      INSERT INTO Courses (courseName, courseCode, credit, instructorID)
      VALUES (?, ?, ?, ?);
    `;
    await db.query(sql, [courseName, courseCode, credit, instructorID]);
    res.redirect('/Courses');
  } catch (err) {
    console.error('Create course failed:', err);
    res.status(500).send('Insert failed');
  }
});

// COURSES – UPDATE
app.post('/Courses/update', async (req, res) => {
  const { courseID, courseName, courseCode, credit, instructorID } = req.body;
  try {
    const sql = `
      UPDATE Courses
         SET courseName   = COALESCE(?, courseName),
             courseCode   = COALESCE(?, courseCode),
             credit       = COALESCE(?, credit),
             instructorID = COALESCE(?, instructorID)
       WHERE courseID = ?;
    `;
    await db.query(sql, [
      courseName || null,
      courseCode || null,
      credit || null,
      instructorID || null,
      courseID,
    ]);
    res.redirect('/Courses');
  } catch (err) {
    console.error('Update course failed:', err);
    res.status(500).send('Update failed');
  }
});

// COURSES – DELETE
app.post('/Courses/delete', async (req, res) => {
  const { courseID } = req.body;
  try {
    const sql = `DELETE FROM Courses WHERE courseID = ?;`;
    await db.query(sql, [courseID]);
    res.redirect('/Courses');
  } catch (err) {
    console.error('Delete course failed:', err);
    res.status(500).send('Delete failed');
  }
});



// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
        PORT +
        '; press Ctrl-C to terminate.'
    );
});
