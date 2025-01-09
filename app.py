import os
import logging
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL

app = Flask(__name__)

# Configure MySQL connection settings
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'  # Your MySQL username
app.config['MYSQL_PASSWORD'] = '1234'  # Your MySQL password
app.config['MYSQL_DB'] = 'human'  # The name of your database
app.secret_key = 'your_secret_key'  # Secret key for session management

# Initialize the MySQL extension
mysql = MySQL(app)

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Check the connection to the database before processing the first request
@app.before_request
def check_database_connection():
    try:
        cur = mysql.connection.cursor()
        cur.execute('SELECT 1')  # A simple query to test the connection
        cur.close()
        logger.info("Connected to the MySQL database successfully!")
    except Exception as e:
        logger.error(f"Error connecting to the database: {e}")

# Route to render index.html as the main page (login page)
@app.route('/')
def index():
    return render_template('index.html')

# Route to handle the login logic
@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']

    try:
        cur = mysql.connection.cursor()
        cur.execute('SELECT id, password_hash FROM userlogin WHERE username = %s', [username])
        user = cur.fetchone()
        cur.close()

        if user and user[1] == password:
            session['user_id'] = user[0]
            session['username'] = username
            return redirect(url_for('caseview'))
        else:
            return "Invalid username or password", 401
    except Exception as e:
        logger.error(f"Login error: {e}")
        return "An error occurred", 500

# Route to render caseview.html (after login)
@app.route('/caseview')
def caseview():
    if 'user_id' not in session:
        return redirect(url_for('index'))

    try:
        user_id = session.get('user_id')
        cur = mysql.connection.cursor()
        cur.execute('SELECT violation_id, image_path, camera_id, status, remarks FROM violations')
        violations = cur.fetchall()
        cur.execute('SELECT username FROM userlogin WHERE id = %s', [user_id])
        user = cur.fetchone()
        cur.close()
        return render_template('caseview.html', violations=violations, processing_personnel=user[0])
    except Exception as e:
        logger.error(f"Caseview error: {e}")
        return "An error occurred", 500

@app.route('/casecheck', methods=['GET', 'POST'])
def casecheck():
    if request.method == 'POST':
        try:
            # Extract form data
            manual_recognize_plate = request.form['manual_recognize_plate']
            violation_id = request.form.get('violation_id')

            # Validate that the required fields are provided
            if not manual_recognize_plate or not violation_id:
                logger.error("Manual recognition plate or violation ID is missing in the request.")
                return "Manual recognition plate and violation ID are required.", 400

            # Get the user_id from session
            user_id = session.get('user_id')
            if not user_id:
                logger.error("User not logged in.")
                return redirect(url_for('index'))  # Redirect if user is not logged in

            # Start a transaction to insert and update in the database
            cur = mysql.connection.cursor()

            # Insert into the manual_recognition table
            cur.execute('INSERT INTO manual_recognition (id, manual_recognize_plate) VALUES (%s, %s)', 
                        (user_id, manual_recognize_plate))

            # Update the violation status to 'processed'
            cur.execute('UPDATE violations SET status = %s WHERE violation_id = %s', 
                        ('processed', violation_id))

            # Commit the transaction to save changes
            mysql.connection.commit()

            # Close the cursor
            cur.close()

            # Redirect to caseview page after successful update
            return redirect(url_for('caseview'))

        except Exception as e:
            # Rollback in case of an error
            mysql.connection.rollback()

            # Log the error with more details
            logger.error(f"Error during casecheck POST operation: {str(e)}")

            # Return a generic error message
            return "An error occurred while processing your request.", 500

    else:
        try:
            # Handle the GET request to display the violation details
            violation_id = request.args.get('violation_id')

            # Validate the presence of violation_id in the URL
            if not violation_id:
                logger.error("Violation ID is missing in the URL.")
                return "Violation ID is missing.", 400

            # Fetch violation details from the database
            cur = mysql.connection.cursor()
            cur.execute('SELECT violation_id, image_path, camera_id, status, remarks FROM violations WHERE violation_id = %s', [violation_id])
            violation = cur.fetchone()  # Fetch the violation based on violation_id
            cur.close()

            if violation:
                return render_template('casecheck.html', violation=violation)
            else:
                # Log if no violation is found for the given ID
                logger.error(f"No violation found with ID {violation_id}")
                return f"No violation found with ID {violation_id}", 404

        except Exception as e:
            # Log error during GET operation
            logger.error(f"Error during casecheck GET operation: {str(e)}")
            return "An error occurred while processing your request.", 500

# Route for ticket generation
@app.route('/ticket/<int:violation_id>')
def ticket(violation_id):
    try:
        # Fetch the violation details from the database using violation_id
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT 
                violation_id, 
                license_plate, 
                driver_name, 
                gender, 
                driver_birth_date, 
                violation_time, 
                violation_location, 
                actual_speed, 
                speed_limit, 
                fine_amount, 
                violation_description, 
                image_path 
            FROM violations 
            WHERE violation_id = %s
        """, (violation_id,))
        violation = cur.fetchone()
        cur.close()

        if violation:
            return render_template('ticket.html', violation=violation)
        else:
            return "No violation found with ID {violation_id}", 404
    except Exception as e:
        logger.error(f"Ticket generation error: {e}")
        return "An error occurred", 500

if __name__ == '__main__':
    app.run(debug=True)
