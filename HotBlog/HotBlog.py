import urllib.request as ul
import re
from bs4 import BeautifulSoup
import time
import random


class HotBlog(object):
    # Store the first ten urls of baidu search pages
    url_pattern = "http://www.baidu.com/s?ie=utf-8&wd={wd}"

    def __index__(self, csdn_id):
        self.id = csdn_id

    def get_page(self, url):
        page = ul.urlopen(url)
        bytes = page.read()
        return bytes.decode("utf-8")

    def scan_page(self, np, wd):
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
        html = HotBlog().get_page(self.url_pattern.format(np=np, wd=wd))
        soup = BeautifulSoup(html, "lxml")
        blog_title_pattern = re.compile(".*- DRFish - 博客频道 - CSDN.NET$")
        for target in soup.find_all(id=re.compile("tools_*")):
            data_tools = target.attrs["data-tools"]
            parts = data_tools.split('","url":"')
            title = parts[0][10:]
            url = parts[1][:-2]

            if re.match(blog_title_pattern, title):
                random.seed(time.time())
                time.sleep(random.uniform(random.random() * 2, random.random() * 50))
                request = ul.Request(url, headers=headers)
                ul.urlopen(request)
                print("visit:" + title)

    def scan_n_pages(self, n, wd):
        for i in range(1, n):
            self.scan_page(10 * i, wd)


if __name__ == "__main__":
    HotBlog().scan_page(10, "csdn%20drfish")
