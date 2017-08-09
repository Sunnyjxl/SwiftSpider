//
//  Html.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/8/9.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class Html: NSObject {
    var text: String?
    
    init(data: Data, encoding: String.Encoding = .utf8) {
        super.init()
        text = String(data: data, encoding: encoding)
    }
    
    init(text: String) {
        super.init()
        self.text = text
    }
    
    /// 根据html的class查找对应的元素
    ///
    /// - Parameter className: class名称
    /// - Returns: 每个指定class的所有元素
    func classEqualTo(_ className: String) -> [[String: String]]? {
        
        guard let classElement = RegularExpressionUtil.matches(pattern: RegularExpressionUtil.expressionWithFindHtmlElement(mark: "class", condition: className), text: text!) else {
            return nil
        }
        
        var result = [[String: String]]()
        
        for element in classElement {
            result.append(analysisElement(element: element))
        }
        
        return result
    }
    
    
    /// 根据html的id查找对应元素
    ///
    /// - Parameter idName: id名称
    /// - Returns: 指定id的所有元素
    func idEqualTo(_ idName: String) -> [String: String]? {
        
        guard let idElement = RegularExpressionUtil.matches(pattern: RegularExpressionUtil.expressionWithFindHtmlElement(mark: "id", condition: idName), text: text!) else {
            return nil
        }
        
        let result = analysisElement(element: idElement[0])
        
        return result
    }
    
    
    /// 把正则表达式截取的标签解析成字典
    ///
    /// - Parameter element: html标签
    /// - Returns: 解析后的字典
    private func analysisElement(element: String) -> [String: String] {
        var result = [String: String]()
        // 标记当前字符是否为value还是key
        var valueFlag = false
        // 标记是否需要清空key的值
        var canClear = false
        // 记录双引号的数量
        var symbolCount = 0
        var key = ""
        var value = ""
        for str in element.characters {
            switch str {
            case "\"":
                symbolCount += 1
                if symbolCount >= 2 {
                    valueFlag = false
                    symbolCount = 0
                    result[key] = value
                    key = ""
                }
                continue
            case " ":
                if !valueFlag {
                    value = ""
                }
                
                if canClear {
                    key = ""
                }
                
            case "=":
                valueFlag = true
                canClear = false
            default:
                if valueFlag {
                    value.append(str)
                    
                } else {
                    key.append(str)
                    canClear = true
                }
                
                break
            }
        }
        
        return result
    }
}
