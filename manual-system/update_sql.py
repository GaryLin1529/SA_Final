import re
import requests
from bs4 import BeautifulSoup

# Address to coordinates function
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

# Process the target INSERT statement
def process_insert_statement(table_name, fields, values):
    fields_list = fields.split(',')
    fields_list = [f.strip().strip('`') for f in fields_list]  # Clean field names

    # Determine the index of the location or address field
    if 'location' in fields_list:
        address_index = fields_list.index('location')
    elif 'address' in fields_list:
        address_index = fields_list.index('address')
    else:
        print(f"No `location` or `address` field found in table `{table_name}`.")
        return None

    rows = re.findall(r"\((.*?)\)", values, re.S)
    updated_rows = []

    for row in rows:
        parts = []
        # Handle commas within quoted strings
        temp = ''
        in_quotes = False
        for part in row.split(','):
            if in_quotes:
                temp += ',' + part
                if part.strip().endswith("'"):
                    in_quotes = False
                    parts.append(temp)
                    temp = ''
            else:
                if part.strip().startswith("'") and not part.strip().endswith("'"):
                    temp = part
                    in_quotes = True
                else:
                    parts.append(part)
        # Strip quotes and spaces
        parts = [p.strip() for p in parts]

        address = parts[address_index].strip("'")
        print(f"Fetching coordinates for address: {address}")
        url = f"https://www.google.com/maps/place?q={address}"
        coordinates = coordination(url)

        if coordinates:
            parts.append(f"{coordinates[1]:.15f}")  # Longitude
            parts.append(f"{coordinates[0]:.15f}")  # Latitude
            updated_row = f"({', '.join(parts)})"
        else:
            print(f"Failed to fetch coordinates for: {address}")
            parts.append('NULL')  # Handle missing longitude
            parts.append('NULL')  # Handle missing latitude
            updated_row = f"({', '.join(parts)})"

        updated_rows.append(updated_row)

    # Add longitude and latitude to fields
    fields_list.extend(['longitude', 'latitude'])
    updated_values = ',\n'.join(updated_rows)
    updated_statement = f"INSERT INTO `{table_name}` (`{'`, `'.join(fields_list)}`) VALUES\n{updated_values};"
    return updated_statement

# Update the entire SQL file
def update_sql_file(sql_file, target_table):
    try:
        with open(sql_file, 'r', encoding='utf-8') as file:
            sql_content = file.read()
            print(f"Loaded SQL file content from '{sql_file}'.")

        # Ensure longitude and latitude columns exist
        if "longitude" not in sql_content or "latitude" not in sql_content:
            alter_table_sql = f"\nALTER TABLE `{target_table}` ADD COLUMN `longitude` DOUBLE, ADD COLUMN `latitude` DOUBLE;\n"
            sql_content += alter_table_sql
            print(f"Added longitude and latitude columns to `{target_table}`.")

        # Find all INSERT statements
        insert_statements = re.findall(r"(INSERT INTO\s+`?(\w+)`?\s*\((.*?)\)\s*VALUES\s*(\(.*?\));)", sql_content, re.S | re.M)
        print(f"Found {len(insert_statements)} INSERT INTO statements.")

        for full_statement, table_name, fields, values in insert_statements:
            if table_name == target_table:
                print(f"Processing table `{table_name}`.")
                updated_statement = process_insert_statement(table_name, fields, values)
                if updated_statement:
                    # Replace the old statement with the updated one
                    sql_content = sql_content.replace(full_statement, updated_statement)
            else:
                print(f"Skipping table `{table_name}`.")

        # Write the updated content back to the file
        with open(sql_file, 'w', encoding='utf-8') as file:
            file.write(sql_content)
            print(f"Updated SQL content written to '{sql_file}'.")

    except Exception as e:
        print(f"An error occurred: {e}")

# Main program
if __name__ == "__main__":
    sql_file_path = "human.sql"       # Your SQL file path
    target_table_name = "violations"  # Target table name
    update_sql_file(sql_file_path, target_table_name)
