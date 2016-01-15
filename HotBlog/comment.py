from bs4 import BeautifulSoup
import requests
import random
import os

login_url = "https://passport.csdn.net/"
blog_new_url = "http://blog.csdn.net/?ref=toolbar_logo&page={page}"
comment_url = "http://blog.csdn.net/{username}/comment/submit?id={filename}"
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'}
# Prevent duplicate comment, (page_num,article_num)
# This is not safe since the nums can change anytime
article_id = set()
TOTAL_PAGE_COUNT = 11  # The pages count that will be visited
PAGE_ARTICLE_COUNT = 29  # the count of article in each page

# Set up session
session = requests.session()
session.headers.update(headers)

# Get webflow id
r = session.get(login_url)
page = BeautifulSoup(r.text, "lxml")

# Get account info
account = input("请输出csdn账号：\n")
password = input("请输入密码：\n")
authentication = {
    "username": account,
    "password": password,
    "lt": page.select("[name=lt]")[0]["value"],
    "execution": page.select("[name=execution]")[0]["value"],
    "_eventId": "submit",
}

# Login in
r = session.post(login_url, authentication)
page = BeautifulSoup(r.text, "lxml")
# Check if login is successful
if page.title:
    print("登录失败，账号密码错误\n")
    os._exit(0)
else:
    print("登录成功\n")

# Get comment related info
count = int(input("请输入要自动评论的数量（50以内）：\n"))
if count > 50:
    print("输入数字太大\n")
    os._exit(0)
comment = input("请输入自动评论的内容：\n")
comment_data = {
    "content": comment,
}

print("已经成功评论以下文章：\n")
for i in range(1, TOTAL_PAGE_COUNT):
    article_done = 0  # count of articles have been commented on this page
    article_need = count // TOTAL_PAGE_COUNT  # total count of articles need to be commented
    article_need = article_need if i > count % TOTAL_PAGE_COUNT else article_need + 1
    while article_done < article_need:
        # Get the article url
        r3 = requests.get(blog_new_url.format(page=i), headers=headers)
        page3 = BeautifulSoup(r3.text, "lxml")
        article_num = random.randint(0, PAGE_ARTICLE_COUNT)
        # Ignore articles have just been commented
        if (i, article_num) in article_id:
            continue
        else:
            try:
                a = page3.select("[class=blog_list]")[article_num].contents[1].contents[3]
                url = a["href"]
                title = a.string
            except IndexError or KeyError:
                # Net bad
                continue
            article_id.add((i, article_num))
            article_done += 1
            parts = url.split("/")
            username = parts[-4]
            filename = parts[-1]
            target_url = comment_url.format(username=username, filename=filename)
            r4 = session.post(target_url, comment_data)
            print(title + " : " + url)