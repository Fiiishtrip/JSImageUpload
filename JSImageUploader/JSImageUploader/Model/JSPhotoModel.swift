//
//  JSPhotoModel.swift
//  JSImageUploader
//
//  Created by LJS on 2017/10/12.
//  Copyright © 2017年 Ljs. All rights reserved.
//

import UIKit
import Foundation

public enum downLoadStatus {
    case wait , uploading , pause , finish , faild
}

typealias UpdateUI = (Float) -> Void
typealias StatusBlock = () -> Void


protocol JSPhotoUploadProtocol {
    
    var imageInfo       : UIImage? {set get}
    
    var imageKey        : String {set get}
    
    var process         : Float { set get} //上传的进度
    
    var updateUI        : UpdateUI? {set get}
    
    var statueChange    : StatusBlock? {set get}
    
    var downStatus      : downLoadStatus {set get}
    
}

class JSPhotoModel : JSPhotoUploadProtocol {
    
    fileprivate var _imageInfo : UIImage?
    
    var imageInfo: UIImage? {
        set { _imageInfo = newValue }
        get { return _imageInfo}
        
    }
    
    fileprivate var _imageKey : String = ""
    
    var imageKey : String {
        set {
            _imageKey = newValue
        }
        get {
            return _imageKey
        }
        
    }
    
    fileprivate var _process : Float = 0.0
    
    var process : Float {
        set { _process = newValue }
        get { return _process }
    }
    
    fileprivate var _updateUI : UpdateUI?
    
    var updateUI : UpdateUI? {
        set{ _updateUI = newValue }
        get{ return _updateUI }
    }
    
    
    fileprivate var _statueChange : StatusBlock?
    
    var statueChange : StatusBlock? {
        set{ _statueChange = newValue }
        get{ return _statueChange }
    }
    
    
    fileprivate var _downStatue : downLoadStatus = .finish
    
    var downStatus : downLoadStatus {
        set{
            _downStatue = newValue
            updateDownLoadStatue()
        }
        get{ return _downStatue }
    }
    
    var _errorMsg : String = ""
    
    var errorMsg : String { get { return _errorMsg } }
    
    
    var cancelQiniu = false
    
    //fileprivate var processQiniu : QNUploadOption?
    
    fileprivate var updloader : Operation?
    
    
    
    fileprivate func updateProcess(_ process : Float){
        self.process = process
        if let ui = updateUI{
            ui(process)
        }
    }
    
    fileprivate func updateDownLoadStatue(){
        if let change = statueChange{
            change()
        }
    }
    
    func uploadImage() {
        
        //上传loader已经存在 先取消
        if let _ = updloader {
            cleanUploader()
        }
        
        //七牛上传不中断
        self.cancelQiniu = false
        //队列中等待状态
        self.downStatus = .wait
        //初始化
        
//        processQiniu = QNUploadOption(mime: nil, progressHandler:{ [weak self] (key, process) in
//            self?.updateProcess(process)
//            }, params: nil, checkCrc: false, cancellationSignal: { [weak self] () -> Bool in
//                return (self?.cancelQiniu)!
//        })
        //初始化上传队列容器
        updloader = Operation()
        //容器执行的block
        updloader?.doBlock = { [weak self] in
            
            if let _ = self?.imageInfo {
                //上传中状态...
                self?.downStatus = .uploading
               
                //测试代码s
                
                let timer = Timer(timeInterval: 1, repeats: true, block: { (timer) in
                    self?.process += 0.1
                    print("\(self?.process ?? 0)")
                    self?.updateProcess(self?.process ?? 0)
                    
                    if self?.process ?? 0 > 1 {
                        
                        //上传成功
                        self?.downStatus = .finish
                        //清理资源
                        self?.cleanUploader()
                        timer.invalidate()
                    }
                })
                
                RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
                timer.fire()

                
   
                
                //七牛上传图片
//                QiniuKit.sharedInstance.uploadTaskImage(image,
//                                                        key: imageKey,
//                                                        process: self?.processQiniu,
//                                                        success: { [weak self] (dic) in
//
//                                                            //上传成功
//                                                            self?.downStatus = .finish
//                                                            //清理资源
//                                                            self?.cleanUploader()
//
//                    }, failed: {[weak self] (msg) in
//                        //上传失败
//                        self?.downStatus = .faild
//                        //清理资源
//                        self?.cleanUploader()
//                })
                
                
            }
        }
        //加入队列
        updloader?.addQueue()
    }
    
    //暂停方法
    func pauseUploader() {
        self.downStatus = .pause
        cleanUploader()
    }
    
    //取消上传器 清除资源
    func cleanUploader()  {
        updloader?.cancel()
        cancelQiniu = true
        //processQiniu = nil
        updloader = nil
    }
    
}

