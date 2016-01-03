import urllib.request as ul
from bs4 import BeautifulSoup
from bs4 import SoupStrainer
import random
import time


class CSDNVisitor(object):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}

    base_url = "http://blog.csdn.net"

    def get_page(self, url):
        contents = ""
        try:
            request = ul.Request(url, headers=self.headers)
            page = ul.urlopen(request, timeout=5)
            contents = page.read()
        except Exception:
            print("Connection timeout!")
        return contents.decode("utf-8")

    def scan_page(self, url):
        content = self.get_page(url)
        soup = BeautifulSoup(content, "lxml")
        with_class = SoupStrainer(class_="link_title")
        targets = soup.find_all(with_class)
        for target in targets:
            a = target.contents[0]
            title = a.string
            url = self.base_url + a["href"]
            random.seed(time.time())
            time.sleep(random.uniform(random.random() * 2, random.random() * 50))
            request = ul.Request(url, headers=self.headers)
            ul.urlopen(request)
            print("visit:" + title)

    def get_page_count(self):
        return 2

    def scan_pages(self,url):
        page_count = self.get_page_count()
        for i in range(page_count):
            self.scan_page(url+(i+1))

if __name__ == "__main__":
    CSDNVisitor().scan_page("http://blog.csdn.net/u013291394/article/list/")
