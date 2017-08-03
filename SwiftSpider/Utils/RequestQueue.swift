//
//  RequestQueue.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/21.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

// 请求队列
public typealias Queue = Int
public let newQueue: Queue = 0

final class RequestQueue: NSObject {
    static let shared = RequestQueue()
    // 主队列
    var mainQueue = [Queue]()
    // 临时队列（防止提前中止）
    var tempQueue = [Queue]()
    private var count = 0
    
    func starRequest() {
        
        while mainQueue.count > 0 || tempQueue.count > 0 {
            if mainQueue.count == 0 {
                count += 1
            } else {
                count = 0
            }
            
            if count >= 1000 {
                tempQueue.removeFirst()
            }
        }
    }
    
    private override init() {
        
    }
}
