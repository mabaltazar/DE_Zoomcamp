import sys
import pandas as pd

print('arguments:', sys.argv) # prints the list of command-line arguments passed to the script
month = int(sys.argv[1]) # the first 1 is always the name of the script

df = pd.DataFrame({'day': [1, 2], 'num_passengers': [3, 4]}) # creates a simple DataFrame to demonstrate that pandas is working
df['month'] = month
print(df.head()) # prints the first few rows of the DataFrame

df.to_parquet(f'output_{month}.parquet') # saves the DataFrame to a Parquet file

print(f'Hello from pipeline.py, the month is {month}')