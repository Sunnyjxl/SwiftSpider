//
//  StringSpider.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/18.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class StringSpider: NSObject {
    func getHtmlData(url: String, method: RequestMethot, headers: [String: String] = ["User-Agent": UserAgent.Firefox.rawValue], args: [String: String]?, timeout: TimeInterval = 5.0, dataBlock: @escaping ((_: Data?, _: URLResponse?, _: Error?) -> Void)) {
        var requestUrl = url
        
        // 如果是get方法则拼接参数到url后面
        if method == .get {
            requestUrl = url.appending("?\(args?.toArgsString() ?? "")")
        }
        var request = URLRequest(url: URL(string: requestUrl)!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: timeout)
        // post设置参数
        if method == .post {
            request.httpBody = args?.toArgsString().data(using: .utf8)
        }
        
        // 设置请求头
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        // 设置请求方法
        request.httpMethod = method == .get ? "GET" : "POST"
        
        let dataTask = URLSession.shared.dataTask(request: request) { (data, response, error) in
            dataBlock(data, response, error)
        }
        
        dataTask.action()
    }
}
