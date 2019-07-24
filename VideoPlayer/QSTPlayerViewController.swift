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
    var playerItem : AVPlayerItem//创建媒体资源管理对象
    var bufferTimeLabel : UILabel!
    
    //滑动条
    lazy var slider : UISlider = { [weak self] in
        let slider = UISlider(frame: CGRect(x: 20, y: 300 + 30, width: (self?.view.frame.width)! - 40, height: 20))
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        return slider
    }()
    
    lazy var loadTimeLabel : UILabel = { [weak self] in
        let loadTimeLabel = UILabel(frame: CGRect(x: 20, y: (self?.slider.frame.maxY)!, width: 100, height: 20))
        loadTimeLabel.text = "00:00:00"
        return loadTimeLabel
    }()
    
    lazy var totalTimeLabel : UILabel = { [weak self] in
        let totalTimeLabel = UILabel(frame: CGRect(x: (self?.slider.frame.maxX)! - 100, y: ((self?.slider.frame.maxY)!), width: 100, height: 20))
        totalTimeLabel.text = "00:00:00"
        return totalTimeLabel
    }()
    
    lazy var pauseButton : UIButton = { [weak self] in
        let button = UIButton(frame: CGRect(x: 20, y: 280, width: 60, height: 30))
        button.setTitle("暂停", for: .normal)
        button.setTitle("播放", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(pauseButtonSelected(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.title = "AVPlayer播放视频"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.slider)
        self.view.addSubview(self.loadTimeLabel)
        self.view.addSubview(self.totalTimeLabel)
        self.view.addSubview(self.pauseButton)
        
        self.playerItem = AVPlayerItem(url: NSURL(string: urlString)! as URL)
        self.player = AVPlayer.init(playerItem: self.playerItem)
        self.player.rate = 1.0//播放速度
        //创建显示视频的图层
        let playerLayer = AVPlayerLayer.init(player: self.player)
        playerLayer.videoGravity =  .resizeAspect
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        //播放
        //self.player.play()
        
        //观察属性当前状态
        self.playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension QSTPlayerViewController {
    //播放进度
    @objc func sliderValueChange(sender:UISlider){
        
    }
    
    //暂停
    @objc func pauseButtonSelected(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.player.pause()
        }else{
            //self.play()
        }
    }
    
    @objc func playToEndTime(){
        print("播放完成")
    }
}
