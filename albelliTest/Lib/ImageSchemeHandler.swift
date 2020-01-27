//
//  ImageSchemeHandler.swift
//  albelliTest
//
//  Created by Pavle Mijatovic on 25/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import Foundation
import WebKit
import Photos

class ImageSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let imageId = urlSchemeTask.request.url!.absoluteString.components(separatedBy: "images/").last!
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [imageId], options: .none).object(at: 0)
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 300.0, height: 300.0),
            contentMode: .aspectFit,
            options: option
        ) { result, info in
            image = result!
        }
        let imageData = image.pngData()!
        urlSchemeTask.didReceive(
            URLResponse(
                url: urlSchemeTask.request.url!,
                mimeType: "image/png",
                expectedContentLength: imageData.count,
                textEncodingName: nil
            )
        )
        urlSchemeTask.didReceive(imageData)
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}
}
