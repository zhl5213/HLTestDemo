//
//  ZHLZoomAnimatingView.swift
//  ZHLSwiftTest
//
//  Created by jsbios on 2018/2/26.
//  Copyright © 2018年 Dianzhi. All rights reserved.
//

import UIKit

class ZoomAnimatingLayer: CALayer {
    
//    圆环内部半径
   @NSManaged public var circqueInnerRadius :CGFloat
    //    圆环外部半径
   @NSManaged  public var circqueOuterRadius :CGFloat
     //    圆环中心
   @NSManaged  public var center :CGPoint
     //    填充颜色
   @NSManaged  public var fillColor :UIColor?
    
    // 需要在动画的时候使用的属性，都必须添加NSManaged，即使这个属性不需要动画显示；
//    如果不加，这个属性会无效（动画的时候，本CALayer类会不停的创建新的AnimationDisPlayLayer，来动态加载所有NSManaged的属性,没有NSManaged的属性会被忽略）
      //    是否显示中间暂停的方形
    @NSManaged  public var showPausing:Bool
     //    中间暂停的方形的边长
    @NSManaged public var pausingRectEdge:CGFloat

    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 注册需动态重绘的属性（设置之后，给该属性增加动画效果才能够调用draw(in ctx: CGContext) 重新绘制）
     override class func needsDisplay(forKey key: String) -> Bool{
        print("needsDisplay(forKey key: String)")
        if key == "circqueInnerRadius" || key == "circqueOuterRadius" || key == "pausingRectEdge" {
            return true
        }

        return super.needsDisplay(forKey: key)
    }
    
    //设置属性的属性设置动画：当我们写入该属性的时候，会增加动画效果；
    override func action(forKey event: String) -> CAAction? {
       
        if self.presentation() != nil {
//            self.presentation() 是在动画过程中CALayer创建的针对动画当前显示界面的显示层；
            print(self.presentation()!)
            if event == "pausingRectEdge" {
                 print(" event == \(pausingRectEdge) action(forKey event: String)")
                let rectEdge = CABasicAnimation.init(keyPath: event)
                rectEdge.fromValue = pausingRectEdge
                rectEdge.duration = 2
                
          //属性设置动画可以不是针对更改的属性，可以是其他的属性
//                let opacityAni = CABasicAnimation.init(keyPath: "opacity")
//                opacityAni.fromValue = 1
//                opacityAni.fromValue = 0.5
//                opacityAni.duration = 0.5
                
                return rectEdge
            }
        }
       
        return super.action(forKey: event)
    }
    
    override func draw(in ctx: CGContext) {
        //动画内容，方法省略
        var finalCenter =  CGPoint.init(x: self.bounds.width/2, y: self.bounds.height/2)
        var finalColor = UIColor.white
        
        if !center.equalTo(CGPoint.zero) {
            finalCenter = center
        }
        
        if fillColor != nil {
            finalColor = fillColor!
        }
        
        let cirquePath = UIBezierPath.init()
        cirquePath.addArc(withCenter: finalCenter, radius: circqueInnerRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        cirquePath.addArc(withCenter: finalCenter, radius: circqueOuterRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        ctx.addPath(cirquePath.cgPath)
        ctx.setFillColor(finalColor.cgColor)
        ctx.fillPath(using: CGPathFillRule.evenOdd)
        
        
        if showPausing {
            let roundRect = UIBezierPath.init(roundedRect: CGRect.init(x: finalCenter.x - pausingRectEdge/2, y: finalCenter.y - pausingRectEdge/2, width: pausingRectEdge, height: pausingRectEdge), cornerRadius: 5)
            ctx.addPath(roundRect.cgPath)
            ctx.setFillColor(finalColor.cgColor)
            ctx.fillPath(using: CGPathFillRule.winding)
        }
    }
}

