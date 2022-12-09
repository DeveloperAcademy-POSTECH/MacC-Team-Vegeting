//
//  UIImageView+Extension.swift
//  Vegeting
//
//  Created by kelly on 2022/11/28.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(kind: String, with url: URL?) {
        guard let url = url else {
            let imageName = (kind == "profile" ? "profile\(Int.random(in: 1...9))" : "groupCoverBasicImage")
            self.image = UIImage(named: imageName)
            return
        }
        let cache = ImageCache.default
        cache.retrieveImage(forKey: url.absoluteString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
