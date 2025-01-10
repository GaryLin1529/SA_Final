from roboflow import Roboflow
import easyocr
from PIL import Image
import numpy as np
import os
import mysql.connector
from datetime import datetime

# Initialize Roboflow
rf = Roboflow(api_key="A7ajOaEV8VqhVLmshxxj")
project = rf.workspace("roboflow-universe-projects").project("license-plate-recognition-rxg4e")
version = project.version("3")
model = version.model

# Initialize easyOCR with better parameters
reader = easyocr.Reader(['en'])

# Assuming this script is in the root of your project
images_dir = os.path.join("manual-system", "static", "images")

# Database Connection
def connect_to_db():
    return mysql.connector.connect(
        host="localhost",        # Update with your DB host
        user="root",             # Update with your DB username
        password="1234",         # Update with your DB password
        database="human"         # Update with your DB name
    )

# Insert data into violations table
def insert_violation(cursor, data):
    query = """
    INSERT INTO ai_results (
       image_path, license_plate, recognition
    ) VALUES (
        %s, %s, %s
    )
    """
    cursor.execute(query, data)

# Verify the directory exists
if not os.path.exists(images_dir):
    print(f"Directory not found: {images_dir}")
    exit()

# Process each image
for filename in os.listdir(images_dir):
    if filename.lower().endswith(('.png', '.jpg', '.jpeg')):

        image_path = os.path.join(images_dir, filename)
        try:
            image = Image.open(image_path)
            prediction = model.predict(image_path, confidence=40, overlap=30).json()

            license_plate = None
            recognition_status = "failed"  # Default to failed if no plate is detected
            license_plate_count = 0  # Counter to track the number of plates detected

            # If prediction contains any plates, set recognition status to success
            for pred in prediction['predictions']:
                # Expand crop area by 15%
                x, y, w, h = pred['x'], pred['y'], pred['width'] * 1.15, pred['height'] * 1.15
                left = max(0, int(x - w / 2))
                top = max(0, int(y - h / 2))
                right = min(image.width, int(x + w / 2))
                bottom = min(image.height, int(y + h / 2))

                # Crop and enlarge
                cropped_image = image.crop((left, top, right, bottom))
                width = int(cropped_image.width * 2)
                height = int(cropped_image.height * 2)
                enlarged = cropped_image.resize((width, height), Image.LANCZOS)

                # OCR Detection
                cropped_text = reader.readtext(
                    np.array(enlarged),
                    allowlist='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                    paragraph=True,
                    min_size=10,
                    text_threshold=0.6,
                    link_threshold=0.2,
                    low_text=0.3
                )

                # Combine Results
                if cropped_text:
                    license_plate_count += 1
                    license_plate = "".join([item[1] for item in cropped_text]).strip()
                    # If more than one plate is detected, set recognition_status to "failed"
                    if license_plate_count > 1:
                        recognition_status = "failed"
                        break
                    recognition_status = "success"  # Set to success if plate is detected
                    print(f"File: {filename}")
                    print(f"License Plate: {license_plate}")
                    print("-" * 30)

            # If more than one plate was detected, set recognition_status to "failed"
            if license_plate_count > 1:
                recognition_status = "failed"

            # Database Insertion (even if no license plate was detected)
            try:
                db_conn = connect_to_db()
                cursor = db_conn.cursor()
                current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

                # If no plate detected, leave license_plate as None (or empty string)
                data = (
                    image_path,            # image_path
                    license_plate or "",   # license_plate (empty if not detected
                    recognition_status,     # recognition status (success or failed)
                )

                insert_violation(cursor, data)
                db_conn.commit()
                print(f"Data inserted for {filename}: {license_plate or 'No plate detected'}")

            except mysql.connector.Error as err:
                print(f"Database error: {err}")
            finally:
                if db_conn.is_connected():
                    cursor.close()
                    db_conn.close()

        except Exception as e:
            print(f"Failed to process {filename}: {str(e)}")
            continue
