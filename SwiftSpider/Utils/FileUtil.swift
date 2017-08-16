//
//  FileUtil.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/26.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Cocoa

class FileUtil: NSObject {
    
    /// 获取当前路径的上一级路径
    ///
    /// - Parameter currentDirectory: 当前路径
    /// - Returns: 上一级路径
    static func getFatherDirectory(currentDirectory: String) -> String {
        let splitDirectory = currentDirectory.components(separatedBy: "/")
        var fatherDirectory = ""
        
        for index in 1..<splitDirectory.count-2 {
            fatherDirectory += "/\(splitDirectory[index])"
        }
        
        return fatherDirectory
    }
    
    /// 根据爬取的URL拼接包含../的路径
    ///
    /// - Parameters:
    ///   - url: 爬取的URL
    ///   - filePath: 文件路径(../xxx.png)
    /// - Returns: 替换..的路径
    static func jointDoublePointPath(url: String, filePath: String) -> String {
        let splitUrl = url.components(separatedBy: "/")
        
        return splitUrl[splitUrl.count - 3] + filePath.substring(from: filePath.index(filePath.startIndex, offsetBy: 2))
    }
    
    /// 创建对应路径的文件夹
    ///
    /// - Parameters:
    ///   - basePath: 保存的路径（/User/apple/Desktop/Test）
    ///   - filePath: 文件路径 (upload/abc.mp4)
    /// - Returns: 创建好的文件路径不包括文件名 (/User/apple/Desktop/Test/upload)
    static func createFileDirectory(basePath: String, filePath: String) -> String {
        let splitFilePath = filePath.components(separatedBy: "/")
        if splitFilePath.count > 1 {
            var path = ""
            for index in 0..<splitFilePath.count-1 {
                path = path.appending(splitFilePath[index] + "/")
            }
            // 判断路径是否以 / 结尾
            if basePath.hasSuffix("/") {
                if !FileManager.default.fileExists(atPath: basePath + path) {
                    try? FileManager.default.createDirectory(atPath: basePath + path, withIntermediateDirectories: true, attributes: nil)
                }
                return basePath + path
            } else {
                if !FileManager.default.fileExists(atPath: basePath + "/" + path) {
                    try? FileManager.default.createDirectory(atPath: basePath + "/" + path, withIntermediateDirectories: true, attributes: nil)
                }
                return basePath + "/" + path
            }
        }
        
        return basePath
    }
    
    /// 创建文件夹
    ///
    /// - Parameter path: 文件夹路径
    static func createDirectory(path: String) {
        // 判断保存的路径是否存在
        if !FileManager.default.fileExists(atPath: path) {
            // 不存在则创建对应路径的文件夹
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// 保存文件到本地
    ///
    /// - Parameters:
    ///   - path: 保存路径
    ///   - data: 文件内容
    static func saveFile(path: String, data: Data?) {
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
}
