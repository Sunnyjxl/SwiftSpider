//
//  SiteSpider.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/24.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class SiteSpider: NSObject {
    private var urlArray = [String]()
    
    func getSiteData(url: String, savePath: String) {
        let spider = StringSpider()
        
        spider.getHtmlData(url: url, method: .get, args: nil) { (data, response, error) in
            // 分割爬取的URL
            let baseUrlArray = url.components(separatedBy: "/")

            if error == nil && self.checkResponse(with: response) {
                // 判断保存的路径是否存在
                FileUtil.createDirectory(path: savePath)
                
                // 保存当前页面到本地
                FileUtil.saveFile(path: "\(savePath)/\(response!.suggestedFilename ?? "index.html")", data: data)
                
                let text = String(data: data!, encoding: .utf8)
                for var fileUrl in RegularExpressionUtil.matches(pattern: "(?<=(href|src)=\")[^#]\\S+?(?=\")|(?<=url\\()\\S+?(?=\\))", text: text!)! {
                    
                    if fileUrl.hasPrefix("./") {
                        fileUrl = fileUrl.substring(from: fileUrl.index(fileUrl.startIndex, offsetBy: 2))
                    } else if fileUrl.hasPrefix("../") {
                        fileUrl = FileUtil.jointDoublePointPath(url: url, filePath: fileUrl)
                    } else if fileUrl.hasPrefix("//") {
                        continue
                    } else if fileUrl.hasPrefix("http://") {
                        continue
                    } else if fileUrl.hasPrefix("https://") {
                        continue
                    }
                    print(fileUrl)
//                    print(fileUrl)
                    let path = FileUtil.createFileDirectory(basePath: savePath, filePath: fileUrl)
                    
                    var baseUrl: String = ""
                    for str in baseUrlArray {
                        baseUrl = baseUrl.appending("\(str)/")
                        
                        spider.getHtmlData(url: baseUrl + fileUrl, method: .get, args: nil, dataBlock: { (data, response, error) in
                            if error == nil && self.checkResponse(with: response) {
                                FileUtil.saveFile(path: "\(path)/\(response!.suggestedFilename!)", data: data)
                                if response!.suggestedFilename!.hasSuffix(".css") {
                                    self.getSiteData(url: baseUrl + fileUrl, savePath: savePath)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func addUrlArray( url: String) {
        var url = url
       
        if url.hasPrefix("./") {
            url = url.substring(from: url.index(url.startIndex, offsetBy: 2))
        } else if url.hasPrefix("../") {
            url = FileUtil.jointDoublePointPath(url: url, filePath: url)
        } else if url.hasPrefix("//") {
            return
        } else if url.hasPrefix("http://") {
            return
        } else if url.hasPrefix("https://") {
            return
        }
    }
    
    /// 检查响应的状态码
    ///
    /// - Parameter response: http响应
    /// - Returns: 状态码是否为200
    private func checkResponse(with response: URLResponse?) -> Bool {
        let httpResponse = response as? HTTPURLResponse
        
        if httpResponse == nil {
            return false
        }
        
        return httpResponse!.statusCode == 200
    }
}
