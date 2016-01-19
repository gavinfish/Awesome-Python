#read each time
f = open('hello.txt')
while True:
  char = f.read(1)
  if not char:break
  print(ord(char))

f.seek(0)
while True:
  line = f.readline()
  if not line:break
  print(line+'---------')

#read the all context
f.seek(0)
for char in f.read():
  print(char)

f.seek(0)
i = 1
for line in f.readlines():
  print(i)
  i+=1
f.close()

for line in open('hello.txt'):
  print("nice")
