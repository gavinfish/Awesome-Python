# HotBlog

现在支持的功能：

- 通过百度搜索自动化地实现对CSDN博客内容的访问与抓取

近期要添加的功能：

- 实现一键式使用，提供更易交互的客户端
- CSDN站内所搜访问功能

## HotBlog脚本使用说明

```
>python HotBlog.py

这个脚本可以通过百度搜索引擎来访问CSDN博客，提高博客检索排名。                                                                                                                                                                                              
请输入你的CSDN用户名：                                                                                                                                                                                                                                      
DRFish
请输入搜索关键词：                                                                                                                                                                                                                                          
leetcode drfish
请输入你想要搜索的页面数：                                                                                                                                                                                                                                  
20
----- 开始访问第1页搜索结果-----                                                                                                                                                                                                                            
visit:LeetCode 4Sum - DRFish - 博客频道 - CSDN.NET                                                                                                                                                                                                          
visit:LeetCode Combination Sum - DRFish - 博客频道 - CSDN.NET                                                                                                                                                                                               
visit:LeetCode Generate Parentheses - DRFish - 博客频道 - CSDN.NET                                                                                                                                                                                          
visit:LeetCode Next Permutation - DRFish - 博客频道 - CSDN.NET                                                                                                                                                                                              
visit:LeetCode Search for a Range - DRFish - 博客频道 - CSDN.NET                                                                                                                                                                                            
----- 结束访问第1页搜索结果-----                                                                                                                                                                                                                            
----- 开始访问第2页搜索结果----- 
......                  
```

### 参数说明

CSDN用户名：
就是你CSDN账号的用户名

搜索关键词：
进行百度搜索时输入的关键词

搜索的页面数：
在搜索结果页中需要扫面的页数

### 输出说明

输出主要给出了在第几个搜索结果页，访问了在该页的哪些匹配的结果。

---

## CSDNVisitor脚本使用说明

```
>python CSDNVisitor.py

这个脚本可以访问CSDN博客主页中的所有文章。                                                                                                                                                                                                                  
请输入你的CSDN的id号：                                                                                                                                                                                                                                      
u013291394
----- 开始访问第1页内容 -----                                                                                                                                                                                                                               
visit:LeetCode Trapping Rain Water
visit:LeetCode First Missing Positive
visit:分布式基础之二阶段提交                                                                                                                                                                                                                                
visit:LeetCode Combination Sum II
visit:LeetCode Combination Sum
visit:LeetCode Valid Sudoku
visit:LeetCode Search Insert Position
visit:LeetCode Search for a Range
visit:百度URL参数解析  
......               
```

### 参数说明

CSDN的id号：
进入要访问的CSDN博客首页 `http://blog.csdn.net/****` 星号处就是id号。

### 输出说明

输出了在哪一页访问了哪些文章。