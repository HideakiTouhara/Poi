//
//  ViewController.swift
//  Example
//
//  Created by HideakiTouhara on 2018/02/26.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit
import TinderCard

class ViewController: UIViewController, TinderCardViewDataSource, TinderCardViewDelegate {
    
    @IBOutlet weak var tinderCardView: TinderCardView!
    
    var sampleCards = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor.red, UIColor.orange]
        for i in (0..<2) {
            sampleCards.append(UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 128)))
            sampleCards[i].backgroundColor = colors[i]
        }
        tinderCardView.dataSource = self
        tinderCardView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TinderCardViewDataSource
    func numberOfCards(_ tinderCard: TinderCardView) -> Int {
        return 2
    }

    func tinderCard(_ tinderCard: TinderCardView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
    
    // MARK: TinderCardViewDelegate
    func tinderCard(_ tinderCard: TinderCardView, didSwipeCardAt: Int, in direction: SwipeDirection) {
        switch direction {
        case .left:
            print("left")
        case .right:
            print("right")
        default:
            print("yet run out")
        }
    }
}

