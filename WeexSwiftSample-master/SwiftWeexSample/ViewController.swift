//
//  ViewController.swift
//  SwiftWeexSample
//
//  Created by zifan.zx on 6/18/16.
//  Copyright © 2016 com.taobao.weex. All rights reserved.
//

import UIKit
import WeexSDK

class ViewController: UIViewController {
    var instance:WXSDKInstance?;
    var weexView = UIView()
    var weexHeight:CGFloat?;
    var top:CGFloat?;
    var url:NSURL?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = UIColor.whiteColor()
        if !self.navigationController!.navigationBar.hidden {
            top = CGRectGetMaxY(self.navigationController!.navigationBar.frame);
        } else {
            top = CGRectGetMaxY(UIApplication.sharedApplication().statusBarFrame)
        }
        weexHeight = self.view.frame.size.height - top!;
        render()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if instance != nil {
            instance!.destroyInstance()
            instance = nil
        }
    }
    
    func render(){
        if instance != nil {
            instance!.destroyInstance()
            instance = nil
        }
        instance = WXSDKInstance();
        instance!.viewController = self
        let width = self.view.frame.size.width
        
        instance!.frame = CGRectMake(self.view.frame.size.width-width, top!, width, weexHeight!)
//        weak var weakSelf:ViewController? = self
        instance!.onCreate = { [weak self] wView in
          guard let sf = self else {
            return
          }
            sf.weexView.removeFromSuperview()
            sf.weexView = wView;
            sf.view.addSubview(wView)
//            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf!.weexView)
        }
        instance!.onFailed = {
            (error:NSError!)-> Void in
            
            print("faild at error: %@", error)
        }
        
        instance!.renderFinish = {
            (view:UIView!)-> Void in
            print("render finish")
        }
        instance!.updateFinish = {
            (view:UIView!)-> Void in
            print("update finish")
        }
        
        instance!.renderWithURL(url, options: ["bundleUrl":String.init(format: "file://%@/bundlejs/", NSBundle.mainBundle().bundlePath)], data: nil)
    }


}

