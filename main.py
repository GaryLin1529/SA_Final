import mysql.connector
import subprocess

def run_human_sql():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="1234",
            database="human"
        )
        cursor = conn.cursor()
        with open('c:/SA_Final/manual-system/human.sql', 'r') as file:  # 使用完整路徑
            sql = file.read()
        for result in cursor.execute(sql, multi=True):
            pass
        conn.commit()
        cursor.close()
        conn.close()
        print("human.sql executed successfully.")
    except mysql.connector.Error as e:
        print(f"Error executing human.sql: {e}")
    except FileNotFoundError as e:
        print(f"File not found: {e}")

def run_license_plate_test():
    try:
        subprocess.run(['python', 'c:/SA_Final/license_plate/test.py'], check=True)  # 使用完整路徑
        print("license_plate/test.py executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error executing license_plate/test.py: {e}")

def run_app():
    try:
        subprocess.run(['python', 'c:/SA_Final/manual-system/app.py'], check=True)  # 使用完整路徑
        print("app.py is running.")
    except subprocess.CalledProcessError as e:
        print(f"Error running app.py: {e}")
    except FileNotFoundError as e:
        print(f"File not found: {e}")

if __name__ == "__main__":
    run_human_sql()
    run_license_plate_test()
    run_app()


    123