//
//  URLSession.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/24.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

extension URLSession {
    
    /// 扩展方法，响应回调的时候请求队列中移除一个元素
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - complete: 回调block
    /// - Returns: Task
    func dataTask(request: URLRequest, complete: @escaping ((_: Data?, _: URLResponse?, _: Error?) -> Void)) -> URLSessionTask {
        return dataTask(with: request, completionHandler: { (data, response, error) in
            
            complete(data, response, error)
            RequestQueue.shared.mainQueue.removeFirst()
        })
    }
}
