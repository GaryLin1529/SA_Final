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
        print("Image uploaded successfully!")
    except Exception as e:
        print("Error uploading image:", e)

# File path for the image
image_path = "./picture.png"  # Relative path for the image in the same folder

# Example usage
upload_image(
    violation_time="2024-12-27 15:00:00",
    location="Random Intersection",
    camera_id="CAM12345",
    image_path = r"test4.jpg",
    remarks="Violation for testing purposes"
)

# Close the connection
cursor.close()
db.close()
