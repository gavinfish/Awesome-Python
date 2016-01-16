f = open('hello.txt')
print(f.read())
print('---------')
f.seek(0)
for line in f.readlines():
  print((line,'&&\n'))
f.seek(0)
for i in range(4):
  print(str(i)+":"+f.readline())
f.close()
