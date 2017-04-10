//
//  EKWCacheSessionManager.swift
//  PlayerTest
//
//  Created by Skye on 2017/4/7.
//  Copyright © 2017年 Skye. All rights reserved.
//

import UIKit
import Alamofire

class EKWCacheSessionManager: NSObject{
    var sessionManager : SessionManager!
    var progressBlock : ((_ progress: Float)->Void)?
    var downloadTaskArray = [EKWDownloadTask]()

    class var sharedManager: EKWCacheSessionManager {
        struct Static {
            static let instance: EKWCacheSessionManager = EKWCacheSessionManager()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
 
        sessionManager = SessionManager.default
    }
    
    func startTask(urlStr: String){
        //目前仅下载一个,暂时这样写(多个下载 可以根据项目需要利用数组管理)
        downloadTaskArray.removeAll()
        if let tempUrl = URL.init(string:urlStr) {
            let sessionRequest = sessionManager.download(tempUrl) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                
                let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let path = "\(documentPath)/test.mp4"
                
                return (URL.init(fileURLWithPath: path), DownloadRequest.DownloadOptions(rawValue: 0))
            }
            
            
            sessionRequest.downloadProgress {[weak self] (progress) in
                print("下载进度progress: \(progress)")
                
                self?.progressBlock?(Float(progress.fractionCompleted))
                
            }
            
            let downLoadTask = EKWDownloadTask.downloadTask(urlStr:"", sessionRequest:sessionRequest)
            downloadTaskArray.append(downLoadTask)
        }
    }
    
    func pauseTask(){
        if let downLoadTask = downloadTaskArray.first{
            downLoadTask.pauseTask()
        }
    }
    
    func resumeTask(){
        if let downLoadTask = downloadTaskArray.first{
            downLoadTask.resumeTask()
        }
    }
    
    
    
}
