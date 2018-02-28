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

public protocol TinderCardViewDelegate: class {
    func tinderCard(_ tinderCard: TinderCardView, didSwipeCardAt: Int, in direction: SwipeDirection)
}

public class TinderCardView: UIView {
    
    var contentViews = [UIView]()
    var currentCount = 0
    var basicView = UIView()
    var cardCriteria: CGPoint!
    
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
    
    public weak var delegate: TinderCardViewDelegate?
    
    private func setUp() {
        self.backgroundColor = UIColor.clear
        let countOfCards = dataSource?.numberOfCards(self) ?? 0
        for i in (0..<countOfCards) {
            contentViews.append(createCard(index: i))
        }
        for i in (0..<countOfCards).reversed() {
            contentViews[i].frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.addSubview(contentViews[i])
        }
        basicView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        basicView.backgroundColor = UIColor.blue
        self.addSubview(basicView)
        cardCriteria = basicView.center
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
        
        if(currentCount >= contentViews.count) {
            return
        }
        
        let card = sender.view!
        let view = (UIApplication.shared.keyWindow?.rootViewController?.view)!
        let location = sender.translation(in: view)
        contentViews[currentCount].center = CGPoint(x: card.center.x + location.x, y: card.center.y + location.y)
        card.center = CGPoint(x: card.center.x + location.x, y: card.center.y + location.y)
        
//        let xFromCenter = card.center.x - view.center.x
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.contentViews[self.currentCount].center = CGPoint(x: self.contentViews[self.currentCount].center.x - 300, y: self.contentViews[self.currentCount].center.y)
                })
                currentCount += 1
                card.center = cardCriteria
                card.transform = CGAffineTransform.identity
                delegate?.tinderCard(self, didSwipeCardAt: currentCount, in: .left)
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.contentViews[self.currentCount].center = CGPoint(x: self.contentViews[self.currentCount].center.x + 300, y: self.contentViews[self.currentCount].center.y)
                })
                currentCount += 1
                card.center = cardCriteria
                card.transform = CGAffineTransform.identity
                delegate?.tinderCard(self, didSwipeCardAt: currentCount, in: .right)
                return
            }
            UIView.animate(withDuration: 0.4, animations: {
                card.center = self.cardCriteria
                card.transform = CGAffineTransform.identity
                self.contentViews[self.currentCount].center = self.cardCriteria
                self.contentViews[self.currentCount].transform = CGAffineTransform.identity
            })
            delegate?.tinderCard(self, didSwipeCardAt: currentCount, in: .yetRunOut)
        }
    }
}
