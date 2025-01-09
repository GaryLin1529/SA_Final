import os
import mysql.connector

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",        # Replace with your MySQL username
    password="1234",    # Replace with your MySQL password
    database="violation_system"  # Ensure this matches your database name
)

cursor = db.cursor()

# Function to upload an image into the database
def upload_image(violation_time, location, camera_id, image_path, remarks):
    try:
        # Read the image file as binary data
        with open(image_path, "rb") as file:
            binary_image = file.read()

        # SQL query to insert data into the violations table
        query = """
        INSERT INTO violations (violation_time, location, camera_id, image_path, status, remarks)
        VALUES (%s, %s, %s, %s, 'pending', %s)
        """
        
        # Execute the query with binary data
        cursor.execute(query, (violation_time, location, camera_id, binary_image, remarks))
        db.commit()
        print(f"Uploaded: {os.path.basename(image_path)}")
    except Exception as e:
        print("Error uploading image:", e)

# Function to check for new images in the folder
def process_folder(folder_path):
    try:
        # Fetch all previously uploaded file names from the database
        cursor.execute("SELECT image_path FROM violations")
        uploaded_files = {row[0] for row in cursor.fetchall()}  # Store paths in a set

        # Scan the folder for new image files
        for filename in os.listdir(folder_path):
            if filename.endswith((".png", ".jpg", ".jpeg")):  # Check for valid image formats
                full_path = os.path.join(folder_path, filename)
                if full_path not in uploaded_files:
                    # Upload new image
                    upload_image(
                        violation_time="2024-12-27 15:00:00",  # Replace with dynamic time if needed
                        location="Unknown Location",          # Adjust dynamically if required
                        camera_id="Unknown Camera",           # Adjust dynamically if required
                        image_path=full_path,
                        remarks="Auto-uploaded from folder"
                    )
    except Exception as e:
        print("Error processing folder:", e)

# Folder containing images
folder_path = r"C:\Users\wewey\OneDrive\Desktop\violation database"

# Process the folder
process_folder(folder_path)

# Close the connection
cursor.close()
db.close()
