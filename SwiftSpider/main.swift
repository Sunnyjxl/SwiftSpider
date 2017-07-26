//
//  main.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/18.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

//let str = StringSpider()

//str.getHtmlData(url: "http://www.c-excellence.com/shcp_m/login.html#", method: .get, args: nil) { (data, _, error) in
//    if error == nil {
//        let text = String(data: data!, encoding: .utf8)
//        for str in RegularExpressionUtil.matches(pattern: "(?<=(href|src)=\")[^#]\\S+?(?=\")", text: text!)! {
//            print(str)
//        }
//    }
//}

let site = SiteSpider()

site.getSiteData(url: "http://www.c-excellence.com/shcp_m/login.html#", savePath: "/Users/developer/Desktop/bbb")

while true {
//    print(requestQueue.count)
}
