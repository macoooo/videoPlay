//
//  VPPlayerView.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/8/9.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit

class VPPlayerView: UIView, VPPlayerDelagate {
    
    
    var configuration : VideoPlayerViewConfiguration?
    
    lazy var contentView : UIView = { [weak self] in
        let contentView = UIView.init(frame: self!.bounds)
        return contentView
    }()
    
    
    init(frame: CGRect, configuration : VideoPlayerViewConfiguration) {
        super.init(frame: frame)
        self.configuration = configuration
        self.config()
    }
    //必要初始化器
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config() {
        
    }
    
    
 
}
extension VPPlayerView {
    func playerCurrentState(player: VPPlayer, state: VPPlayerState, errCode: VPPlayerErrorCode) {
        
    }
    
    func playerProgress(player: VPPlayer, progress: CGFloat, currentTime: CGFloat, durationTime: CGFloat) {
        
    }
    
    func playerFinishCache(player: VPPlayer, loadedProgress: CGFloat, loadComplete: Bool, saveSuccess: Bool) {
        
    }
}

