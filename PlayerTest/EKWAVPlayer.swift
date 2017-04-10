//
//  EKWAVPlayer.swift
//  PlayerTest
//
//  Created by Skye on 2017/4/7.
//  Copyright © 2017年 Skye. All rights reserved.
//

import UIKit
import AVFoundation

class EKWAVPlayer: NSObject {

    var player : AVPlayer?
    var totalTimeForCurrentItem : Float64 = 0
    var timeObserve : Any?
    var progressBolok : ((_ progress: Float, _ currentTimeStr:String, _ totalTimeStr: String) -> Void)?
    
    override init() {
        super.init()
        
        initializeAVPlayer()
    }
    
    deinit {
        removeObserver(playItem: player?.currentItem)
        timeObserve = nil
    }
    
    private func initializeAVPlayer(){
        player = AVPlayer.init()
        
        
        
        addProgressObserver()
    }
    
    //给播放器添加进度更新
    func addProgressObserver(){
        //这里设置每秒执行一次.
        timeObserve =  player?.addPeriodicTimeObserver(forInterval: CMTimeMake(Int64(1.0), Int32(1.0)), queue: DispatchQueue.main) { [weak self](time: CMTime) in
            guard let strongSelf = self else { return }

            //CMTimeGetSeconds函数是将CMTime转换为秒，如果CMTime无效，将返回NaN
            let currentTime = CMTimeGetSeconds(time)
            let totalTime = strongSelf.totalTimeForCurrentItem
            //更新显示的时间和进度条
            let currentTimeStr = strongSelf.formatPlayTime(seconds: currentTime)
            let totalTimeStr = strongSelf.formatPlayTime(seconds: totalTime)
            debugPrint("progress = \(Float(currentTime/totalTime))")
            
            strongSelf.progressBolok?(Float(currentTime/totalTime), currentTimeStr, totalTimeStr)
        }
    }
    
    //给AVPlayerItem、AVPlayer添加监控
    func addObserver(playItem:AVPlayerItem?){
        if let playerItem = playItem{
            //为AVPlayerItem添加status属性观察，得到资源准备好，开始播放视频
            playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            //监听AVPlayerItem的loadedTimeRanges属性来监听缓冲进度更新
            playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }
    
    //去除观察者
    func removeObserver(playItem:AVPlayerItem?){
        if let playerItem = playItem{
            playerItem.removeObserver(self, forKeyPath: "status")
            playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
            NotificationCenter.default.removeObserver(self, name:  Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }
 
    //MARK:---public
    
    //MARK:播放
    //本地url
    func playItem(localUrlStr:String) {
        let item = AVPlayerItem.init(url: URL.init(fileURLWithPath: localUrlStr))
        playItem(item: item)
    }
    
    //远程URL
    func playItem(remoteUrlStr:String) {
        if let url = URL.init(string: remoteUrlStr){
            let item = AVPlayerItem.init(url:url)
            playItem(item: item)
        }else{
            debugPrint("无效的remoteUrlStr")
        }
    }
    
    private func playItem(item:AVPlayerItem){
        if let currentItem = player?.currentItem {
            removeObserver(playItem: currentItem)
        }
        
        player?.replaceCurrentItem(with: item)
        addObserver(playItem: item)
    }
   
    //播放当前
    func playCurrentItem(){
        player?.play()
    }
    
    //MARK: 暂停
    func pauseCurrentItem() {
        player?.pause()
    }
    
    //MARK:改变播放速率
    func changePlayerRate(newRate:Float){
        let currentRate = player?.rate
        if currentRate != newRate {
            player?.rate = newRate
        }
    }
    
    //MARK: 快进快退
    
    func test(){
//        player.seek
    }
    

    ///  通过KVO监控播放器状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? AVPlayerItem  else { return }
        guard let keyPath = keyPath else { return }
        if keyPath == "status"{
            if object.status == .readyToPlay{ //当资源准备好播放，那么开始播放视频
                player?.play()
                totalTimeForCurrentItem = CMTimeGetSeconds(object.duration)
            }else if object.status == .failed || object.status == .unknown{
                print("播放出错")
            }
        }else if keyPath == "loadedTimeRanges"{
            let loadedTime = avalableDurationWithplayerItem()
            print("当前加载进度\(loadedTime)")
        }
    }
    
    //将秒转成时间字符串的方法，因为我们将得到秒。
    func formatPlayTime(seconds: Float64)->String{
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    //计算当前的缓冲进度
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = player?.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        //本次缓冲时间范围
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)//本次缓冲起始时间
        let durationSecound = CMTimeGetSeconds(timeRange.duration)//缓冲时间
        let result = startSeconds + durationSecound//缓冲总长度
        
        return result
    }
    
    //播放结束，回到最开始位置
    func playerItemDidReachEnd(notification: Notification){
        player?.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    
}
