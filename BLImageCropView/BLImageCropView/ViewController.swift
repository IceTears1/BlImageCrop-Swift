//
//  ViewController.swift
//  BLImageCropView
//
//  Created by ICE on 2018/12/21.
//  Copyright © 2018 Ice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   let image = UIImage.init(named: "111.jpg")
    var imgV:BLImageCropView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 50, width: 100, height: 20))
        btn.setTitle("完成", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.view.addSubview(btn)
        
        // Do any additional setup after loading the view, typically from a nib.
        imgV = BLImageCropView.init(frame: CGRect.init(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height - 200))
        
        imgV.boxWHScale = 1.0/1.0
        imgV.boxMargin = 10
        imgV.boxBoderCornerColor = UIColor.red
        
        //初始化之前 设置 参数
        imgV.initData(orginImage: image) { (resultImage) in
            NSLog("\(resultImage!.size)")
            BLGPUImageToolClass.saveCameraToPhotoAlbum(baseImage: resultImage, successBlock: { (s) in
                let  str = s ? "111":"000"
                NSLog("\(str)")
            })
        }
    
//        imgV.backgroundColor = UIColor.red
        self.view.addSubview(imgV)
        
    }
    @objc func click(){
        imgV.done()
    }

}

