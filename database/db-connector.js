// Citation for the following:
// Date: 05/06/2025
// Based on:
// Source: Exploration - Web Application Technology
// Authors: Professor Michael Curry
// Section: Web App Design UI
// Subsection: Build db-connector.js

// Get an instance of mysql we can use in the app
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : 'classmysql.engr.oregonstate.edu',
    user              : '',
    password          : '',
    database          : ''
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;