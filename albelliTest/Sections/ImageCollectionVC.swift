//
//  ViewController.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionVC: UIViewController {
    
    // MARK: - Properties
    private let cellReuseIdentifier = "imageCollectionViewCell"
    private var imageCollectionView: UICollectionView!
    private var photosFetchResult = PHFetchResult<PHAsset>() {
        didSet {
            DispatchQueue.main.async { self.imageCollectionView.reloadData() }
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAllPhotos()
    }

    // MARK: - Helper
    private func setCollectionView() {
        imageCollectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: {
                let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                return layout
            }()
        )
        imageCollectionView.backgroundColor = .white
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        imageCollectionView.backgroundColor = .darkGray
        view.addSubview(imageCollectionView)
    }
    
    private func getAllPhotos() {
        ImageCollectionHelper.getAllPhotos { [weak self] (photosFetchResult) in
            self?.photosFetchResult = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ImageCollectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
            ) as? ImageCollectionCell else { return UICollectionViewCell() }
        
        ImageCollectionHelper.getImage(forIndexPath: indexPath, phfetchResults: photosFetchResult, targetSize: cell.contentView.frame.size, completion: { (image) in
            cell.image = image
        })
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width / 2, height: view.bounds.size.width / 2)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageViewController = ImageVC(imageId: ImageCollectionHelper.getImageID(from: photosFetchResult, forIndexPath: indexPath))
        navigationController?.pushViewController(imageViewController, animated: true)
    }
}
