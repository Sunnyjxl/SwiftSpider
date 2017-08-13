# SwiftSpider(使用最简单的方法来编写Swift爬虫)
Using the the Swift programming language to build web spider,
即使不懂正则表达式的使用，也能愉快的使用这套工具来写爬虫程序

# 使用简介
## StringSpider（获取指定url页面的信息）
请求结果通过block回调
```Swift
let spider = StringSpider()
spider.getHtmlData(url: "http://www.lanqiao.org", method: .get, args: nil) { (data, response, error) in
	// data 为获取到的数据，获取失败情况下为nil
	// response 为响应信息，里面包含响应状态码、页面编码一类的信息
	// error 请求错误信息，请求成功状态下为nil
}
```
 getHtmlData方法部分参数含有默认值，已默认设置User-Agent和请求timeout时间
 ```Swift
 func getHtmlData(url: String, method: RequestMethot, headers: [String: String] = ["User-Agent": UserAgent.Firefox.rawValue], args: [String: String]?, timeout: TimeInterval = 5.0, dataBlock: @escaping ((_: Data?, _: URLResponse?, _: Error?) -> Void))
 ```
 
 ## Html类
 Html类继承于NSObject，可以将请求得到的data数据按照指定编码（默认UTF-8）转换成文本信息并根据html的id或class或标签截取指定内容
 ```Swift
 let spider = StringSpider()
 spider.getHtmlData(url: "http://www.lanqiao.org", method: .get, args: nil) { (data, response, error) in
   // 此处应先判断是否请求成功
   let html = Html(data: data!)
   // print(html.text) text为页面的html信息
 }
 ```
 1. 根据id获取对应信息
 例如页面某部分的html代码如下
 ```html
 <div>
	 <input type="text" name="loginid" id="loginid" class="zhuce" placeholder="请输账号">
	 <input type="password" class="zhuce" placeholder="请输入密码" name="password" id="password">
	 <label for="" class="zhuce"><input type="checkbox" id="saveLoginInfo" name="saveLoginInfo">&nbsp;&nbsp;记住密码<a href="#" class="forg">忘记密码？</a></label>
	 <a href="javascript:;" onclick="showLoginForm();" class="tijiao" id="login">登&nbsp;&nbsp;录</a>
 </div>
 ```
 现在想要获取id为password那一栏的信息，则调用如下方法:
 ```Swift
 html.idEqualTo("password")
 ```
 方法返回的是一个字典（[String: String]?）,上述例子拆包后得到如下的一个字典类型:
 ```Swift
 ["name": "password", "class": "zhuce", "type": "password", "placeholder": "请输入密码", "id": "password"]
 ```
 
 2. 根据class获取对应信息
 还是以上面的html代码为例子，获取class为tijiao的信息
 ```Swift
 html.classEqualTo("tijiao")
 ```
 该方法返回值是一个数组（ [[String: String]]?），因为一个页面上可以有多个class相同的元素，每个元素对应一个字典（[String: String]），上述例子拆包    
 后得到：
 ```Swift
 [["onclick": "showLoginForm();", "class": "tijiao", "href": "javascript:;", "id": "login"]]
 ```
 
 3. 根据标签获取信息
 ```html
 <div class="down-links">
   <a target="_blank" href="https://appsto.re/cn/2tGI-.i" class="down iphone" title="点击下载iPhone客户端">iPhone</a>
   <a href="http://www.54youwei.com/com.youwei.apk" class="down android" title="点击下载有为Android客户端">Android</a>
 </div>
 ```
 上面的这段代码为例子，获取class为down-links的div标签里面的所有信息
 ```Swift
 html.tagEqualTo("div", mark: "class", condition: "down-links")
 ```
 该方法返回的是一个数组（ [[String: [String: String]]]?），该数组里面的每一个元素是一个字典（[String: [String: String]]），这个字典的key为标签的名字，如上面的例子，该方法返回的结构为:
 ```Swift
 ["div": [String: String], "a": [String]: [String], "a": [String]: [String]]
 ```
 所以我们只需要根据对应标签名字就可以获取到该标签里面的所有信息，上述例子拆包后得到：
 ```Swift
 [
  ["div": ["class": "down-links"]], 
  ["a": ["target": "_blank", "class": "downiphone", "href": "https://appsto.re/cn/2tGI-.i", "title": "点击下载iPhone客户端", "space": "iPhone"]], 
  ["a": ["title": "点击下载有为Android客户端", "class": "downandroid", "href": "http://www.54youwei.com/com.youwei.apk", "space": "Android"]]
 ]
 ```
 
 ## SiteSpider（把页面上的所有资源保存到本地）
 这个类可以把页面上的所有资源（视频、图片、css、js）保存到本地
 ```Swift
 let spider = SiteSpider()
 spider.getSiteData(url: "http://www.lanqiao.org", savePath: "/Users/developer/Desktop/test")
 ```
 使用该方法要确保方法调用完毕之前程序没有被终止
 
 ### 目前还存在一些Bug，会在以后的更新中逐步修改
