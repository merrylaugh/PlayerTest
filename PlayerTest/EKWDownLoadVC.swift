//
//  EKWDownLoadVC.swift
//  PlayerTest
//
//  Created by Skye on 2017/4/10.
//  Copyright © 2017年 Skye. All rights reserved.
//

import UIKit

class EKWDownLoadVC: UIViewController {
    @IBOutlet weak var downLoadProgressView: UIProgressView!

    @IBOutlet weak var progressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        downLoadProgressView.progress = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickStartDownLoadButton(_ sender: Any) {
        
        EKWCacheSessionManager.sharedManager.startTask(urlStr: "http://cdn-ekwing-oss.ekwing.com/acpf/data/upload/base/2017/03/23/58d34327c24f1.mp4")
        
        EKWCacheSessionManager.sharedManager.progressBlock = {[weak self] (progress) in
            self?.downLoadProgressView.progress = progress
            self?.progressLabel.text = "\(progress)"
            
        }
    }

    @IBAction func onClickPauseDownloadButton(_ sender: Any) {
        EKWCacheSessionManager.sharedManager.pauseTask()
    }
    
    @IBAction func onClickResumeDownloadButton(_ sender: Any) {
        EKWCacheSessionManager.sharedManager.resumeTask()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
