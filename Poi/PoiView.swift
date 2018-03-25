//
//  PoiView.swift
//  Poi
//
//  Created by HideakiTouhara on 2018/02/26.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit

public protocol PoiViewDataSource: class {
    func numberOfCards(_ poi: PoiView) -> Int
    func poi(_ poi: PoiView, viewForCardAt index: Int) -> UIView
    func poi(_ poi: PoiView, viewForCardOverlayFor direction: SwipeDirection) -> UIImageView?
}

public protocol PoiViewDelegate: class {
    func poi(_ poi: PoiView, didSwipeCardAt: Int, in direction: SwipeDirection)
    func poi(_ poi: PoiView, runOutOfCardAt: Int, in direction: SwipeDirection)
}

public extension PoiViewDataSource {
    func poi(_ poi: PoiView, viewForCardOverlayFor direction: SwipeDirection) -> UIImageView? {
        return nil
    }
}

public class PoiView: UIView {
    
    var contentViews = [UIView]()
    var currentCount = 0
    var basicView = UIView()
    var cardCriteria: CGPoint!
    var goodImage: UIImageView?
    var badImage: UIImageView?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public weak var dataSource: PoiViewDataSource? {
        didSet {
            setUp()
        }
    }
    
    public weak var delegate: PoiViewDelegate?
    
    public func swipeCurrentCard(to direction: SwipeDirection) {
        
        if(currentCount >= contentViews.count) {
            return
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.contentViews[self.currentCount].transform = CGAffineTransform(rotationAngle: -0.5 * (self.frame.width / 2))
        })
        swipe(at: direction, by: 600)
    }
    
    public func undo() {
        if currentCount == 0 {
            return
        }
        currentCount -= 1
        UIView.animate(withDuration: 0.4, animations: {
            self.contentViews[self.currentCount].center = self.cardCriteria
            self.contentViews[self.currentCount].transform = CGAffineTransform.identity
        })
    }
    
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
        basicView.backgroundColor = UIColor.clear
        self.addSubview(basicView)
        cardCriteria = basicView.center
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        basicView.addGestureRecognizer(panGesture)
        if let image = dataSource?.poi(self, viewForCardOverlayFor: .right) {
            goodImage = image
            basicView.addSubview(goodImage!)
            goodImage?.center = calcBasicCardCenter()
            goodImage?.alpha = 0
        }
        if let image = dataSource?.poi(self, viewForCardOverlayFor: .left) {
            badImage = image
            basicView.addSubview(badImage!)
            badImage?.center = calcBasicCardCenter()
            badImage?.alpha = 0
        }
    }
    
    private func createCard(index: Int) -> UIView {
        if let dataSource = dataSource {
            return dataSource.poi(self, viewForCardAt: index)
        }
        return UIView()
    }
    
    private func calcBasicCardCenter() -> CGPoint {
        let bounds = basicView.frame.size
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        
        if(currentCount >= contentViews.count) {
            return
        }
        
        let card = sender.view!
        let view = (UIApplication.shared.keyWindow?.rootViewController?.view)!
        let location = sender.translation(in: view)
        sender.setTranslation(CGPoint.zero, in: view)
        card.center = CGPoint(x: card.center.x + location.x, y: card.center.y + location.y)
        contentViews[currentCount].center = card.center
        
        let xFromCenter = card.center.x - cardCriteria.x
        contentViews[currentCount].transform = CGAffineTransform(rotationAngle: 0.5 * (xFromCenter / (self.frame.width / 2)))
        card.transform = CGAffineTransform(rotationAngle: 0.5 * (xFromCenter / (self.frame.width / 2)))
        
        if let good = goodImage, xFromCenter > 0 {
            good.alpha = abs(xFromCenter) / (view.bounds.size.width / 3)
            if let bad = badImage {
                bad.alpha = 0
            }
        }
        if let bad = badImage, xFromCenter <= 0 {
            bad.alpha = abs(xFromCenter) / (view.bounds.size.width / 3)
            if let good = goodImage {
                good.alpha = 0
            }
        }

        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.contentViews[self.currentCount].center = CGPoint(x: self.contentViews[self.currentCount].center.x - 300, y: self.contentViews[self.currentCount].center.y)
                })
                currentCount += 1
                card.center = cardCriteria
                card.transform = CGAffineTransform.identity
                delegate?.poi(self, didSwipeCardAt: currentCount, in: .left)
                if currentCount == contentViews.count {
                    delegate?.poi(self, runOutOfCardAt: currentCount, in: .left)
                }
                resetImageAlpha()
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.contentViews[self.currentCount].center = CGPoint(x: self.contentViews[self.currentCount].center.x + 300, y: self.contentViews[self.currentCount].center.y)
                })
                currentCount += 1
                card.center = cardCriteria
                card.transform = CGAffineTransform.identity
                delegate?.poi(self, didSwipeCardAt: currentCount, in: .right)
                if currentCount == contentViews.count {
                    delegate?.poi(self, runOutOfCardAt: currentCount, in: .right)
                }
                resetImageAlpha()
                return
            }
            UIView.animate(withDuration: 0.4, animations: {
                card.center = self.cardCriteria
                card.transform = CGAffineTransform.identity
                self.contentViews[self.currentCount].center = self.cardCriteria
                self.contentViews[self.currentCount].transform = CGAffineTransform.identity
            })
            resetImageAlpha()
        }
    }
    
    private func swipe(at direction: SwipeDirection, by distance: CGFloat) {
        switch direction {
        case .left:
            UIView.animate(withDuration: 0.4, animations: {
                self.contentViews[self.currentCount].center = CGPoint(x: self.contentViews[self.currentCount].center.x - distance, y: self.contentViews[self.currentCount].center.y)
            })
            currentCount += 1
            basicView.center = cardCriteria
            basicView.transform = CGAffineTransform.identity
            delegate?.poi(self, didSwipeCardAt: currentCount, in: .left)
            if currentCount == contentViews.count {
                delegate?.poi(self, runOutOfCardAt: currentCount, in: .left)
            }
            resetImageAlpha()
        case .right:
            UIView.animate(withDuration: 0.4, animations: {
                self.contentViews[self.currentCount].center = CGPoint(x: self.contentViews[self.currentCount].center.x + distance, y: self.contentViews[self.currentCount].center.y)
            })
            currentCount += 1
            basicView.center = cardCriteria
            basicView.transform = CGAffineTransform.identity
            delegate?.poi(self, didSwipeCardAt: currentCount, in: .right)
            if currentCount == contentViews.count {
                delegate?.poi(self, runOutOfCardAt: currentCount, in: .right)
            }
            resetImageAlpha()
        }
    }
    
    private func resetImageAlpha() {
        if let good = goodImage {
            good.alpha = 0
        }
        if let bad = badImage {
            bad.alpha = 0
        }
    }
}
