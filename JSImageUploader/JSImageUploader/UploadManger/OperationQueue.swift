//
//  ImageUploadManger.swift
//  Hunter
//
//  Created by LJS on 2017/4/27.
//  Copyright © 2017年 fishtrip. All rights reserved.
//
import Foundation

class HOperationQueue: NSObject {
    
    //队列
    fileprivate var _queue: Foundation.OperationQueue!
    
    //单例
    fileprivate struct Singletone {
        
        static let defaultCenter = HOperationQueue()
        
    }
    
    //类方法 返回单例
    internal class func defaultCenter() -> HOperationQueue {
        
        return Singletone.defaultCenter
        
    }
    
    override init() {
        super.init()
        
        //初始化队列
        self._queue = Foundation.OperationQueue()
        
        //最大并行数 ( = 1 为串行)
        self._queue.maxConcurrentOperationCount = 2
        
    }
    
    //把任务加入队列中
    internal func addQueue(_ object : Operation){
        
        self._queue.addOperation(object)
        
    }
    
    //取消所有任务
    internal func cancelAllOperations() {
        
        for operation in self._queue.operations {
            
            operation.cancel()
            
        }
        
    }

}
