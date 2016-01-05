import urllib.request as ul
import re
from bs4 import BeautifulSoup
import time
import random


class HotBlog(object):
    url_pattern = "http://www.baidu.com/s?ie=utf-8&pn={pn}&wd={wd}"

    def get_page(self, url):
        contents = b""
        try:
            page = ul.urlopen(url, timeout=5)
            contents = page.read()
        except Exception:
            print("Connection timeout!")
        return contents.decode("utf-8")

    def scan_page(self, pn, wd):
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
        html = self.get_page(self.url_pattern.format(pn=pn, wd=wd))
        soup = BeautifulSoup(html, "lxml")
        blog_title_pattern = re.compile(".*- DRFish - 博客频道 - CSDN.NET$")
        for target in soup.find_all(id=re.compile("tools_[0-9]*_[1-9]")):
            data_tools = target.attrs["data-tools"]
            parts = data_tools.split('","url":"')
            if len(parts) != 2:
                continue
            title = parts[0][10:]
            url = parts[1][:-2]

            if re.match(blog_title_pattern, title):
                random.seed(time.time())
                time.sleep(random.uniform(random.random() * 2, random.random() * 50))
                request = ul.Request(url, headers=headers)
                ul.urlopen(request)
                print("visit:" + title)

    def scan_n_pages(self, n, wd):
        for i in range(n):
            self.scan_page(10 * i, wd)