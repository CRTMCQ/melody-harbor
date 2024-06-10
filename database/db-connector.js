// Citation for the following code:
// Date: 5/23/2024
// Adapted from: CS340 nodejs-starter-app 
// All code below was copied from the nodejs-starter-app db-connector.js, and is
//     modified to use a particular username, password, and database.
// Source URL: https://github.com/osu-cs340-ecampus/nodejs-starter-app

// Get an instance of mysql we can use in the app
var mysql = require('mysql')

// Create a 'connection pool' using the provided credentials
var pool = mysql.createPool({
    connectionLimit : 10,
    host            : 'classmysql.engr.oregonstate.edu',
    user            : 'username',
    password        : 'password',
    database        : 'database-name'
})

// Export it for use in our applicaiton
module.exports.pool = pool;
