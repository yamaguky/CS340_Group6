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
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
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
        // In query1, we use a JOIN clause to display the names of the homeworlds
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
        // In query1, we use a JOIN clause to display the names of the homeworlds
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
            `SELECT SC.enrollmentID, SC.studentID, SC.courseID, SC.gradeID,
              FROM Students_Courses SC
              JOIN Students S ON S.studentID = SC.studentID`
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


// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
        PORT +
        '; press Ctrl-C to terminate.'
    );
});