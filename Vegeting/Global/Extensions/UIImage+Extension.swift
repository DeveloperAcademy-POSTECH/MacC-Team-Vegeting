//
//  UIImage_Extension.swift
//  Vegeting
//
//  Created by kelly on 2022/11/15.
//

import UIKit

extension UIImage {
    // 해상도를 너무 높지 않게 조절, 파일 크기가 너무 높지 않도록
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return self.resize(to: newImageSize)
    }
}
