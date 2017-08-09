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

string.getHtmlData(url: "http://www.jianshu.com/p/553d707e4a0a", method: .get, args: nil) { (data, response, error) in
    let html = Html(data: data!)
    print(html.idEqualTo("q")!)
}
//site.getSiteData(url: "http://www.lanqiao.org", savePath: "/Users/developer/Desktop/aaa")

RequestQueue.shared.starRequest()
