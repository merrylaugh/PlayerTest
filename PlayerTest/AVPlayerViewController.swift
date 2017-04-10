//
//  AVPlayerViewController.swift
//  PlayerTest
//
//  Created by Skye on 2017/4/7.
//  Copyright © 2017年 Skye. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerViewController: UIViewController {

    @IBOutlet weak var progressTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let avplayer : EKWAVPlayer = EKWAVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let playerLayer = AVPlayerLayer.init(player: avplayer.player)
        playerLayer.frame = CGRect.init(x: 0, y: 350, width: self.view.frame.width, height: 200)
        view.layer.addSublayer(playerLayer)
        
        progressView.progress = 0
        
        avplayer.progressBolok = { [weak self] (progress, currentTimeStr, totalTimeStr) in
            guard let strongSelf = self else { return }
            
            strongSelf.progressView.progress = Float(progress)
            strongSelf.progressTimeLabel.text = "\(currentTimeStr)|\(totalTimeStr)"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit")
    }
    
    
    @IBAction func onClickOnLineButton(_ sender: Any) {
        avplayer.playItem(remoteUrlStr: "http://cdn-ekwing-oss.ekwing.com/acpf/data/upload/base/2017/03/23/58d34327c24f1.mp4")
    }
  
    @IBAction func onCLickOffLineButton(_ sender: Any) {
        //获取本地视频资源
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = "\(documentPath)/test.mp4"
        
        avplayer.playItem(localUrlStr: path)
    }
    
    @IBAction func onClickPauseButton(_ sender: Any) {
        avplayer.pauseCurrentItem()
    }
    
    
    @IBAction func onClickSlowButton(_ sender: Any) {
        avplayer.changePlayerRate(newRate: 0.5)
    }
    
    @IBAction func onCLickContinueButton(_ sender: Any) {
        avplayer.playCurrentItem()
    }

    @IBAction func onClickNormalButton(_ sender: Any) {
        avplayer.changePlayerRate(newRate: 1.0)
    }
    
    @IBAction func onClickQuickButton(_ sender: Any) {
        avplayer.changePlayerRate(newRate: 1.5)
    }
    
}

