//
//  BLGPUImageToolClass.swift
//  ALSPetsMail
//
//  Created by 冰泪 on 2018/1/23.
//  Copyright © 2018年 冰泪. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos
enum WaterMarkPosition {
    case LeftTop
    case RightTop
    case LeftBottom
    case RightBottom
}

class BLGPUImageToolClass: NSObject {
  
    // MARK: -保存照片到相册
    class func saveCameraToPhotoAlbum(baseImage:UIImage?,successBlock:@escaping (Bool)->()){
        //保存照片 到相册
       
        guard let image = baseImage else {
             successBlock(false)
            return
        }
        DispatchQueue.global().async {
            //拿到相册
            PHPhotoLibrary.shared().performChanges({
                //保存相片
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { (succcess, error) in
                successBlock(succcess)
            })
        }
    }
  
  
}
