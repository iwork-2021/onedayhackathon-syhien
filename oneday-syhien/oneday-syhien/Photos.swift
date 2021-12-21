//
//  Photos.swift
//  oneday-syhien
//
//  Created by nju on 2021/12/21.
//

import UIKit

class Photos: NSObject {
    var imageViews: [UIImage] = []
    override init() {
        imageViews.append(UIImage(named: "0.jpg")!)
        imageViews.append(UIImage(named: "1.jpg")!)
        imageViews.append(UIImage(named: "2.jpg")!)
    }
    func getNumbers() -> Int {
        return imageViews.count
    }
}
