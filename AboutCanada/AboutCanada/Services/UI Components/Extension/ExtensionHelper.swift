//
//  ExtensionHelper.swift
//  AboutCanada
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?,
                 left: NSLayoutXAxisAnchor?,
                 bottom: NSLayoutYAxisAnchor?,
                 right: NSLayoutXAxisAnchor?,
                 paddingTop: CGFloat,
                 paddingLeft: CGFloat,
                 paddingBottom: CGFloat,
                 paddingRight: CGFloat,
                 width: CGFloat,
                 height: CGFloat,
                 enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop + topInset + 20).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom - bottomInset - 20).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
    
}

// MARK: - UIImageView extension
extension UIImageView {
    
    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlSting: String, completionHandler: @escaping (Bool) -> ()) {
        guard let url = URL(string: urlSting) else {
            completionHandler(true)
            return
        }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            completionHandler(true)
            return
        }
        Networking.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.image = UIImage(named: "noImage")
                    }
                    completionHandler(true)
                    return
                }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                completionHandler(true)
            case .failure(_):
                DispatchQueue.main.async {
                    self.image = UIImage(named: "failed")
                }
                completionHandler(true)
            }
        }
    }
}

extension UIColor {
    static func myColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                // the color can be from your own color config struct as well.
                return trait.userInterfaceStyle == .dark ? UIColor.orange : UIColor.black
            }
        }
        else { return UIColor.orange }
    }
}
