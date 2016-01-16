from urllib.request import urlopen
from urllib.request import urlretrieve
import pprint
webpage = urlopen('http://www.baidu.com')
pprint.pprint(webpage.readlines())
urlretrieve('http://www.baidu.com','baidu.html')
