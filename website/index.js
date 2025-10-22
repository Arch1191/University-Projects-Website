const express = require('express');
const ejs = require('ejs');
const util = require('util');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const { lutimes } = require('fs/promises');


/**
 * The following constants with your MySQL connection properties
 * You should only need to change the password
 */


//For the terminal /vol/teaching/CSEE/com1025
const PORT = 8001;
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_PASSWORD = 'fWEaHZTnRz';
const DB_NAME = 'coursework';
const DB_PORT = 3306;

/**
 * DO NOT CHANGE ANYTHING BELOW THIS LINE UP TO THE NEXT COMMENT
 */
var connection = mysql.createConnection({
	host: DB_HOST,
	user: DB_USER,
	password: DB_PASSWORD,
	database: DB_NAME,
	port: DB_PORT
});

connection.query = util.promisify(connection.query).bind(connection);

connection.connect(function (err) {
	if (err) {
		console.error('error connecting: ' + err.stack);
		console.log('Please make sure you have updated the password in the index.js file. Also, ensure you have run db_setup.sql to create the database and tables.');
		return;
	}
	console.log('Connected to the Database');
});


const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));

/**
 * YOU CAN CHANGE THE CODE BELOW THIS LINE
 */

// Add your code here

// Displays the main dashboard with statistics about courses.
app.get('/', async (req, res) => {
	const courseCount = await connection.query('SELECT COUNT(*) as count FROM Course');
	const studentCount = await connection.query('SELECT SUM(Crs_Enrollment) as sum FROM Course');
	const averageEnrollment = await connection.query('SELECT AVG(Crs_Enrollment) as avg FROM Course');
	const highestEnrollment = await connection.query('SELECT Crs_Title FROM Course ORDER BY Crs_Enrollment DESC LIMIT 1');
	const lowestEnrollment = await connection.query('SELECT Crs_Title FROM Course ORDER BY Crs_Enrollment ASC LIMIT 1');
	res.render('index', {
		activePage: '/',
		courseCount: courseCount[0].count,
		studentCount: studentCount[0].sum,
		averageEnrollment: averageEnrollment[0].avg,
		highestEnrollment: highestEnrollment[0].Crs_Title,
		lowestEnrollment: lowestEnrollment[0].Crs_Title
	});
});

// Lists all courses available in the database.
app.get('/courses', async (req, res) => {
	const courses = await connection.query('SELECT * FROM Course');
	res.render('courses', {
		activePage: '/courses',
		courses: courses
	});
});

// Renders the edit form for a specific course identified by Crs_Code.
app.get('/edit-course/:id', async (req, res) => {
	const courseDetails = await connection.query('SELECT * FROM Course WHERE Crs_Code = ?', [req.params.id]);
	res.render('edit', { 
		activePage: '/courses',
		courseDetails: courseDetails[0],
		message: ''
	});
});

// Displays the form to create a new course.
app.get('/create-course', async (req, res) => {
	res.render('create', {
		activePage: '/create-course',
		message: ''
	});
});

// Handles the submission of the new course form and adds a course to the database.
app.post('/edit-course/:id', async (req, res) => {
	const {Crs_Title, Crs_Enrollment} = req.body;
	const courseDetails = await connection.query('SELECT * FROM Course WHERE Crs_Code = ?', [req.params.id]);
	let message = "";

	if (!Crs_Title || !Crs_Enrollment) {
		message = 'All fields are required';
		res.render('edit', {
			activePage: '/courses',
			courseDetails: courseDetails[0],
			message: message
		});
	}

	try {
		await connection.query('UPDATE Course SET Crs_Title = ?, Crs_Enrollment = ? WHERE Crs_Code = ?', [req.body.Crs_Title, req.body.Crs_Enrollment, req.params.id]);
		console.log('Course Updated Successfully');
		message = "Course Updated";
		const updatedDetails = await connection.query('SELECT * FROM Course WHERE Crs_Code = ?', [req.params.id]);
		res.render('edit', {
			activePage: '/courses',
			courseDetails: updatedDetails[0],
			message: message	
		});
		
	} catch (error) {
		console.log(('Error Updating Course:', error));
		message = "Course Failed To Update";
		res.render('edit', {
			activePage: '/courses',
			courseDetails: updatedDetails[0],
			message: message	
		});
	}
});

// Processes the form submission for updating an existing course.
app.post('/create-course', async (req, res) => {
	const {Crs_Code, Crs_Title, Crs_Enrollment} = req.body;
	let message = "";

	if (!Crs_Code || !Crs_Title || !Crs_Enrollment) {
		message = 'All fields are required';
		res.render('create', {
			activePage: '/create',
			message: message
		});
	}
	
	const courseIDs = await connection.query('SELECT Crs_Code FROM Course');
	if (courseIDs.includes(Crs_Code)) {
		message = "Course Code must be unique";
		res.render('create', {
			activePage: '/create',
			message: message	
		});
	}

	try {
		await connection.query('INSERT INTO Course VALUES (?, ?, ?)', [req.body.Crs_Code, req.body.Crs_Title, req.body.Crs_Enrollment]);
		console.log('Course Created Successfully');
		message = "Course Created";
		res.render('create', {
			activePage: '/create',
			message: message	
		});
	} catch (error) {
		console.log(('Error Creating Course:', error));
		message = "Course Failed To Create";
		res.render('create', {
			activePage: '/create',
			message: message	
		});
	}
});

/**
 * DON'T CHANGE ANYTHING BELOW THIS LINE
 */

app.listen(PORT, () => {

	console.log(`Server is running on port http://localhost:${PORT}`);

});



exports.app = app;
