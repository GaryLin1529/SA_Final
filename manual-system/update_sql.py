import re
import requests
from bs4 import BeautifulSoup

# 地址轉經緯度函式
def STR_to_NUM(data):
    line = tuple(data.split(','))
    num1 = float(line[1])
    num2 = float(line[2])
    return [round(num1, 15), round(num2, 15)]

def coordination(url):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, "html.parser")
        text = soup.prettify()
        initial_pos = text.find(";window.APP_INITIALIZATION_STATE")
        if initial_pos == -1:
            print("Failed to find initialization data. Address might be invalid.")
            return None
        data = text[initial_pos + 36:initial_pos + 82]
        return STR_to_NUM(data)
    except Exception as e:
        print(f"An error occurred while fetching the URL: {e}")
        return None

# 處理目標 INSERT 語法
def process_insert_statement(table_name, fields, values):
    fields_list = fields.split(',')
    fields_list = [f.strip().strip('`') for f in fields_list]

    if 'location' in fields_list:
        location_index = fields_list.index('location')
    else:
        print(f"No `location` field found in table `{table_name}`.")
        return None

    rows = re.findall(r"\((.*?)\)", values, re.S)
    updated_rows = []

    for row in rows:
        parts = row.split(',')
        location = parts[location_index].strip().strip("'")
        print(f"Fetching coordinates for location: {location}")
        url = f"https://www.google.com/maps/place?q={location}"
        coordinates = coordination(url)

        if coordinates:
            parts.append(f"{coordinates[1]:.15f}")
            parts.append(f"{coordinates[0]:.15f}")
            updated_row = f"({', '.join(parts)})"
        else:
            updated_row = f"({', '.join(parts)})"
        
        updated_rows.append(updated_row)

    fields_list.extend(['longitude', 'latitude'])
    updated_values = ',\n'.join(updated_rows)
    return f"INSERT INTO `{table_name}` (`{'`, `'.join(fields_list)}`) VALUES {updated_values};"

# 更新整個 SQL 檔案
def update_sql_file(sql_file, target_table):
    try:
        with open(sql_file, 'r', encoding='utf-8') as file:
            sql_content = file.read()
            print(f"Loaded SQL file content from '{sql_file}'.")

        insert_statements = re.findall(r"INSERT INTO\s+`?(\w+)`?\s*\((.*?)\)\s*VALUES\s*(\(.*?\));", sql_content, re.S | re.M)
        print(f"Found {len(insert_statements)} INSERT INTO statements.")
        
        updated_statements = []
        for statement in insert_statements:
            table_name, fields, values = statement
            if table_name == target_table:
                print(f"Processing table `{table_name}`.")
                updated_statement = process_insert_statement(table_name, fields, values)
                if updated_statement:
                    updated_statements.append((f"INSERT INTO `{table_name}` ({fields}) VALUES {values};", updated_statement))
            else:
                updated_statements.append((None, None))

        for old, new in updated_statements:
            if old and new:
                sql_content = sql_content.replace(old, new)

        with open(sql_file, 'w', encoding='utf-8') as file:
            file.write(sql_content)
            print(f"Updated SQL content written to '{sql_file}'.")
    except Exception as e:
        print(f"An error occurred: {e}")

# 主程式
if __name__ == "__main__":
    sql_file_path = "human.sql"
    target_table_name = "violations"
    update_sql_file(sql_file_path, target_table_name)
