//
//  VPPlayer.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/8/7.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import AVFoundation



enum VPPlayerState : Int {
    case playerStateLoading = 1 // 加载中 缓存数据
    case playerStatePlaying = 2 // 播放中
    case playerStatePlayerEnd = 3 //播放结束
    case playerStateStopped = 4 //停止
    case playerStatePause = 5 //暂停
    case playerStateError = 6 //播放错误
}
enum VPPlayerErrorCode : Int {
    case playerErrorCodeNoError = 0 // 正常播放
    case playerErrorCodeOtherSituations = 1;//其他情况
    case playerErrorCodeVideoUrlError = 100 //视频地址不正确
    case playerErrorCodeNetWorkOverTime = -1001 //请求超时
    case playerErrorCodeSeverNotFound = -1003//找不到服务器
    case playerErrorCodeSeverInternalError = -1004 //服务器内部错误
    case playerErrorCodeNetWorkInterruption = -1005 //网络中断
    case playerErrorCodeNetWorkNoConnection = -1009 //无网络连接
}
protocol VPPlayerDelagate {
    //当前播放器状态
    func playerCurrentState(player : VPPlayer, state : VPPlayerState, errCode : VPPlayerErrorCode)
    //播放进度
    func playerProgress(player : VPPlayer, progress : CGFloat, currentTime : CGFloat, durationTime : CGFloat)
    //缓存完成
    func playerFinishCache(player : VPPlayer, loadedProgress : CGFloat, loadComplete : Bool,saveSuccess : Bool)

    
}

class VPPlayer: NSObject {
    
    var videoPlayer : AVPlayer?
    var videoPlayerLayer : AVPlayerLayer?
    /* 视频第一帧图片 */
    var videoFirstImage : UIImage?
    /* 视频总时间 */
    var videoTotalTime : CGFloat!
    /*是否为本地资源 */
    var videoIsLocalityData : Bool
    /*进入后台是否停止播放，默认yes */
    var stopWhenAppEnterBackground : Bool
    /*是否需要显示第一帧图片,默认no */
    var needDisplayFirstImage : Bool
    /*委托 */
    weak var delegate : VPPlayerDelagate?
    
    /******事件处理******/
    var playerStateBlock : (player : VPPlayer, state : VPPlayerState, errCode : VPPlayerErrorCode)
    
    var playerLoadingBlock : (player : VPPlayer, loadedProgress : CGFloat, complete : Bool, saveSuccess : Bool)
    
    var playerPlayProgressBlock : (player : VPPlayer, progress : CGFloat, currentTime : Bool, durationTime : Bool)
    
    var playerItem : AVPlayerItem!
    var state : VPPlayerState
    var errCode : VPPlayerErrorCode
    var current : CGFloat
    var progress : CGFloat
    var loadedProgress : CGFloat
    //var playerURLConnection :
    
    
    
    
    //单例
    private static let sharedInstance = VPPlayer()
    class func shareManager() -> VPPlayer {
        return sharedInstance
    }
    override private init() {
        
    }
    func setNotificationAndKvo() {
        //观察属性当前状态
        self.playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        //缓存区间，可用来获取缓存了多少
        self.playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        //缓存不够了 自动暂停播放
        self.playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)//缓存好了，手动播放
        
        //通知
        
    }
    
    

}
