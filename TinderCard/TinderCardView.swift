//
//  TinderCardView.swift
//  TinderCard
//
//  Created by HideakiTouhara on 2018/02/26.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit

protocol TinderCardViewDataSource: class {
    func numberOfCards(_ tinderCard: TinderCardView) -> Int
    func tinderCard(_ tinderCard: TinderCardView, viewForCardAt index: Int) -> UIView
}

class TinderCardView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public weak var dataSource: TinderCardViewDataSource? {
        didSet {
            setUp()
        }
    }
    private func setUp() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        print("pan")
        let location = sender.translation(in: self)
        self.center = CGPoint(x: self.center.x + location.x, y: self.center.y + location.y)
    }
}
