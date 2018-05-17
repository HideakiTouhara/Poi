//
//  Card.swift
//  Example
//
//  Created by HideakiTouhara on 2018/05/17.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit

class Card: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func prepareUI(img: UIImage, text: String) {
        image.image = img
        label.text = text
    }
}
