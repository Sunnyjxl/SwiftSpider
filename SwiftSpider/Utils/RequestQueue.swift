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
public let tempQueue: Queue = 1

public var requestQueue = [Queue]()

public func starRequest() {
//    print(requestQueue.count)
    while requestQueue.count > 0 {
        print(requestQueue.count)
    }
}
