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

string.getHtmlData(url: "http://www.lanqiao.org", method: .get, args: nil) { (data, response, error) in
//    print(response!.textEncodingName)
    let html = Html(data: data!)
    print(html.text!)
//    print(html.text!)
//    print(html.tagEqualTo("div", mark: "class", condition: "down-links")!)
//    print(html.text!)
    print(html.tagEqualTo("video", mark: "id", condition: "mainVideoi")!)
//    print(html.classEqualTo("tijiao")!)
}

RequestQueue.shared.starRequest()
