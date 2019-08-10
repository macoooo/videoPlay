//
//  VPPlayerTool.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/7/31.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import AVFoundation
import CommonCrypto
import Foundation

//你定义的vedio对应的文件目录
let DOCUMENTS_FOLDER_VEDIO : String = "playerVedio"
class VPPlayerTool: NSObject {
    //判断是否含有视频轨道(判断视频是否可以正常播放)
    func playerHaveTracksWithURL(url : URL) -> Bool {
        let asset : AVURLAsset = AVURLAsset.init(url: url, options: nil)
        let track : [AVAssetTrack] =  asset.tracks(withMediaType: AVMediaType.video)
        let hasVideoTrack : Bool = track.count > 0
        return hasVideoTrack
    }
    // 判断是否是URL
    func playerIsURL(url : URL) -> Bool {
        if url.absoluteString.count == 0 {
            return false
        }
        let string : String = url.absoluteString
        let urlRegex : String = "(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}"
        let urlTest : NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", urlRegex)
        return urlTest.evaluate(with: string)
        
    }
    //判断url地址是否可用,下载
    func playerValidateUrl(url : URL, completionHandler: @escaping (_ success: Bool) -> ()) {
        var request : URLRequest = .init(url: url)
        request.httpMethod = "HEAD"
        let session : URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
        let task : URLSessionDataTask =  session.dataTask(with: request) { (data: Data?,urlResponse : URLResponse?,error : Error?) in
            completionHandler((error != nil))
        }
        task.resume()
    }
    //md5加密
    func playerMD5WithString(string : String) -> String {
        var origin_str = string.utf8
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen);
        //UnsafeRawPointer指针操作
        CC_MD5(UnsafeRawPointer(&origin_str), CC_LONG(strlen(string)), result);
        let i = 0
        let outPutStr : NSMutableString = .init(capacity: 10)
        while i < CC_MD5_DIGEST_LENGTH {
            outPutStr.appendFormat("%02X", result[i])
        //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
        }
        return outPutStr.lowercased
    }
    //根据url得到完整路径
    func playerGetIntegrityPathWithUrl(url : URL) -> String {
        let doucument = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString) as String
        let videoPath = URL(fileURLWithPath: doucument ).appendingPathComponent(DOCUMENTS_FOLDER_VEDIO)
        //判断存放视频的文件夹是否存在，不存在则创建对应文件夹
        self.playerCreateFileDirectoriesWithPath(path: videoPath.absoluteString)
        let urlString : String = url.absoluteString
        //分割字符串
        let array : Array = urlString.components(separatedBy: "://")
        let name : String = array.count > 1 ? array[1] : urlString
        //去掉：//之前的数据
        //加密名字
        let md5Name : String = self.playerMD5WithString(string: name)
        let videoName : String = "\(md5Name)\(".mp4")"
        let filePath : String = (videoPath.appendingPathComponent(videoName).absoluteString)
        
        return filePath
    }
    //判断存放视频的文件夹是否存在，不存在则创建对应文件夹
    func playerCreateFileDirectoriesWithPath(path : String) -> Bool {
        let fileManager : FileManager = .default
        var isDir : ObjCBool = false
        let isDirExist = fileManager.fileExists(atPath: path, isDirectory:&isDir)
        if !(isDirExist && isDir.boolValue) {
            do{
               try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Create vedio Directory Failed.")
                return false
            }
        }
        return true
    }
    //获取视频第一帧图片
    func firstImageWithURL(url : URL) -> UIImage {
        //初始化视频媒体文件
        let asset : AVURLAsset = .init(url: url as URL, options: nil)
        let assetGen : AVAssetImageGenerator = AVAssetImageGenerator.init(asset: asset)
        assetGen.appliesPreferredTrackTransform = true
        let time : CMTime = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        //let error : NSError? = nil
        let actualTime = UnsafeMutablePointer<CMTime>.allocate(capacity: 10)
        var image : CGImage? = nil
        //获取视频第一帧图片
        do{
            image = try assetGen.copyCGImage(at: time, actualTime: actualTime)
        }catch {
            print("image视频第一帧没取到")
        }
        let videoImage : UIImage = .init(cgImage: image!)
        return videoImage
    }
    //获取视频总时间
    func videoTotalTimeWithURL(url : URL) -> NSInteger {
        //不理解
        let options : NSDictionary = .init(object: false, forKey: AVURLAssetPreferPreciseDurationAndTimingKey as NSCopying)//指示asset是否应准备好指示精确的持续时间并按时间提供精确的随机访问。

        //初始化音频文件
        let asset : AVURLAsset = .init(url: url as URL, options: options as? [String : Any])
        
        let x : Double = Double(asset.duration.value)
        let y : Double = Double(asset.duration.timescale)
        let seconds : NSInteger = NSInteger(ceil(x / y))
        return seconds
    }
    //设置时间显示
    func playerConvertTime(second : CGFloat) -> String {
        let date : Date = .init(timeIntervalSince1970: TimeInterval(second))
        let dateFormatter : DateFormatter = .init()
        dateFormatter.timeZone = TimeZone.init(identifier: "GMT")
        if second / 3600 >= 1 {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "mm:ss"
        }
        return dateFormatter.string(from: date)
    }
    //获取当前的旋转状态
    func playerCurrentDeviceOrientation() -> CGAffineTransform {
        //状态条的方向已经设置过，所以这个就是i你想要旋转的方向
        let orientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        //根据要进行旋转的方向来计算旋转的角度
        if orientation == UIInterfaceOrientation.portrait {
            return CGAffineTransform.identity
        } else if orientation == UIInterfaceOrientation.landscapeLeft {
            return CGAffineTransform(rotationAngle:-.pi / 2)
        } else if orientation == UIInterfaceOrientation.landscapeRight {
            return CGAffineTransform(rotationAngle:.pi / 2)
        }
        return CGAffineTransform.identity
    }
}


