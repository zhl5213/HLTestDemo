//
//  HLBeatingCirqueViewController.swift
//  HLTestAndVertify
//
//  Created by jsbios on 2018/3/12.
//  Copyright © 2018年 Dianzhi. All rights reserved.
//

import UIKit

class HLBeatingCirqueViewController: UIViewController {
    @IBOutlet weak var beatingView: UIView!
    var animatorLayer:ZoomAnimatingLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBeatingView()
    }
    
    func setupBeatingView()  {
        
        
        let animLayer = ZoomAnimatingLayer.init(layer: CALayer.self)
        animLayer.circqueOuterRadius = beatingView.frame.width/3
        animLayer.circqueInnerRadius = beatingView.frame.width/3 - 15
        animLayer.frame = beatingView.bounds
        animatorLayer = animLayer
        beatingView.layer.addSublayer(animLayer)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(beatingViewIsTappd(gesture:)))
        beatingView.addGestureRecognizer(tapGesture)
    }
    
  @objc  func beatingViewIsTappd(gesture:UITapGestureRecognizer)  {
    
    if beatingView.transform.isIdentity {
        
        animatorLayer?.showPausing = true
        animatorLayer?.pausingRectEdge = (animatorLayer?.circqueInnerRadius)!
        animatorLayer?.setNeedsDisplay()
        
        let innerCirqueAnim = CABasicAnimation.init()
        innerCirqueAnim.keyPath = "circqueInnerRadius"
        innerCirqueAnim.duration = 1
        innerCirqueAnim.fromValue = animatorLayer!.circqueInnerRadius
        innerCirqueAnim.toValue = animatorLayer!.circqueInnerRadius + 10
        innerCirqueAnim.autoreverses = true
        innerCirqueAnim.repeatCount = Float.greatestFiniteMagnitude
        
        animatorLayer!.add(innerCirqueAnim, forKey: nil)
        
        //使用actions也能够给属性添加属性设置动画，但是动画的fromValue是固定的，没法根据设置值动态调整
        let outterCirqueAnim = CABasicAnimation.init()
        outterCirqueAnim.keyPath = "circqueOuterRadius"
        outterCirqueAnim.duration = 3
        outterCirqueAnim.fromValue = animatorLayer!.circqueOuterRadius

        animatorLayer!.actions = NSMutableDictionary.init(object: outterCirqueAnim, forKey:"circqueOuterRadius" as NSCopying) as? [String : CAAction]
        (animatorLayer?.actions!["circqueOuterRadius"] as! CABasicAnimation).fromValue = animatorLayer!.circqueOuterRadius
        animatorLayer!.circqueOuterRadius += 10
        
      //animatorLayer的pausingRectEdge属性在layer类中设置了属性设置动画
        animatorLayer?.pausingRectEdge =  10
        
        beatingView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        
    }else{
        (animatorLayer?.actions!["circqueOuterRadius"] as! CABasicAnimation).fromValue = animatorLayer!.circqueOuterRadius
        animatorLayer!.circqueOuterRadius -= 10
        animatorLayer?.pausingRectEdge +=  10
        beatingView.transform = CGAffineTransform.identity
    }
    
    }

}
