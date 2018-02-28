//
//  TinderCardView.swift
//  TinderCard
//
//  Created by HideakiTouhara on 2018/02/26.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit

public protocol TinderCardViewDataSource: class {
    func numberOfCards(_ tinderCard: TinderCardView) -> Int
    func tinderCard(_ tinderCard: TinderCardView, viewForCardAt index: Int) -> UIView
}

public class TinderCardView: UIView {
    
    var contentViews = [UIView]()
    var currentCount = 0
    var basicView = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public weak var dataSource: TinderCardViewDataSource? {
        didSet {
            setUp()
        }
    }
    private func setUp() {
        self.backgroundColor = UIColor.clear
        let countOfCards = dataSource?.numberOfCards(self) ?? 0
        for i in (0..<countOfCards) {
            contentViews.append(createCard(index: i))
        }
        for i in (0..<countOfCards).reversed() {
            self.addSubview(contentViews[i])
            contentViews[i].center = basicView.center
        }
        basicView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        basicView.backgroundColor = UIColor.blue
        self.addSubview(basicView)
        basicView.center = CGPoint(x: 0, y: 0)
        for i in (0..<countOfCards).reversed() {
//            contentViews[i].center = basicView.center
//            contentViews[i].frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        basicView.addGestureRecognizer(panGesture)
    }
    
    private func createCard(index: Int) -> UIView {
        if let dataSource = dataSource {
            return dataSource.tinderCard(self, viewForCardAt: index)
        }
        return UIView()
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        print("basicView\(basicView.center)")
        print("self\(self.center)")
        print("1: \(contentViews[0].center)")
        print("2: \(contentViews[1].center)")
        let card = sender.view!
        let view = (UIApplication.shared.keyWindow?.rootViewController?.view)!
        let location = sender.translation(in: view)
        contentViews[currentCount].center = CGPoint(x: card.center.x + location.x, y: card.center.y + location.y)
        card.center = CGPoint(x: card.center.x + location.x, y: card.center.y + location.y)
    }
}
