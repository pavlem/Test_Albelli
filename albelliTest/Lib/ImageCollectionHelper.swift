//
//  ImageCollectionHelper.swift
//  albelliTest
//
//  Created by Pavle Mijatovic on 25/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import Foundation
import Photos
import UIKit

struct ImageCollectionHelper {
    
    static func getImage(forIndexPath indexPath: IndexPath, phfetchResults: PHFetchResult<PHAsset>, targetSize: CGSize, completion: @escaping (UIImage?)->()) {
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        PHImageManager.default().requestImage(for: phfetchResults.object(at: indexPath.row), targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions) { (image, _) in
            completion(image)
        }
    }
    
    static func getImageID(from phfetchResults: PHFetchResult<PHAsset>, forIndexPath indexPath: IndexPath) -> String {
        let phAsset = phfetchResults.object(at: indexPath.row)
        return phAsset.localIdentifier
    }
    
    static func getAllPhotos(completion: @escaping (PHFetchResult<PHAsset>) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            guard case .authorized = status else { return assertionFailure("not handled for the sake of simplicity") }
            let photosFetchResult = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
            completion(photosFetchResult)
        }
    }
}
