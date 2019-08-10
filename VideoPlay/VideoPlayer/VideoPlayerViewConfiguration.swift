//
//  VideoPlayerViewConfiguration.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/7/29.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import AVFoundation


enum videoPlayerGestureType: Int {
    case videoPlayerGestureTypeProgress = 0//视频进度调节操作
    case videoPlayerGestureTypeVoice = 1//声音调节操作
    case videoPlayerGestureTypeLight = 2//屏幕亮度调节操作
    case videoPlayerGestureTypeNone = 3//无任何操作
}
enum videoPlayerPlayType: Int {
    case videoPlayTypeReplay = 0 //重复播放
    case videoPlayTypeOrder = 1  //顺序播放
    case videoPlayTypeRandom = 2  //随机播放
    case videoPlayTypeOnce = 3  //仅播放一次
}



class VideoPlayerViewConfiguration: NSObject {
//主色调
    var mainColor: UIColor
    //* 设置自动隐藏面板时间，默认5秒为0 时关闭自动隐藏功能
    var autoHideTime : CGFloat
    //设置播放类型，默认为重复播放
    var playType : videoPlayerPlayType
     //视频的显示模式，默认按原视频比例显示i，多余两边留黑
    var videoGravity : AVLayerVideoGravity
     //返回标题文字，默认 正在播放
    var backString : NSString
    // 是否用视频第一帧显示为占位背景，默认NO
    var haveFirstImage : Bool
    // 是否使用手势控制音量和亮度，默认yes
    var enableVolumeGesture : Bool
    /* 是否使用手势控制音量和亮度 */
    var playProgressGesture : Bool
    /** 是否允许横竖屏，默认yes */
    var canHorizontalOrVerticalScreen : Bool
    /** 是否打开重力感应，默认yes */
    var openGravitySensing : Bool
    /** 手势滑动触发的最小距离，默认3 */
    var gestureSliderMinx : CGFloat
    /** 播放器状态 */
    var state : VPPlayerState
    //视频总时间
    var totalTime : CGFloat?
    //视频地址
    var url : Any?
    //视频第一帧图片
    var videoImage : UIImage
    /*判断当前的状态是否显示为全屏*/
    var fullStreen : Bool?
    //用来判断手势是否移动过
    var hasMoved : Bool
    //记录touch开始的点
    var touchBeginPoint : CGPoint?
    //记录触摸开始的音量
    var touchBeginVoiceValue : CGFloat?
    //手势控制的类型 判断当前手势是在控制进度，声音，亮度
    var gestureType : videoPlayerGestureType?
    
    
    
    override init() {
        self.mainColor = PLAYER_UIColorFromHEXA(hex: 0xFF1437, alpha: 1)
        self.haveFirstImage = false
        self.enableVolumeGesture = true
        self.videoGravity = AVLayerVideoGravity.resizeAspect
        self.autoHideTime = 5.0
        self.playType = videoPlayerPlayType.init(rawValue: 0)!
        self.backString = "正在播放"
        self.canHorizontalOrVerticalScreen = true
        self.openGravitySensing = true
        self.playProgressGesture = true
        self.gestureSliderMinx = 3;
        self.state = VPPlayerState.init(rawValue: 0)!
        self.hasMoved = false
        self.videoImage = PLAYER_GET_BUNDLE_IMAGE(imageName: "kj_player_background")
    }
    
    
    
    
    
 
    

}
