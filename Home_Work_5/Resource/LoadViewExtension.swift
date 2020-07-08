//
//  LoadViewExtension.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 08.07.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//
import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    func startWaiting() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activeIndicator = UIActivityIndicatorView(style: .medium)
        activeIndicator.center = aView!.center
        activeIndicator.startAnimating()
        
        aView?.addSubview(activeIndicator)
        self.view.addSubview(aView!)
    }
    
    func stopWaiting() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
