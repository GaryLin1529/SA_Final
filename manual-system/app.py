import os
import logging
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
from datetime import datetime

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

@app.route('/login', methods=['GET'])
def login_page():
    return render_template('login.html')

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

        if user and user[1] == password:  # Replace this with a secure password check in production
            session['user_id'] = user[0]
            session['username'] = username
            return redirect(url_for('caseview_all_manual'))
        else:
            return render_template('login.html', error="Invalid username or password"), 401
    except Exception as e:
        logger.error(f"Login error: {e}")
        return "An error occurred during login.", 500

@app.route('/caseview_all_manual')
def caseview_all_manual():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    try:
        user_id = session.get('user_id')
        cur = mysql.connection.cursor()
        ##cur.execute('SELECT violation_id, image_path, license_plate, status, remarks FROM violations ')
        cur.execute('SELECT violation_id, image_path, license_plate, status, remarks FROM violations WHERE recognition = %s',("failed",))
        ##cur.execute('SELECT violation_id, image_path, license_plate, status, remarks FROM violations ')
        violations = cur.fetchall()

        # Process image paths to remove 'manual-system'
        processed_violations = []
        for violation in violations:
            updated_path = violation[1].replace("manual-system\\", "").replace("manual-system/", "")
            processed_violation = list(violation)  # Convert tuple to list if necessary
            processed_violation[1] = updated_path  # Update the image_path
            processed_violations.append(processed_violation)

        cur.execute('SELECT username FROM userlogin WHERE id = %s', [user_id])
        user = cur.fetchone()
        cur.close()

        return render_template('caseview_all_manual.html', violations=processed_violations, processing_personnel=user[0])
    except Exception as e:
        logger.error(f"Caseview error: {e}")
        return "An error occurred while fetching cases.", 500


@app.route('/caseview_all')
def caseview_all():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    try:
        user_id = session.get('user_id')
        cur = mysql.connection.cursor()
        cur.execute('SELECT violation_id, image_path, license_plate, status, remarks FROM violations WHERE TRIM(recognition) = %s', ("success",))
        violations = cur.fetchall()

        # Process the violations to remove 'manual-system' from image_path
        processed_violations = []
        for violation in violations:
            updated_path = violation[1].replace("manual-system\\", "").replace("manual-system/", "")
            processed_violation = list(violation)  # Convert tuple to list if necessary
            processed_violation[1] = updated_path  # Update the image_path
            processed_violations.append(processed_violation)

        cur.execute('SELECT username FROM userlogin WHERE id = %s', [user_id])
        user = cur.fetchone()
        cur.close()

        return render_template('caseview_all.html', violations=processed_violations, processing_personnel=user[0])
    except Exception as e:
        logger.error(f"Caseview_all error: {e}")
        return "An error occurred while fetching all cases.", 500

# Route to render caseview_processed.html
@app.route('/caseview_processed')
def caseview_processed():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    try:
        user_id = session.get('user_id')
        cur = mysql.connection.cursor()
        cur.execute('SELECT violation_id, image_path, license_plate, status, remarks FROM human.violations WHERE TRIM(status) = %s', ("processed",))
        
        violations = cur.fetchall()
        logger.info(f"Fetched violations: {violations}")  # Log the fetched violations
        
        # Process image paths and update violations
        processed_violations = []
        for violation in violations:
            updated_path = violation[1].replace("manual-system\\", "").replace("manual-system/", "")
            processed_violation = list(violation)  # Convert tuple to list
            processed_violation[1] = updated_path  # Update the image_path
            processed_violations.append(processed_violation)
        
        cur.execute('SELECT username FROM userlogin WHERE id = %s', [user_id])
        user = cur.fetchone()
        cur.close()

        if not processed_violations:
            logger.info("No processed violations found.")  # Log if no violations are found
            return render_template('caseview_processed.html', alert_message="No processed cases found.", violations=[], processing_personnel=user[0])

        return render_template('caseview_processed.html', violations=processed_violations, processing_personnel=user[0])
    except Exception as e:
        logger.error(f"Caseview_processed error: {e}")
        return "An error occurred while fetching processed cases.", 500

