//
//  EKWNetworkReachabilityManager.swift
//  PlayerTest
//
//  Created by Skye on 2017/4/7.
//  Copyright © 2017年 Skye. All rights reserved.
// 网络变化相关处理

import UIKit
import Alamofire

class EKWNetworkReachabilityManager: NSObject {

    var reachabilityManager: NetworkReachabilityManager?
    
    func registerNerWork() {
        reachabilityManager = NetworkReachabilityManager.init()
        reachabilityManager?.listener =  { status in
            
            if status == .notReachable {
                
            }else if status == .unknown {
                
            }else if status == .reachable(.ethernetOrWiFi){
                
            }else if status == .reachable(.wwan){
                
            }
            
            debugPrint("Network Status Changed: \(status)")
            
        }
        
        reachabilityManager?.startListening()
    }
}
