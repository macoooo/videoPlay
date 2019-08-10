//
//  GlobalConst.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/8/8.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import Foundation
import UIKit

//屏幕尺寸
let PLAYER_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let PLAYER_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//颜色
func PLAYER_UIColorFromHEXA(hex: Int, alpha: CGFloat) -> UIColor {
    
    let redValue = CGFloat((hex & 0xFF0000) >> 16)/255.0
    let greenValue = CGFloat((hex & 0xFF00) >> 8)/255.0
    let blueValue = CGFloat(hex & 0xFF)/255.0
    return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
}
//设置图片
func PLAYER_GET_BUNDLE_IMAGE(imageName : String) -> UIImage {
    let x : NSString = "KJPlayerView.bundle"
    let name : String = x.appendingPathComponent(imageName)
    return UIImage.init(named: name)!
}
//设置字体
func PLAYER_SystemFontSize(fontsize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontsize)
}
//粗体
func PLAYER_SystemBlodFontSize(fontsize : CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontsize)
}
//text size(文字尺寸)
//func PLAYER_MULTILINE_TEXTSIZE(text : String, font : UIFont, maxSize : )

