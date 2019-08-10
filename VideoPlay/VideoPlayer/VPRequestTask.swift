//
//  VPRequestTask.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/8/9.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit

class VPRequestTask: NSObject {
    var url : URL! //视频地址
    var currentOffset : UInt//当前偏移量
    var downLoadOffset : Int //下载偏移量
    var videoLength : UInt //视频长度
    var completed : Bool //是否下载完成
    var taskTemps : NSMutableArray
    var tempPath : String //临时缓存文件路径
    var fileHandle : FileHandle? //此类主要是对文件内容进行读取和写入操作
    
    /** 当接收到服务器响应的时候调用 返回视频长度 videoLength */
    var requestTaskDidReceiveVideoLengthBlock : (task : VPRequestTask, videoLength : UInt)?
    /** 当接收到数据的时候调用，该方法会被调用多次 返回接收到的服务端二进制数据 NSData */
    var requestTaskDidReceiveDataBlock : (task : VPRequestTask, data : Data)?
    /** 当服务端返回的数据接收完毕之后会调用 */
    var requestTaskDidFinishLoadingAndSaveFileBlcok : (task : VPRequestTask, saveSuccess : Bool)?
    /** 当请求错误的时候调用
     *  errorCode
     */
    var requestTaskdidFailWithErrorCodeBlcok : (task : VPRequestTask, errorCode : UInt)?
    
    override init() {
        self.completed = false
        self.downLoadOffset = 0
        self.videoLength = 0
        self.taskTemps = NSMutableArray.init()
        self.currentOffset = 0
        let document : String = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString) as String
        self.tempPath = URL(fileURLWithPath: document ).appendingPathComponent("videoTemp.mp4").absoluteString
        //为什么要移除再创建？？？
        if FileManager.default.fileExists(atPath: self.tempPath) {
            do {
                try FileManager.default.removeItem(atPath: self.tempPath)
                FileManager.default.createFile(atPath: self.tempPath, contents: nil, attributes: nil)
            }catch {
                print("removeItem Error")
            }
        } else {
            FileManager.default.createFile(atPath: self.tempPath, contents: nil, attributes: nil)
        }
    }
    func config() {
        self.completed = false
        self.downLoadOffset = 0
        self.videoLength = 0
    }
    public func startLoadWithUrl(url : URL, offst : UInt) {
        self.url = url
        self.currentOffset = offst
        
        //如果建立第二次请求，先移除原来文件，再创建新的
        if self.taskTemps.count >= 1 {
            do {
                try FileManager.default.removeItem(atPath: self.tempPath)
                FileManager.default.createFile(atPath: self.tempPath, contents: nil, attributes: nil)
            }catch {
                print("removeItem Error")
            }
        }
        self.config()
        //开始网络请求
        
    }
    public func cancelLoading() {
        //取消网络请求
        
    }
    private func startUrlRequestWithOffset(offset : UInt) {
        var request = URLRequest(url: self.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        if offset > 0 && self.videoLength > 0 {
            request.addValue(String.init(format: "bytes=%ld-%ld", offset,  self.videoLength - 1), forHTTPHeaderField: "Range")
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            self.fileHandle?.seekToEndOfFile()//跳到文件末尾
            self.fileHandle?.write(data!)//写入数据
            self.downLoadOffset += NSData.init(data: data!).length
            self.requestTaskDidReceiveDataBlock(self, data)
        }
        dataTask.resume()
    }

}
