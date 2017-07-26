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
                if !FileManager.default.fileExists(atPath: savePath) {
                    try? FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: true, attributes: nil)
                }
                
                // 保存当前页面到本地
                FileManager.default.createFile(atPath: "\(savePath)/\(response!.suggestedFilename ?? "index.html")", contents: data, attributes: nil)

                let text = String(data: data!, encoding: .utf8)
                for fileUrl in RegularExpressionUtil.matches(pattern: "(?<=(href|src)=\")[^#]\\S+?(?=\")", text: text!)! {
                    let path = self.createDirectory(basePath: savePath, filePath: fileUrl)
                    
                    var baseUrl: String = ""
                    for str in baseUrlArray {
                        baseUrl = baseUrl.appending("\(str)/")
                        
                        spider.getHtmlData(url: baseUrl + fileUrl, method: .get, args: nil, dataBlock: { (data, response, error) in
                            if error == nil && self.checkResponse(with: response) {
                                FileManager.default.createFile(atPath: "\(path)/\(response?.suggestedFilename ?? "default")", contents: data, attributes: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    
    /// 创建文件夹
    ///
    /// - Parameters:
    ///   - basePath: 文件保存路径
    ///   - filePath: 文件子路径
    private func createDirectory(basePath: String, filePath: String) -> String {
        let splitFilePath = filePath.components(separatedBy: "/")
        
        if splitFilePath.count > 1 {
            var path = ""
            for index in 0..<splitFilePath.count-1 {
                path = path.appending(splitFilePath[index] + "/")
            }
            
            if basePath.hasSuffix("/") {
                
                if !FileManager.default.fileExists(atPath: basePath + path) {
                    try? FileManager.default.createDirectory(atPath: basePath + path, withIntermediateDirectories: true, attributes: nil)
                }
                
                return basePath + path
                
            } else {
                
                if !FileManager.default.fileExists(atPath: basePath + "/" + path) {
                    try? FileManager.default.createDirectory(atPath: basePath + "/" + path, withIntermediateDirectories: true, attributes: nil)
                }
                
                return basePath + "/" + path
            }
        }
        
        return basePath
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
        
        print(httpResponse!.statusCode)
        
        return httpResponse!.statusCode == 200
    }
}
