//
//  VideoPlayView.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/7/29.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayView: UIView {
    
    //滑动条
    lazy var slider : UISlider = { [weak self] in
        let slider = UISlider(frame: CGRect(x: 20, y: 0, width: (self?.frame.width)! - 40, height: 20))
        //slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        return slider
        }()
    
    //可以设置许多属性
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
        button.setTitle("播放", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        //button.addTarget(self, action: #selector(pauseButtonSelected(sender:)), for: .touchUpInside)
        return button
        }()
    
    lazy var bottomToolView : UIImageView =
        { [weak self] in
            let bottomToolView = UIImageView(frame: CGRect(x: 0, y: 0, width: (self?.frame.width)!, height: 40))
            bottomToolView.backgroundColor = UIColor.init(red: 50, green: 50, blue: 50, alpha: 0.5)
            bottomToolView.autoresizingMask =  UIView.AutoresizingMask.flexibleWidth
            return bottomToolView
            }()
    
//    lazy var doubleTap : UITapGestureRecognizer = {
//        [weak self] in
//        //let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.numberOfTouchesRequired = 1
//        return doubleTap
//        }()
//
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.loadTimeLabel)
        self.addSubview(self.totalTimeLabel)
        self.addSubview(self.bottomToolView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
