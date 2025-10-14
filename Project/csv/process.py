import csv

def read_csv(csvfilename):
  """
  Read .csv file.
  - file: the .csv file with the full path
  """
  rows = []
  with open(csvfilename, encoding='utf-8') as csvfile:
    file_reader = csv.reader(csvfile)
    for row in file_reader:
      rows.append(row)
  return rows


# Example usage
#   ensure that 'menu.csv' is in the same directory
for menu in read_csv('menu.csv')[1:]:
  print(f"""INSERT INTO table VALUE ('{"', '".join(menu)}');""")
