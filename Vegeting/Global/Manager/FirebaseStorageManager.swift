//
//  FirebaseStorageManager.swift
//  Vegeting
//
//  Created by kelly on 2022/11/15.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    
    private init() { }
    
    func uploadImage(image: UIImage, folderName: String,
                     completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaledImage = image.scaledToSafeUploadSize,
              let data = scaledImage.jpegData(compressionQuality: 0.5)
        else {
            completion(.failure(StorageError.uploadFail))
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        let imageReference = Storage.storage().reference().child("\(folderName)/\(imageName)")
        imageReference.putData(data, metadata: metaData) { _, _ in
            imageReference.downloadURL { url, _ in
                guard let url = url
                else {
                    completion(.failure(StorageError.uploadFail))
                    return
                }
                completion(.success(url))
            }
        }
    }
}
