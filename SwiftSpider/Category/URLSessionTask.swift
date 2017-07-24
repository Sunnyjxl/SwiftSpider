//
//  URLSessionDataTask+extension.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/23.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

extension URLSessionTask {
    
    /// 扩展方法，在请求的时候往请求队列中添加一个元素
    func action() {
        resume()
        requestQueue.append(newQueue)
    }
}
