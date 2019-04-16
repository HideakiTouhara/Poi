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
    
    public var distanceToSendCardAway: CGFloat = 400
    
    private var contentViews = [UIView]()

    private var currentCount = 0

    lazy private var basicView: UIView = {
        let basicView = UIView(frame: bounds)
        basicView.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGesture.delegate = self
        basicView.addGestureRecognizer(panGesture)
        return basicView
    }()

    private var boundsCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    private var goodImage: UIImageView?
    private var badImage: UIImageView?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }

    public weak var dataSource: PoiViewDataSource? {
        didSet {
            reloadData()
        }
    }

    public weak var delegate: PoiViewDelegate?

    public func swipeCurrentCard(to direction: SwipeDirection) {
        guard currentCount < contentViews.count else { return }

        let card = contentViews[currentCount]
        let transform = CGAffineTransform(
            rotationAngle: direction.rotationAngle(for: frame)
        )
        UIView.animate(withDuration: 0.4, animations: {
            card.transform = transform
        })
        swipe(at: direction, by: distanceToSendCardAway)
    }

    public func undo() {
        guard currentCount > 0 else { return }

        currentCount -= 1
        let card = contentViews[currentCount]
        let center = boundsCenter
        UIView.animate(withDuration: 0.4, animations: {
            card.center = center
            card.transform = .identity
        })
    }

    private func reset() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
        contentViews = []
        currentCount = 0

        basicView.subviews.forEach {
            $0.removeFromSuperview()
        }
        basicView.transform = .identity
        basicView.frame = bounds
    }
    
    public func reloadData() {
        reset()

        let countOfCards = dataSource?.numberOfCards(self) ?? 0
        for i in (0..<countOfCards) {
            let card = createCard(index: i)
            card.transform = .identity
            card.frame = bounds
            card.center = boundsCenter
            contentViews.append(card)
        }
        contentViews.reversed().forEach { addSubview($0) }

        addSubview(basicView)
        if let image = dataSource?.poi(self, viewForCardOverlayFor: .right) {
            basicView.addSubview(image)
            image.center = boundsCenter
            image.alpha = 0
            goodImage = image
        }
        if let image = dataSource?.poi(self, viewForCardOverlayFor: .left) {
            basicView.addSubview(image)
            image.center = boundsCenter
            image.alpha = 0
            badImage = image
        }
    }

    private func createCard(index: Int) -> UIView {
        if let dataSource = dataSource {
            return dataSource.poi(self, viewForCardAt: index)
        }
        return UIView()
    }

    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        guard currentCount < contentViews.count else { return }

        let boundsCenter = self.boundsCenter
        let overlay = sender.view!
        let card = contentViews[currentCount]
        let windowView = (UIApplication.shared.keyWindow?.rootViewController?.view)!

        if sender.state == UIGestureRecognizer.State.ended {
            if overlay.center.x < 75 {
                UIView.animate(withDuration: 0.4, animations: {
                    card.center = CGPoint(x: card.center.x - self.distanceToSendCardAway, y: card.center.y)
                })
                currentCount += 1
                delegate?.poi(self, didSwipeCardAt: currentCount, in: .left)
                if currentCount == contentViews.count {
                    delegate?.poi(self, runOutOfCardAt: currentCount, in: .left)
                }
            } else if overlay.center.x > (windowView.frame.width - 75) {
                UIView.animate(withDuration: 0.4, animations: {
                    card.center = CGPoint(x: card.center.x + self.distanceToSendCardAway, y: card.center.y)
                })
                currentCount += 1
                delegate?.poi(self, didSwipeCardAt: currentCount, in: .right)
                if currentCount == contentViews.count {
                    delegate?.poi(self, runOutOfCardAt: currentCount, in: .right)
                }
            } else {
                UIView.animate(withDuration: 0.4, animations: {
                    card.center = boundsCenter
                    card.transform = .identity
                })
            }
            overlay.center = boundsCenter
            overlay.transform = .identity
            resetImageAlpha()
        } else {
            let location = sender.translation(in: windowView)
            sender.setTranslation(.zero, in: windowView)
            card.center = CGPoint(x: overlay.center.x + location.x, y: overlay.center.y + location.y)
            overlay.center = card.center

            let xFromCenter = card.center.x - boundsCenter.x
            let transform = CGAffineTransform(rotationAngle: 0.5 * (xFromCenter / (frame.width / 2)))
            card.transform = transform
            overlay.transform = transform

            resetImageAlpha()
            if let good = goodImage, xFromCenter > 0 {
                good.alpha = abs(xFromCenter) / (windowView.bounds.size.width / 3)
            }
            if let bad = badImage, xFromCenter <= 0 {
                bad.alpha = abs(xFromCenter) / (windowView.bounds.size.width / 3)
            }
        }
    }
    
    private func swipe(at direction: SwipeDirection, by distance: CGFloat) {
        let card = contentViews[currentCount]
        currentCount += 1
        switch direction {
        case .left:
            UIView.animate(withDuration: 0.4, animations: {
                card.center = CGPoint(x: card.center.x - distance, y: card.center.y)
            })
            delegate?.poi(self, didSwipeCardAt: currentCount, in: .left)
            if currentCount == contentViews.count {
                delegate?.poi(self, runOutOfCardAt: currentCount, in: .left)
            }
        case .right:
            UIView.animate(withDuration: 0.4, animations: {
                card.center = CGPoint(x: card.center.x + distance, y: card.center.y)
            })
            delegate?.poi(self, didSwipeCardAt: currentCount, in: .right)
            if currentCount == contentViews.count {
                delegate?.poi(self, runOutOfCardAt: currentCount, in: .right)
            }
        }
        basicView.center = boundsCenter
        basicView.transform = .identity
        resetImageAlpha()
    }
    
    private func resetImageAlpha() {
        goodImage?.alpha = 0
        badImage?.alpha = 0
    }
}


extension PoiView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
