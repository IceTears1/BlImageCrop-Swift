//
//  BLCropCoverView.swift
//  BLImageCropView
//
//  Created by ICE on 2018/12/21.
//  Copyright © 2018 Ice. All rights reserved.
//

import UIKit

class BLCropCoverView: UIView {
    var box_Frame:CGRect = CGRect.zero
    var box_Center:CGPoint = CGPoint.zero
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI(boxW:CGFloat,
                scale:CGFloat,
                boxBoderColor:UIColor,
                boxBoderWidth:CGFloat,
                boxFullAreaColor:UIColor,
                boxFullAreaAlpha:CGFloat,
                boxBoderCornerColor:UIColor,
                boxMargin:CGFloat)
    {
//        self.backgroundColor = UIColor.red
        var box_w = boxW
        
        if ( box_w >= self.frame.size.width) {
             box_w = self.frame.size.width - boxMargin * 2 ;
        }
        var box_h = box_w * (1/scale);
        
        if (box_h >= self.frame.size.height) {
            box_h = self.frame.size.height - boxMargin * 2 ;
        }
        if ( (box_w / box_h) != (scale) ) {
            box_w = box_h * scale ;
        }
        
        let topLayer = CALayer()
        topLayer.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: (self.frame.size.height - box_h)/2)
        topLayer.backgroundColor = boxFullAreaColor.cgColor;
        topLayer.opacity = Float(boxFullAreaAlpha);
        self.layer.addSublayer(topLayer)
        
        
        
        let  leftLayer = CALayer()
        leftLayer.frame = CGRect.init(x: 0, y: topLayer.frame.size.height, width: (self.frame.size.width - box_w)/2, height: box_h)
        
        leftLayer.backgroundColor = boxFullAreaColor.cgColor;
        leftLayer.opacity = Float(boxFullAreaAlpha);
        self.layer.addSublayer(leftLayer)
        
        let  rightLayer = CALayer()
        rightLayer.frame = CGRect.init(x: self.frame.size.width - (self.frame.size.width - box_w)/2, y: topLayer.frame.size.height, width:  (self.frame.size.width - box_w)/2, height: box_h)
        rightLayer.backgroundColor = boxFullAreaColor.cgColor
        rightLayer.opacity = Float(boxFullAreaAlpha)
        self.layer.addSublayer(rightLayer)
        
        
        let  bottomLayer = CALayer()
        bottomLayer.frame = CGRect.init(x: 0, y: self.frame.size.height - (self.frame.size.height - box_h)/2, width: self.frame.size.width, height: (self.frame.size.height - box_h)/2)
        bottomLayer.backgroundColor = boxFullAreaColor.cgColor
        bottomLayer.opacity = Float(boxFullAreaAlpha)
        self.layer.addSublayer(bottomLayer)
        
        
       let boxView = UIView.init(frame: CGRect.init(x: (self.frame.size.width - box_w)/2, y: (self.frame.size.height - box_h)/2, width:  box_w, height: box_w * (1/scale)))
        boxView.layer.borderColor = boxBoderColor.cgColor;
        boxView.layer.borderWidth = boxBoderWidth;
        self.addSubview(boxView)
        
        self.box_Frame = boxView.frame;
        self.box_Center = boxView.center;
        
        let smllBox_w:CGFloat = box_w * 0.07;
        let smllBoxBoder_w:CGFloat = 2;
        let boxSize = boxView.frame.size;
        //左上 顶部
        let  layer_leftTop_top = CALayer()
        layer_leftTop_top.frame = CGRect.init(x: -smllBoxBoder_w, y: -smllBoxBoder_w, width: smllBox_w, height: smllBoxBoder_w)
        layer_leftTop_top.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_leftTop_top)
     
        //左上 左
        let  layer_leftTop_Left = CALayer()
        layer_leftTop_Left.frame = CGRect.init(x: -smllBoxBoder_w, y: -smllBoxBoder_w, width: smllBoxBoder_w, height: smllBox_w)
        layer_leftTop_Left.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_leftTop_Left)
        
        //右上 顶部
        let  layer_rightTop_top = CALayer()
        layer_rightTop_top.frame = CGRect.init(x: boxSize.width - smllBox_w + smllBoxBoder_w, y:-smllBoxBoder_w, width: smllBox_w, height: smllBoxBoder_w)
        layer_rightTop_top.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_rightTop_top)
        
        //右上 右部
        let  layer_rightTop_right = CALayer()
        layer_rightTop_right.frame = CGRect.init(x: boxSize.width, y: 0, width: smllBoxBoder_w, height: smllBox_w)

        layer_rightTop_right.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_rightTop_right)
        
        //左下 左部
        let  layer_leftbottom_left = CALayer()
        layer_leftbottom_left.frame = CGRect.init(x: -smllBoxBoder_w, y: boxSize.height - smllBox_w + smllBoxBoder_w, width: smllBoxBoder_w, height: smllBox_w)
        layer_leftbottom_left.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_leftbottom_left)
        //左下 低部
        let  layer_leftbottom_bottom = CALayer()
        layer_leftbottom_bottom.frame = CGRect.init(x: -smllBoxBoder_w, y: boxSize.height, width: smllBox_w, height: smllBoxBoder_w)
        layer_leftbottom_bottom.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_leftbottom_bottom)
        //右下 右部
        let  layer_rightbottom_right = CALayer()
        layer_rightbottom_right.frame = CGRect.init(x: boxSize.width, y: boxSize.height - smllBox_w + smllBoxBoder_w, width: smllBoxBoder_w, height: smllBox_w)
        layer_rightbottom_right.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_rightbottom_right)
        //右下 低部
        let  layer_rightbottom_bottom = CALayer()
        layer_rightbottom_bottom.frame = CGRect.init(x: boxSize.width - smllBox_w + smllBoxBoder_w, y: boxSize.height, width: smllBox_w, height: smllBoxBoder_w)
   
        layer_rightbottom_bottom.backgroundColor = boxBoderCornerColor.cgColor;
        boxView.layer.addSublayer(layer_rightbottom_bottom)
    }

}
