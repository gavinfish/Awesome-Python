import sqlite3

conn = sqlite3.connect('food.db')
curs = conn.cursor()
curs.execute('''CREATE TABLE food(
  id	TEXT	PRIMARY KEY,
  name 	TEXT)
  ''')
query = 'INSERT INTO food VALUES (?,?)'
curs.execute(query,('a','bread'))
curs.execute(query,('b','juice'))
conn.commit()
conn.close()
