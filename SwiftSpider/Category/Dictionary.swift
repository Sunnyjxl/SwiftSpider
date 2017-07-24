//
//  Dictionary.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/24.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 扩展的字典方法，返回一个拼接好的参数字符串
    ///
    /// - Returns: 参数字符串
    func toArgsString() -> String {
        var args = ""
        
        for (key, value) in self {
            args = args.appending("\(key)=\(value)&")
        }
        
        return args.substring(with: args.startIndex..<args.index(before: args.endIndex))
    }
}
