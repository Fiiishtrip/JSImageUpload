//
//  ImageUpload.swift
//  Hunter
//
//  Created by LJS on 2017/4/27.
//  Copyright © 2017年 fishtrip. All rights reserved.
//

import Foundation

@objc open class Operation: Foundation.Operation {
    
    var doBlock : (() -> Void)?  //任务执行的块
    
    
    fileprivate var _executing = false
    //重写系统的正在执行中标记
    override open var isExecuting: Bool {
        
        get { return self._executing }
        
        set {
                self.willChangeValue(forKey: "isExecuting")
            
                self._executing = newValue
            
                self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    
    fileprivate var _finished = false
    //重写系统的执行完毕标记
    override open var isFinished: Bool {
        
        get { return self._finished }
        
        set {
            
            // * 为了防止未执行的任务 改变状态（ *** 会造成crash）
            if self._executing {
                
                self.willChangeValue(forKey: "isFinished")
                
                self._finished = newValue
                
                self.didChangeValue(forKey: "isFinished")
                
            }
        }
    }
    
    //把任务加入队列中
    open func addQueue() {
        
        HOperationQueue.defaultCenter().addQueue(self)
        
    }
    
    //开始执行任务方法
    override open func start() {
        
        //如果任务已经被取消
        if self.isCancelled {
            
            //把任务设置为完成状态 (队列会此任务从队列中移除)
            self._executing = true
            
            self.isFinished = true
            
            return
        }else{
            
            //开始执行任务
            self.isExecuting = true
            
            //执行操作块
            if let block = doBlock{
                
                // * 块执行结束后 要把finish = true 完成任务
                block()
                
            } else {
                
                //没有可执行的块 结束任务
                self.isFinished = true
                
            }
            
        }
        
    }
    
    //取消队列
    override open func cancel() {
        
        self.isFinished = true
        super.cancel()
        
    }
    
}
