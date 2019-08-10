//
//  QSTPlayerViewController.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/7/23.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import AVKit


class QSTPlayerViewController: UIViewController {
    
    var player : AVPlayer!//负责视频播放
    var playerItem : AVPlayerItem! //创建媒体资源管理对象，提供播放数据源
    var bufferTimeLabel : UILabel!
    var doubleTapFlag = true
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.title = "AVPlayer播放视频"
        self.view.backgroundColor = UIColor.white
        
        
        self.playerItem = AVPlayerItem(url: NSURL(string: urlString)! as URL)
        self.player = AVPlayer.init(playerItem: self.playerItem)
        
        self.player.rate = 1.0//播放速度 播放前设置
        //创建显示视频的图层,如果没有添加该类，只有声音，没有画面
        let playerLayer = AVPlayerLayer.init(player: self.player)
        //设置画面播放
        playerLayer.videoGravity =  .resizeAspect//按原比例
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300)
        self.view.layer.addSublayer(playerLayer)
        
        
        //观察属性当前状态
        self.playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        //缓存区间，可用来获取缓存了多少
        self.playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        //缓存不够了 自动暂停播放
        self.playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)//缓存好了，手动播放
        //通知
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        //实时的获取播放时长和控制进度条
        //value 帧数 - timescale帧率
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) {
            [weak self](time) in
            //当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            //视频总时间
            let totalTime = CMTimeGetSeconds((self?.player.currentItem?.duration)!)
            //滑块进度
            //self?.slider.value = Float(loadTime / totalTime)
            //self?.loadTimeLabel.text = self?.changeTimeFormatt(timeINterval: loadTime)
            //self?.totalTimeLabel.text = self?.changeTimeFormatt(timeINterval: CMTimeGetSeconds((self?.player.currentItem?.duration)!))
        }
    }
    deinit {
        self.playerItem.removeObserver(self, forKeyPath: "status", context: nil)
        self.playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        self.playerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
        self.playerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        NotificationCenter.default.removeObserver(self)
    }

        // Do any additional setup after loading the view.

}
extension QSTPlayerViewController {
    //KVO观察
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch self.playerItem.status {
            case .unknown:
                print("unknown")
            case .readyToPlay:
                self.play()
            case .failed:
                print("failed")
            @unknown default: break
            }
        } else if keyPath == "loadedTimeRanges" {
            let loadTimeArray = self.playerItem.loadedTimeRanges
            //获取最新缓存区间
            let newTimeRange : CMTimeRange = loadTimeArray.first as! CMTimeRange
            let startSeconds = CMTimeGetSeconds(newTimeRange.start)
            let durationSeconds = CMTimeGetSeconds(newTimeRange.duration)
            let totalBuffer = startSeconds + durationSeconds;//缓存总长度
            print("当前缓冲时间: %f", totalBuffer)
        } else if keyPath == "playbackBufferEmpty" {
            print("正在缓存视频请稍等")
        } else if keyPath == "playbackLikelyToKeepUp" {
            print("缓存好了继续播放")
            self.player.play()
        }
    }
    
    //播放
    func play() {
        self.player.play()
    }
    //播放进度
    @objc func sliderValueChange(sender:UISlider){
        if self.player.status == .readyToPlay {
            let time = Float64(sender.value) * CMTimeGetSeconds((self.player.currentItem?.duration)!)
            let seekTime = CMTimeMake(value: Int64(time), timescale: 1)
            self.player.seek(to: seekTime)
        }
        
    }
    
    //暂停
    @objc func pauseButtonSelected(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.player.pause()
        }else{
            self.play()
        }
    }
    
    @objc func playToEndTime(){
        print("播放完成")
    }
    //转时间格式
    func changeTimeFormatt(timeINterval: TimeInterval) -> String {
        return String(format: "%02d:%02d:%02d", (Int(timeINterval) % 3600) / 60, Int(timeINterval) / 3600, Int(timeINterval) % 60)
    }
    @objc func handleDoubleTap() {
        doubleTapFlag = !doubleTapFlag
        if doubleTapFlag {
            self.play()
        } else {
            self.player.pause()
        }
    }
}
