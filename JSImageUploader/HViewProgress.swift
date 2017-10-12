//
//  HViewProgress.swift
//  Hunter
//
//  Created by LJS on 2017/4/28.
//  Copyright © 2017年 fishtrip. All rights reserved.
//
import UIKit

let SDProgressViewItemMargin = 10

class HViewProgress: UIView {
    
    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
        
    }
    
    enum ProgressType {
        case pause , loading , error , wait
    }
    
    fileprivate var _viewType : ProgressType = .loading
    
    var viewType : ProgressType {
        set {
            _viewType = newValue
            self.setNeedsDisplay()
        }
        get { return _viewType }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        guard let ctx = context else {
            return
        }
        
        let xCenter = rect.size.width * 0.5
        let yCenter = rect.size.height * 0.5
        
        
        let radius = min(rect.size.width * 0.5, rect.size.height * 0.5) -  CGFloat(SDProgressViewItemMargin)
        
        // 背景遮罩
        UIColor.colorFromHex(0xf0f0f0, alpha: 0.9).set()
        let lineW = max(rect.size.width, rect.size.height) * 0.5
        ctx.setLineWidth(lineW)
        context?.addArc(center: CGPoint(x: xCenter, y: yCenter),
                        radius: radius + lineW * 0.5 + 5,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi) * 2,
                        clockwise: true)
        ctx.strokePath()
        
        // 进程圆
        switch self._viewType {
        case .loading :
            ctx.setLineWidth(1);
            ctx.move(to: CGPoint(x: xCenter, y: yCenter));
            ctx.addLine(to: CGPoint(x: xCenter, y: 0));
            let to = -CGFloat(Double.pi) * 0.5 + CGFloat(self.progress * CGFloat(Double.pi) * 2 + 0.001); // 初始值
            context?.addArc(center: CGPoint(x: xCenter, y: yCenter),
                            radius: radius,
                            startAngle: -CGFloat(Double.pi) * 0.5,
                            endAngle: to,
                            clockwise: true)
        case.wait :
            let pointRadius = max(1 , 5 / 100 * rect.size.width)
            let space = rect.size.width * 0.2
            //等待
            ctx.setLineWidth(1);
            ctx.move(to: CGPoint(x: xCenter - space, y: yCenter));
            context?.addArc(center: CGPoint(x: xCenter - space, y: yCenter),
                            radius: pointRadius,
                            startAngle: 0,
                            endAngle: 360,
                            clockwise: false)
        
            ctx.move(to: CGPoint(x: xCenter, y: yCenter));
            context?.addArc(center: CGPoint(x: xCenter, y: yCenter),
                            radius: pointRadius,
                            startAngle: 0,
                            endAngle: 360,
                            clockwise: false)
        
            ctx.move(to: CGPoint(x: xCenter + space, y: yCenter));
            context?.addArc(center: CGPoint(x: xCenter + space, y: yCenter),
                            radius: pointRadius,
                            startAngle: 0,
                            endAngle: 360,
                            clockwise: false)
        case .pause :
            let space = rect.size.width * (15.0 / 100)
            //暂停
            ctx.setLineWidth(space);
            ctx.move(to: CGPoint(x: xCenter - space, y: yCenter - space * 2));
            ctx.addLine(to: CGPoint(x: xCenter - space, y: yCenter + space * 2));
        
            ctx.move(to: CGPoint(x: xCenter + space, y: yCenter - space * 2));
            ctx.addLine(to: CGPoint(x: xCenter + space, y: yCenter + space * 2));
            ctx.strokePath();
            
        case .error :
            let space = rect.size.width * (15.0 / 100)
            let radio = rect.size.width * (22.5 / 100)
            //错误
             ctx.setLineWidth(space);
             ctx.move(to: CGPoint(x: xCenter - radio, y: yCenter - radio));
             ctx.addLine(to: CGPoint(x: xCenter + radio, y: yCenter + radio));
        
             ctx.move(to: CGPoint(x: xCenter - radio, y: yCenter + radio));
             ctx.addLine(to: CGPoint(x: xCenter + radio, y: yCenter - radio));
             ctx.strokePath();
        }

        ctx.fillPath();
    }
    
}


public extension UIColor{
    
    @objc static func colorFromHex(_ hexValue: UInt) -> UIColor {
        return colorFromHex(hexValue,alpha: 1)
    }
    @objc static func colorFromHex(_ hexValue: UInt,alpha:Float) -> UIColor {
        return UIColor(
            red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
