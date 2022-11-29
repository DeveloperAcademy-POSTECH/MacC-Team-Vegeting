//
//  UIImageView+Extension.swift
//  Vegeting
//
//  Created by kelly on 2022/11/28.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(with resource: String?) {
        guard let resource = resource, let url = URL(string: resource) else {
            self.image = UIImage(named: "groupCoverImage1")
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
