//
//  UIImage+Tool.swift
//  BLImageCropView
//
//  Created by ICE on 2018/12/21.
//  Copyright © 2018 Ice. All rights reserved.
//

import UIKit

extension UIImage{
    // 以图片中心为中心，以最小边为边长，裁剪正方形图片
    func cropImageRect(rect:CGRect) ->(UIImage?) {
        let sourceImageRef = self.cgImage
        let newImageRef = sourceImageRef?.cropping(to: rect)
        if newImageRef != nil
        {
          return  UIImage.init(cgImage: newImageRef!)
        }
        return nil
    }
    //获取图片等比缩放后的大小
    func getImageAdaptiveSize(bgView:UIView) ->(CGRect?) {
        
        //这里计算的是  图片在imageview 上边等比例缩放时候 的坐标
        let imageSize = self.size
        // 在图像视图中计算矩形的实际位置和大小
        let viewSize = bgView.bounds.size
        //计算宽高比例
        let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
        //放在imageview 之后 图片相对于背景 的 x y 坐标
        let offsetX = (viewSize.width - imageSize.width * scale) / 2
        let offsetY = (viewSize.height - imageSize.height * scale) / 2
        //获取缩放后的 w h坐标
        return CGRect.init(x: offsetX, y: offsetY, width: imageSize.width * scale, height: imageSize.height * scale)
    }
    
    //重新绘制图片根据宽度 以及图片宽高比例适应
    func redrawImageSize(width:CGFloat) -> UIImage? {
        let h:CGFloat = self.size.height * width / self.size.width
        let size = CGSize.init(width: width, height: h)
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    


}
