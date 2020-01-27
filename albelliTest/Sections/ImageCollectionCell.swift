//
//  CoolectionViewImageCell.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    // MARK: - API
    var image: UIImage? { didSet { imageView.image = image } }
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .darkGray
        setImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = bounds
        imageView.frame.size.width -= 1
        imageView.frame.size.height -= 1
        imageView.center = contentView.center
        contentView.addSubview(imageView)
    }
}
