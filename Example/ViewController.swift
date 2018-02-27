//
//  ViewController.swift
//  Example
//
//  Created by HideakiTouhara on 2018/02/26.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit
import TinderCard

class ViewController: UIViewController, TinderCardViewDataSource {
    
    @IBOutlet weak var tinderCardView: TinderCardView!
    
    var sampleCards = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in (0..<2) {
            sampleCards.append(UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
            sampleCards[i].backgroundColor = UIColor.red
        }
        tinderCardView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfCards(_ tinderCard: TinderCardView) -> Int {
        return 2
    }

    func tinderCard(_ tinderCard: TinderCardView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
}

