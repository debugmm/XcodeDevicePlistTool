//
//  main.swift
//  XcodeDevicePlistTool
//
//  Created by jungao on 2021/9/30.
//

import Foundation

class AnalysisPlistFile {

    class func handlePlistFile(dictInfo : NSDictionary, deviceFileURL : URL) -> [String] {
        if let osDictInfo : NSDictionary = dictInfo.object(forKey: "DefaultDevices") as? NSDictionary {
            var directoryNames : Array<String> = [];
            var directoryPath : Array<String> = [];
            osDictInfo.enumerateKeysAndObjects { k, v, _ in
                let osk = k as! NSString;
                if (osk.contains("tvOS")) {
                    let dirDict : NSDictionary = v as! NSDictionary;
                    dirDict.enumerateKeysAndObjects { k, v, _ in
                        directoryNames.append(v as! String);
                    }
                }
            };

            /// 移除目录
            if (directoryNames.count < 1) {
                print("没有需要移除的tvOS文件");
                return [];
            }

            let baseDir : String = deviceFileURL.deletingLastPathComponent().path;
            for v in directoryNames {
                var delDir = baseDir;
                delDir += ("/"+v);
                directoryPath.append(delDir);
            }
            return directoryPath;
        }
        return [];
    }

    class func returnValueToShell(string : String) -> String {
        return string;
    }
}

/// 参数数量，必须是：5个，否则提示用法
/// 参数必须正确：打印参数值和用法
///
/// 比如，删除tv所有模拟器相关文件
/// tool -f device_set.plist -a tv

let userHomeDir = NSHomeDirectory();

let deviceFilePath1 = userHomeDir + "/Library/Developer/CoreSimulator/Devices/device_set.plist";
let deviceFilePath2 = userHomeDir + "/Library/Developer/XCTestDevices/device_set.plist";

//if (CommandLine.argc != 5) {
//    Usage.commandUsage(arguments: CommandLine.arguments);
//    exit(-1);
//}
/// 检查参数正确性
//var deviceFilePath = CommandLine.arguments[2];
//var deletedarg = CommandLine.arguments[4];
//if (deviceFilePath.count < 1 || deletedarg.count < 1)
//{
//    Usage.commandUsage(arguments: CommandLine.arguments);
//    exit(-1);
//}
let deviceFileURL1 : URL = URL.init(fileURLWithPath: deviceFilePath1);
let deviceFileURL2 : URL = URL.init(fileURLWithPath: deviceFilePath2);
//if (deviceFileURL == nil)
//{
//    Usage.commandUsage(arguments: CommandLine.arguments);
//    exit(-1);
//}
let plistData1 : Data? = try? Data.init(contentsOf: deviceFileURL1, options: .mappedIfSafe);
let plistData2 : Data? = try? Data.init(contentsOf: deviceFileURL2, options: .mappedIfSafe);
if (plistData1 == nil || plistData2 == nil)
{
    Usage.commandUsage(arguments: CommandLine.arguments);
    print("读取文件数据发生错误");
    exit(-1);
}

/// 解析plist文件内容
let deviceDict1 = try? PropertyListSerialization.propertyList(from: plistData1!, options: .mutableContainers, format: nil);
let deviceDict2 = try? PropertyListSerialization.propertyList(from: plistData2!, options: .mutableContainers, format: nil);
if (deviceDict1 == nil || deviceDict2 == nil)
{
    Usage.commandUsage(arguments: CommandLine.arguments);
    print("解析Plist文件数据出错");
    exit(-1);
}

/// 需要删除的文件路径
var directoryPaths : Array<String> = [];

if let dictInfo : NSDictionary = deviceDict1 as? NSDictionary {
    /// DefaultDevices : {dict}
    /// dict --> com.apple.CoreSimulator.SimRuntime.tvOS-13-0 : {dict}
    /// dict --> com.apple.CoreSimulator.SimDeviceType.Apple-TV-1080p : directoryname
    /// tvOS
    let a1 = AnalysisPlistFile.handlePlistFile(dictInfo: dictInfo, deviceFileURL: deviceFileURL1);
    directoryPaths.append(contentsOf: a1);
}
else {
    Usage.commandUsage(arguments: CommandLine.arguments);
    print("解析Plist文件数据出错");
    exit(-1);
}

if let dictInfo : NSDictionary = deviceDict2 as? NSDictionary {
    /// DefaultDevices : {dict}
    /// dict --> com.apple.CoreSimulator.SimRuntime.tvOS-13-0 : {dict}
    /// dict --> com.apple.CoreSimulator.SimDeviceType.Apple-TV-1080p : directoryname
    /// tvOS
    let a1 = AnalysisPlistFile.handlePlistFile(dictInfo: dictInfo, deviceFileURL: deviceFileURL2);
    directoryPaths.append(contentsOf: a1);
}
else {
    Usage.commandUsage(arguments: CommandLine.arguments);
    print("解析Plist文件数据出错");
    exit(-1);
}

var paths = "";
for (p) in directoryPaths {
    if (paths.count == 0) {
        paths.append(p);
    }
    else {
        paths.append("\n"+p);
    }
}

/// 将内容输出到标准输出
print(paths);
/// 退出程序
exit(0);
