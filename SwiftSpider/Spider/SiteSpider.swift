//
//  SiteSpider.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/24.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class SiteSpider: NSObject {
    let spider = StringSpider()
    
    /// 把指定页面的所有资源文件保存到本地
    ///
    /// - Parameters:
    ///   - url: 页面URL
    ///   - savePath: 保存路径
    func getSiteData(url: String, savePath: String) {
        
        spider.getHtmlData(url: url, method: .get, args: nil) { [unowned self] (data, response, error) in
            // 分割爬取的URL
            let baseUrlArray = url.components(separatedBy: "/")
            if error == nil && self.checkResponse(with: response) {
                // 判断保存的路径是否存在
                FileUtil.createDirectory(path: savePath)
                
                // 保存当前页面到本地
                FileUtil.saveFile(path: "\(savePath)/\(response!.suggestedFilename ?? "index.html")", data: data)
                
                guard let text = String(data: data!, encoding: .utf8) else {
                    return
                }
                
                for var fileUrl in RegularExpressionUtil.matches(pattern: "(?<=(href|src)=(\"|'))[^#]\\S+?(?=(\"|'))|(?<=url\\()\\S+?(?=\\))", text: text)! {
                    
                    if fileUrl.hasPrefix("./") {
                        fileUrl = fileUrl.substring(from: fileUrl.index(fileUrl.startIndex, offsetBy: 2))
                    } else if fileUrl.hasPrefix("../") {
                        fileUrl = FileUtil.jointDoublePointPath(url: url, filePath: fileUrl)
                    } else if (fileUrl.hasPrefix("'") && fileUrl.hasSuffix("'")) || (fileUrl.hasPrefix("\"") && fileUrl.hasSuffix("\"")) {
                        fileUrl = fileUrl.substring(with: fileUrl.index(after: fileUrl.startIndex)..<fileUrl.index(before: fileUrl.endIndex))
                    } else if fileUrl.hasPrefix("//") {
                        continue
                    } else if fileUrl.hasPrefix("http://") {
                        continue
                    } else if fileUrl.hasPrefix("https://") {
                        continue
                    }
                    
                    // 获取文件保存路径
                    let filePath = FileUtil.createFileDirectory(basePath: savePath, filePath: fileUrl)
                    var baseUrl: String = ""
                    
                    RequestQueue.shared.tempQueue.append(newQueue)
                    
                    for str in baseUrlArray {
                        baseUrl = baseUrl.appending("\(str)/")
                        self.getResourcesFile(url: baseUrl + fileUrl, savePath: savePath, filePath: filePath)
                    }
                    
                }
            }
        }
    }
    
    /// 获取页面上所有资源文件
    ///
    /// - Parameters:
    ///   - url: 资源文件url
    ///   - savePath: 电脑上保存的路径
    ///   - filePath: 文件路径
    private func getResourcesFile(url: String, savePath: String, filePath: String) {
        spider.getHtmlData(url: url, method: .get, args: nil, dataBlock: { [unowned self] (data, response, error) in
            if error == nil && self.checkResponse(with: response) {
                // 判断是否为css文件
                if response!.suggestedFilename!.hasSuffix(".css") {
                    self.getSiteData(url: url, savePath: savePath)
                }
                FileUtil.saveFile(path: "\(filePath)/\(response!.suggestedFilename!)", data: data)
            }
        })
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
