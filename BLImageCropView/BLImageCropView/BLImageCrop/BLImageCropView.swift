//
//  BLImageCropView.swift
//  BLImageCropView
//
//  Created by ICE on 2018/12/21.
//  Copyright © 2018 Ice. All rights reserved.
//

import UIKit

typealias BLImageCropBlock = (UIImage?)->()
class BLImageCropView: UIView {
    var resultBlock:BLImageCropBlock?
    var  boxWidth:CGFloat! //剪裁框的大小 --默认  self的宽或者高 - boxMargin  但会优先根据宽高比例适应
    var boxMargin:CGFloat!  //剪裁框边距 --默认  10
    
    var boxWHScale:CGFloat!//剪裁框子宽高比例; --默认 9.0：16.0
    var boxBoderColor:UIColor!//剪裁框子边框的颜色; --默认 灰色
    var boxBoderWidth:CGFloat!//剪裁框子边框的宽度;  --默认 1.0
    
    var boxFullAreaColor:UIColor!//剪裁框子  填充色; --默认 黑色
    var boxFullAreaAlpha:CGFloat!//剪裁框子填充区域透明度; --默认  0.5
    
    var boxBoderCornerColor:UIColor!//剪裁框子 四角框子 的颜色; --默认 白色
    
    var imageMaxScale:CGFloat!//图片最大的 放大倍数  --默认 5.0
    
