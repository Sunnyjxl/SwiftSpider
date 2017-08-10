//
//  RegularExpressionUtil.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/25.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class RegularExpressionUtil: NSObject {
    // 获取页面上所有资源文件的url正则表达式
    static let allURLExpression = "(?<=(href|src)=(\"|'))[^#]\\S+?(?=(\"|'))|(?<=url\\()\\S+?(?=\\))"
    
    /// 封装原生正则表达式类
    ///
    /// - Parameters:
    ///   - pattern: 表达式
    ///   - text: 匹配文本
    /// - Returns: 匹配结果
    static func matches(pattern: String, text: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: text.characters.count))
            
            var datas = [String]()
            
            for data in result {
                let str: NSString = text as NSString
                datas.append(str.substring(with: NSRange(location: data.range.location, length: data.range.length)))
            }
            
            return datas
        } catch {
            // 一般是正则表达式错误
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
    /// 根据要查找的html元素生成正则表达式（单行）
    ///
    /// - Parameters:
    ///   - mark: 查找标志（id、class）
    ///   - condition: 查找条件（id="xxxx"）
    /// - Returns: 拼接好的正则表达式
    static func expressionWithFindHtmlSingleElement(mark: String, condition: String) -> String {
        return "<.*?\(mark).*?=.*?\"\(condition)\".*?>"
    }
    
    /// 根据要查找标签生产正则表达式（可多行）
    ///
    /// - Parameters:
    ///   - tagName: 标签名字（input、select、div）
    ///   - mark: 查找标志（id、class）可选
    ///   - condition: 查找条件（id="xxxx"）可选
    /// - Returns: 拼接好的正则表达式
    static func expressionWithFindHtmlMoreElement(tagName: String, mark: String?, condition: String?) -> String {
        if mark == nil {
            return "<\\s*\(tagName)([\\s\\S])*?(</\(tagName)>|/>)"
        }
        return "<\\s*\(tagName).*?\(mark!)=\"\(condition!)\"([\\s\\S])*?(</\(tagName)>|/>)"
    }
}
