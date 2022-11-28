//
//  UIImageView+Extension.swift
//  Vegeting
//
//  Created by kelly on 2022/11/28.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(with url: URL) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: url.absoluteString, options: nil) { result in // 캐시에서 키를 통해 이미지를 가져온다.
            switch result {
            case .success(let value):
                if let image = value.image { // 만약 캐시에 이미지가 존재한다면
                    self.image = image // 바로 이미지를 셋한다.
                } else {
                    let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString) // URL로부터 이미지를 다운받고 String 타입의 URL을 캐시키로 지정하고
                    self.kf.setImage(with: resource) // 이미지를 셋한다.
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
