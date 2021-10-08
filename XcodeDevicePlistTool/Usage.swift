//
//  Usage.swift
//  XcodeDevicePlistTool
//
//  Created by jungao on 2021/9/30.
//

import Foundation

class Usage {
    static let usage = "用法：\n本工具用于解析Xcode Devices和XCTestDevices目录下的device_set.plist文件\n-f 传递device_set.plist文件路径\n-a 需要删除的目录比如tv，删除tv相关所有目录";
    class func commandUsage(arguments: [String])
    {
        NSLog("%@", usage);
        NSLog("%@", arguments);
    }
}
