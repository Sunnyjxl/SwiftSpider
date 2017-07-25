//
//  SiteSpider.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/24.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class SiteSpider: NSObject {
    func getSiteData(url: String, savePath: String) {
        let spider = StringSpider()
        
        spider.getHtmlData(url: url, method: .get, args: nil) { (data, response, error) in
            
            if error == nil {
//                let file = FileHandle(forWritingAtPath: "\(savePath)/name.txt")
                FileManager.default.createFile(atPath: "\(savePath)/index.html", contents: data, attributes: nil);
//                print("\(savePath)/index.html")
//                print(file)
//                file?.seekToEndOfFile()
//                print(data!)
//                file?.write("123".data(using: .utf8)!)
            }
        }
    }
}
