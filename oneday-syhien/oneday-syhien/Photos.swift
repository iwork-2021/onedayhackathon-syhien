//
//  Photos.swift
//  oneday-syhien
//
//  Created by nju on 2021/12/21.
//

import UIKit

class Photos: NSObject {
    var imageViews: [UIImage] = []
    var viewAllController: UICollectionViewController?
    
    override init() {
        imageViews.append(UIImage(named: "0.jpg")!)
        imageViews.append(UIImage(named: "1.jpg")!)
        imageViews.append(UIImage(named: "2.jpg")!)
    }
    
    func getNumbers() -> Int {
        return imageViews.count
    }
    
    func addImage(newImage: UIImage) {
        imageViews.append(newImage)
        
        DispatchQueue.main.async {
            self.viewAllController?.collectionView.reloadData()
        }

        print(imageViews.count)
    }
}
