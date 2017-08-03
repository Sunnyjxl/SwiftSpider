//
//  main.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/18.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation


let site = SiteSpider()

site.getSiteData(url: "http://www.lanqiao.org", savePath: "/Users/developer/Desktop/aaa")

RequestQueue.shared.starRequest()
//starRequest()
