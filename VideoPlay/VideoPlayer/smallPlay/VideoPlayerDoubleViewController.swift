//
//  VideoPlayerDoubleViewController.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/7/23.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerDoubleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "AVPlayerViewController"
        self.navigationController?.navigationItem.title = "AVPlayerViewController"
        
        let player = AVPlayer(url: NSURL(string: urlString)! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        //添加view播放的模式
        playerViewController.view.frame = CGRect(x: 20, y: 100, width: self.view.bounds.width - 40, height: 200)
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)

        // Do any additional setup after loading the view.
    }
    func test() {
        
    }
    


}
