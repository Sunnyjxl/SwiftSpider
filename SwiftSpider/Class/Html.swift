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
    
    /// 根据html的class查找对应的元素（单行<input xxxx />）
    ///
    /// - Parameter className: class名称
    /// - Returns: 每个指定class的所有元素
    func classEqualTo(_ className: String) -> [[String: String]]? {
        guard let classElement = RegularExpressionUtil.matches(pattern: RegularExpressionUtil.expressionWithFindHtmlSingleElement(mark: "class", condition: className), text: text!) else {
            return nil
        }
        var result = [[String: String]]()
        // class可有多个
        for element in classElement {
            result.append(analysisElement(element: element))
        }
        return result
    }
    
    /// 根据html的id查找对应元素（单行<input xxxx />）
    ///
    /// - Parameter idName: id名称
    /// - Returns: 指定id的所有元素
    func idEqualTo(_ idName: String) -> [String: String]? {
        guard let idElement = RegularExpressionUtil.matches(pattern: RegularExpressionUtil.expressionWithFindHtmlSingleElement(mark: "id", condition: idName), text: text!) else {
            return nil
        }
        return analysisElement(element: idElement[0])
    }
    
    /// 根据标签查找多行元素（<div xxxx>xxxx</div>）
    ///
    /// - Parameters:
    ///   - tagName: 标签名字
    ///   - mark: id或class
    ///   - condition: id或class的名称
    func tagEqualTo(_ tagName: String, mark: String?, condition: String?) -> [[String: [String: String]]]? {
        guard let tagElement = RegularExpressionUtil.matches(pattern: RegularExpressionUtil.expressionWithFindHtmlMoreElement(tagName: tagName, mark: mark, condition: condition), text: text!) else {
            return nil
        }
//        print(tagElement[0])
        return analysisTagElement(tagElement: tagElement[0])
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
        // 记录引号的数量
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
            }
        }
        return result
    }
    
    /// 把多行的元素解析成数组+字典
    ///
    /// - Parameter tagElement: html元素
    /// - Returns: 数组+字典
    private func analysisTagElement(tagElement: String) -> [[String: [String: String]]] {
        var index = -1
        var valueFlag = false
        var nameFlag = false
        var canClear = false
        // 每行标签名称
        var name = ""
        var key = ""
        var value = ""
        // 记录引号的数量
        var symbolCount = 0
        var result = [[String: [String: String]]]()
        for str in tagElement.characters {
            switch str {
            case "\"", "'":
                symbolCount += 1
                valueFlag = true
                if symbolCount >= 2 {
                    valueFlag = false
                    symbolCount = 0
                    if result.count <= index {
                        result.append([name: [String: String]()])
                    }
                    index = index >= result.count ? result.count - 1 : index
                    result[index][name]?[key] = value
                    key = ""
                    value = ""
                }
            case "<":
                nameFlag = true
                valueFlag = false
                if value.characters.count > 0 {
                    // 添加标签之间的内容<xxx>space</xxx>
                    index = index >= result.count ? result.count - 1 : index
                    result[index][result[index].first!.key]?["space"] = value
                }
                name = ""
            case "=", ">":
                valueFlag = true
                canClear = str == "=" ? false : canClear
            case " ":
                nameFlag = name.characters.count > 0 ? false : true
                value = !valueFlag ? "" : value
                key = canClear ? "" : key
            case "\n", "\r\n", "\t":
                name = str == "\t" ? name : ""
                key = str == "\t" ? name : ""
                value = str == "\t" ? name : ""
            default:
                if nameFlag {
                    if str == "/" || str == "!" {
                        nameFlag = false
                    } else {
                        index += name.characters.count == 0 ? 1 : 0
                        name.append(str)
                    }
                } else if valueFlag {
                    value.append(str)
                } else {
                    key.append(str)
                    canClear = true
                }
            }
        }
        return result
    }
}
