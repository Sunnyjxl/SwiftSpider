//
//  main.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/18.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

let site = SiteSpider()
let string = StringSpider()

string.getHtmlData(url: "http://jw8.lnc.edu.cn/_data/index_LOGIN.aspx", method: .get, args: nil) { (data, response, error) in
//    print(response!.textEncodingName)
    let html = Html(data: data!, encoding: gbk)
//    print(html.text!)
    print(html.tagEqualTo("select", mark: nil, condition: nil)!)
}
//site.getSiteData(url: "http://www.lanqiao.org", savePath: "/Users/developer/Desktop/aaa")

RequestQueue.shared.starRequest()
