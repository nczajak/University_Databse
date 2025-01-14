import os
import pandas as pd
import pyodbc

# Database connection parameters
server = 'dbmanage.lab.ii.agh.edu.pl'
database = 'u_czajak'
username = 'u_czajak'
password = 'EddwdGNCzgEv'
driver = 'ODBC Driver 17 for SQL Server'

# Establish a database connection
conn = pyodbc.connect(f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}')
cursor = conn.cursor()

# Path to the data folder
data_folder = 'data'

# Iterate over all CSV files in the data folder
for filename in os.listdir(data_folder):
    if filename.endswith('.csv'):
        file_path = os.path.join(data_folder, filename)
        
        # Read the CSV file into a DataFrame
        df = pd.read_csv(file_path)
        
        # Assuming the table name is the same as the CSV file name without extension
        table_name = os.path.splitext(filename)[0]
        
        # Delete existing data in the table
        delete_query = f'DELETE FROM {table_name}'
        cursor.execute(delete_query)
        
        # Insert DataFrame into SQL Server
        for index, row in df.iterrows():
            # Create an insert query dynamically
            columns = ', '.join(row.index)
            values = ', '.join(['?'] * len(row))
            insert_query = f'INSERT INTO {table_name} ({columns}) VALUES ({values})'
            
            # Execute the insert query
            try:
                cursor.execute(insert_query, tuple(row))
            except Exception as e:
                print(f"Error inserting row {index}: {e}")
                continue
        
        # Commit the transaction
        conn.commit()

# Close the database connection
cursor.close()
conn.close()