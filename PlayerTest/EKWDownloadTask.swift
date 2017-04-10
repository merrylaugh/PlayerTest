//
//  EKWDownloadTask.swift
//  PlayerTest
//
//  Created by Skye on 2017/4/10.
//  Copyright © 2017年 Skye. All rights reserved.
//

import UIKit
import Alamofire

class EKWDownloadTask: NSObject {
    var sessionRequest: DownloadRequest?
    var urlStr: String?
    
    class func downloadTask(urlStr:String, sessionRequest: DownloadRequest) -> EKWDownloadTask{
        let task = EKWDownloadTask()

        task.urlStr = urlStr
        task.sessionRequest = sessionRequest
        
        return task
    }
    
    func pauseTask(){
        sessionRequest?.suspend()
    }
    
    func cancleTask(){
        sessionRequest?.cancel()
    }
    
    func resumeTask(){
        sessionRequest?.resume()
    }
}
