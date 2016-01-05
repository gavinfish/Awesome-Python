import urllib.request as ul
from bs4 import BeautifulSoup
from bs4 import SoupStrainer
import random
import time
import re


class CSDNVisitor(object):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
    base_list_url = "http://blog.csdn.net/{id}/article/list/"
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

    def scan_page(self, url, n):
        target_url = url + str(n)
        content = self.get_page(target_url)
        soup = BeautifulSoup(content, "lxml")
        with_class = SoupStrainer(class_="link_title")
        targets = soup.find_all(with_class)
        print("----- 开始访问第" + str(n) + "页内容 -----")
        for target in targets:
            a = target.contents[0]
            title = a.string.strip()
            url = self.base_url + a["href"]
            random.seed(time.time())
            time.sleep(random.uniform(random.random() * 2, random.random() * 50))
            request = ul.Request(url, headers=self.headers)
            ul.urlopen(request)
            print("visit:" + title)
        print("----- 结束访问第" + str(n) + "页内容 -----")

    def get_page_count(self, url):
        content = self.get_page(url)
        page_count_match = re.search("共[0-9]*页", content)
        if not page_count_match:
            return 0
        page_count = int(page_count_match.group()[1:-1])
        return page_count

    def scan_pages(self, url):
        page_count = self.get_page_count(url)
        for i in range(page_count):
            self.scan_page(url, i + 1)

    def interpret(self):
        print("这个脚本可以访问CSDN博客主页中的所有文章。")
        id = input("请输入你的CSDN的id号：\n")
        self.scan_pages(self.base_list_url.format(id=id))


if __name__ == "__main__":
    CSDNVisitor().interpret()
