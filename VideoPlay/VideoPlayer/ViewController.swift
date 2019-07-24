//
//  ViewController.swift
//  VideoPlayer
//
//  Created by 强淑婷 on 2019/7/23.
//  Copyright © 2019 强淑婷. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

let urlString = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let dataSource = ["AVPlayer", "AVPlayerViewController"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView .register(UITableViewCell.self, forCellReuseIdentifier: "playerCell")
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "playerCell")
        if !(cell != nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "playerCell")
        }
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            let playerViewController = VideoPlayerDoubleViewController()
            print(playerViewController.navigationController)
            NSLog("self.navigationController=\(String(describing: self.navigationController))")
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }
    }


}