    //是否重绘图片大小
    var isRedraw:Bool = false //默认false
    //重绘图片大小的 宽高  默认 宽 1080   高度根据图片宽高比例自适应
    var reDrawImageWidth:CGFloat!
    
    
    private  var orginImgView:UIImageView!
    private  var  boxView:BLCropCoverView!
    private  var  touchCenter:CGPoint = CGPoint.zero   //拖动和 捏合时候计算坐标
    private  var  orginSize:CGSize = CGSize.zero  //原图尺寸
    private  var  minZoom:CGFloat  = 1.0 //最小的放大倍数
    private  var  maxZoom:CGFloat   = 5.0//最大的放大倍数
    private  var  curScale:CGFloat = 1.0 //当前的放大倍数
    private  var  zoomPoint:CGPoint = CGPoint.zero ////放大时候的中心点
    private  var  orginImage:UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultData()
    }
    private func defaultData(){
        //默认框子的大小
        self.boxWidth  = self.frame.size.width;
        //默认的比例
        self.boxWHScale = 9.0 / 16.0;
        //默认的边距 10.0
        self.boxMargin = 10.0;
        //默认边框设置
        self.boxBoderColor = UIColor.gray;
        self.boxBoderWidth = 1;
        
        //默认填充区域的设置
        self.boxFullAreaColor = UIColor.black;
        self.boxFullAreaAlpha = 0.5;
        
        //默认四个角设置
        self.boxBoderCornerColor = UIColor.white;
        
        //最大放大倍数
        self.imageMaxScale = 5.0;
        
        //重绘图片的 宽度 高度等比例适应
        self.reDrawImageWidth = 1080.0;
        self.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initData(orginImage:UIImage!,block:@escaping BLImageCropBlock) {
      
        self.resultBlock = block
        self.orginImage = orginImage
        self.createUI()
        
    }
    func done(){
        //拿到需要剪裁位置的坐标
        let _x = boxView.box_Frame.origin.x - orginImgView.frame.origin.x ;
        let _y = boxView.box_Frame.origin.y - orginImgView.frame.origin.y;
        let _w = boxView.box_Frame.size.width;
        let _h = boxView.box_Frame.size.height;
        
        //计算剪裁位置相对于 原图的比例
        let _x_scale = _x/orginImgView.frame.size.width ;
        let _y_scale = _y/orginImgView.frame.size.height;
        let _w_scale = _w/orginImgView.frame.size.width;
        let _h_scale = _h/orginImgView.frame.size.height;
        
        //计算剪裁位置 在原图上边的 坐标位置
        let crop_x = _x_scale * self.orginImage.size.width ;
        let crop_y = _y_scale * self.orginImage.size.height;
        let crop_w = _w_scale * self.orginImage.size.width;
        let crop_h = _h_scale * self.orginImage.size.height;
        let cropRect = CGRect.init(x: crop_x, y: crop_y, width: crop_w, height: crop_h)
        
        //开始剪裁
        let result = self.orginImage.cropImageRect(rect: cropRect)
        
        if (self.isRedraw && result != nil) {
            let  reDrawImage = result?.redrawImageSize(width: self.reDrawImageWidth)
            
            self.resultBlock!(reDrawImage)
            
        }else{
            
            self.resultBlock!(result);
            
        }
        
        
    }
    private func createUI(){
        boxView = BLCropCoverView.init(frame: self.bounds)
        boxView.initUI(boxW: self.boxWidth,
                       scale: self.boxWHScale,
                       boxBoderColor: self.boxBoderColor,
                       boxBoderWidth: self.boxBoderWidth,
                       boxFullAreaColor: self.boxFullAreaColor,
                       boxFullAreaAlpha: self.boxFullAreaAlpha,
                       boxBoderCornerColor: self.boxBoderCornerColor,
                       boxMargin: self.boxMargin)
        //一倍时候的尺寸
        let oneFrame = self.orginImage.getImageAdaptiveSize(bgView: self)
        //实际最小尺寸大部分情况下不能为1倍  根据比例自适应
        let orginScale = self.orginImage.size.width / self.orginImage.size.height ;
        var size = CGSize.zero;
        //根据宽高比例不同计算出 需要以g宽适配 还是以高适配
        if (orginScale > self.boxWHScale) {
            let w = self.orginImage.size.width * boxView.box_Frame.size.height / self.orginImage.size.height;
            size = CGSize.init(width: w, height: boxView.box_Frame.size.height)
        }else{
            let h = self.orginImage.size.height * boxView.box_Frame.size.width / self.orginImage.size.width;
            size = CGSize.init(width:  boxView.box_Frame.size.width, height: h)
        }
        
        //设置图片的位置
        orginImgView = UIImageView.init(frame: CGRect.init(x: -(size.width - self.frame.size.width)/2, y: -(size.height - self.frame.size.height)/2, width: size.width, height: size.height))
        orginImgView.contentMode = .scaleAspectFit
        orginImgView.image = self.orginImage;
        orginImgView.isUserInteractionEnabled = true;
        self.addSubview(orginImgView)
        
        
        //拿到 最小倍数  最大倍数   最小倍数下orginImgView的大小
        minZoom = size.width/oneFrame!.size.width;
        curScale = minZoom;
        orginSize = oneFrame!.size;
        maxZoom = minZoom * self.imageMaxScale;
        
        self.addSubview(boxView)
        //捏合
        let pinchGR = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchAction(_:)))
        let panGP =  UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_:)))
        boxView.addGestureRecognizer(pinchGR)
        boxView.addGestureRecognizer(panGP)
        
    }
    @objc private  func pinchAction(_ sender:UIPinchGestureRecognizer){
        if sender.state == .began{
            let point_x = (boxView.box_Frame.origin.x + boxView.box_Frame.size.width / 2) - orginImgView.frame.origin.x;
            let point_y = (boxView.box_Frame.origin.y + boxView.box_Frame.size.height / 2) - orginImgView.frame.origin.y;
            
            //相对于当前位置的比例
            let point_x_scale = point_x/orginImgView.frame.size.width ;
            let point_y_scale = point_y/orginImgView.frame.size.height;
            
            zoomPoint = CGPoint.init(x: point_x_scale, y: point_y_scale)

        }else if (sender.state == .changed){
            //通过捏合手势的到缩放比率
            let scale = sender.scale;
            if (scale >= 1.0) {
                if (curScale > maxZoom) {
                    curScale += scale/5.0 ;
                }else{
                    curScale += scale/18.0 ;
                }
                
            }else{
                if (curScale > minZoom) {
                    curScale -= scale/10.0 ;
                }else{
                    curScale -= scale/40.0 ;
                    if (curScale <= 0.2) {
                        curScale = 0.2;
                    }
                }
                
            }
            //放大后的图片的大小
            let curPoint_w = orginSize.width * curScale;
            let curPoint_h = orginSize.height * curScale;
            
            //放大后中心点的位置
            let  curNewCenter = CGPoint.init(x: curPoint_w * zoomPoint.x, y: curPoint_h * zoomPoint.y)
            
            let curPoint_x = (boxView.box_Frame.origin.x + boxView.box_Frame.size.width / 2) - curNewCenter.x;
            let curPoint_y = (boxView.box_Frame.origin.y + boxView.box_Frame.size.height / 2) - curNewCenter.y;
            var frame = orginImgView.frame;
            frame = CGRect.init(x: curPoint_x, y: curPoint_y, width: curPoint_w, height: curPoint_h)
            orginImgView.frame = frame;
        }else{
            if (curScale > maxZoom) {
                curScale = maxZoom;
            }
            if (curScale < minZoom) {
                curScale = minZoom;
            }
            //放大后的图片的大小
            let curPoint_w = orginSize.width * curScale;
            let curPoint_h = orginSize.height * curScale;
            
            UIView.animate(withDuration: 0.3) {[unowned self] in
                let  curNewCenter = CGPoint.init(x: curPoint_w * self.zoomPoint.x, y: curPoint_h * self.zoomPoint.y)
                let curPoint_x = (self.boxView.box_Frame.origin.x + self.boxView.box_Frame.size.width / 2) - curNewCenter.x;
                let curPoint_y = (self.boxView.box_Frame.origin.y + self.boxView.box_Frame.size.height / 2) - curNewCenter.y;
                var frame = self.orginImgView.frame;
                frame = CGRect.init(x: curPoint_x, y: curPoint_y, width: curPoint_w, height: curPoint_h)
                self.orginImgView.frame = frame;
                
            }
          
            borderDetection()
        }
    }
    @objc private  func panAction(_ sender:UIPanGestureRecognizer){
        if sender.state == .began{
            touchCenter =  orginImgView.center;
        }else if (sender.state == .changed){
            //得到当前手势所在视图
            let view1 = sender.view;
            //得到我们在视图上移动的偏移量
            let currentPoint = sender.translation(in: view1?.superview)
            if (orginImgView.frame.origin.x > boxView.box_Center.x || orginImgView.frame.origin.y > boxView.box_Center.y  || (orginImgView.frame.maxX) <  boxView.box_Center.x || (orginImgView.frame.maxY) <  boxView.box_Center.y) {
                return;
            }
            
            orginImgView.center = CGPoint.init(x: touchCenter.x + currentPoint.x, y: touchCenter.y + currentPoint.y)

        }else{
            borderDetection()
        }
    }
    private func borderDetection(){
        let duration = 0.3;
        if (orginImgView.frame.origin.x >= boxView.box_Frame.origin.x){
            UIView.animate(withDuration: duration) {[unowned self] in
                var frame = self.orginImgView.frame;
                frame.origin.x = self.boxView.box_Frame.origin.x
                self.orginImgView.frame = frame
            }
        }
        
        if (orginImgView.frame.origin.y >= boxView.box_Frame.origin.y){
            UIView.animate(withDuration: duration) {[unowned self] in
              
                var frame = self.orginImgView.frame;
                frame.origin.y = self.boxView.box_Frame.origin.y
                self.orginImgView.frame = frame
                }
        }
        
        if ((orginImgView.frame.maxX) <= (boxView.box_Frame.maxX)){
            
            UIView.animate(withDuration: duration) {[unowned self] in
                var frame = self.orginImgView.frame
                frame.origin.x = (self.boxView.box_Frame.maxX) - frame.size.width
                self.orginImgView.frame = frame
                }
        }
        if (((orginImgView.frame.maxY) <= (boxView.box_Frame.maxY))){
            
            UIView.animate(withDuration: duration) {[unowned self] in
    
                var frame = self.orginImgView.frame
                frame.origin.y = (self.boxView.box_Frame.maxY) - frame.size.height
                self.orginImgView.frame = frame
            }
            
        }
        
    }
    
}