# Route to render caseview_pending.html
@app.route('/caseview_pending')
def caseview_pending():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    try:
        user_id = session.get('user_id')
        cur = mysql.connection.cursor()
        cur.execute('SELECT violation_id, image_path, license_plate, status, remarks FROM human.violations WHERE TRIM(status) = %s', ("pending",))

        violations = cur.fetchall()
        logger.info(f"Fetched violations: {violations}")  # Log the fetched violations

        # Process image paths and update violations
        processed_violations = []
        for violation in violations:
            updated_path = violation[1].replace("manual-system\\", "").replace("manual-system/", "")
            processed_violation = list(violation)  # Convert tuple to list
            processed_violation[1] = updated_path  # Update the image_path
            processed_violations.append(processed_violation)

        cur.execute('SELECT username FROM userlogin WHERE id = %s', [user_id])
        user = cur.fetchone()
        cur.close()

        if not processed_violations:
            logger.info("No pending violations found.")  # Log if no violations are found
            return render_template('caseview_pending.html', alert_message="No pending cases found.", violations=[], processing_personnel=user[0])

        return render_template('caseview_pending.html', violations=processed_violations, processing_personnel=user[0])
    except Exception as e:
        logger.error(f"Caseview_pending error: {e}")
        return "An error occurred while fetching pending cases.", 500


@app.route('/casecheck', methods=['GET', 'POST'])
def casecheck():
    if request.method == 'POST':
        try:
            # Retrieve form data
            manual_recognize_plate = request.form['manual_recognize_plate']
            violation_id = request.form.get('violation_id')

            if not violation_id:
                logger.error("Violation ID is missing.")
                return "Violation ID is missing.", 400

            if not manual_recognize_plate:
                logger.error("Manual recognized plate is missing.")
                return "Manual recognized plate is missing.", 400

            user_id = session.get('user_id')

            if not user_id:
                logger.error("User ID is missing from the session.")
                return "User ID is missing.", 400

            # Get the current timestamp for manual recognition
            manual_recognize_timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            # Open the cursor to interact with the database
            cur = mysql.connection.cursor()

            # Insert or update manual recognition table (manual_recognize_plate)
            cur.execute(""" 
                INSERT INTO manual_recognition (manual_recognition_id, id, manual_recognize_plate, manual_recognize_timestamp) 
                VALUES (%s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE manual_recognize_plate = VALUES(manual_recognize_plate)
            """, (violation_id, user_id, manual_recognize_plate, manual_recognize_timestamp))

            # Update the violations table with the processed status and recognized license plate
            cur.execute(""" 
                UPDATE violations 
                SET status = %s, license_plate = %s 
                WHERE violation_id = %s
            """, ("processed", manual_recognize_plate, violation_id))

            mysql.connection.commit()  # Commit the transaction
            cur.close()

            return redirect(url_for('caseview_all_manual'))

        except Exception as e:
            logger.error(f"Casecheck error: {e}")
            return f"An error occurred during case checking: {str(e)}", 500

    else:
        try:
            violation_id = request.args.get('violation_id')

            if violation_id:
                cur = mysql.connection.cursor()
                cur.execute('SELECT violation_id, image_path, camera_id, status, remarks FROM violations WHERE violation_id = %s', [violation_id])
                violation = cur.fetchone()

                if violation:
                    # Process the violation to remove 'manual-system' from image_path
                    updated_path = violation[1].replace("manual-system\\", "/").replace("manual-system/", "/")
                    processed_violation = list(violation)  # Convert tuple to list if necessary
                    processed_violation[1] = updated_path  # Update the image_path
                    
                    cur.close()

                    return render_template('casecheck.html', violation=processed_violation)
                else:
                    cur.close()
                    return f"No violation found with ID {violation_id}", 404
            else:
                return "Violation ID is missing.", 400

        except Exception as e:
            logger.error(f"Casecheck GET error: {e}")
            return "An error occurred during case checking.", 500

# Route for ticket generation
@app.route('/ticket/<int:violation_id>')
def ticket(violation_id):
    try:
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
            # Process the violation to remove 'manual-system' from image_path
            updated_path = violation[11].replace("manual-system\\", "/").replace("manual-system/", "/")

            processed_violation = list(violation)  # Convert tuple to list if necessary
            processed_violation[11] = updated_path  # Update the image_path

            return render_template('ticket.html', violation=processed_violation)
        else:
            return f"No violation found with ID {violation_id}", 404
    except Exception as e:
        logger.error(f"Ticket generation error: {e}")
        return "An error occurred during ticket generation.", 500

@app.route('/delete_case', methods=['POST'])
def delete_case():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    try:
        violation_id = request.form.get('violation_id')

        if not violation_id:
            logger.error("Violation ID is missing for deletion.")
            return "Violation ID is missing.", 400

        cur = mysql.connection.cursor()

        # Delete the violation from the database
        cur.execute('DELETE FROM violations WHERE violation_id = %s', [violation_id])
        mysql.connection.commit()  # Commit the transaction
        cur.close()

        logger.info(f"Violation with ID {violation_id} deleted successfully.")
        return redirect(url_for('caseview_all_manual'))
    except Exception as e:
        logger.error(f"Delete case error: {e}")
        return f"An error occurred during deletion: {str(e)}", 500

if __name__ == '__main__':
    app.run(debug=True)
