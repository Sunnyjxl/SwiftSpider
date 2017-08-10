//
//  Macro.swift
//  SwiftSpider
//
//  Created by 邝文亮 on 2017/7/21.
//  Copyright © 2017年 邝文亮. All rights reserved.
//

import Foundation

enum RequestMethot: Int {
    case post = 0
    case get = 1
}

// GBK编码
let gbk = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue)))
