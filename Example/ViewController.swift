//
//  ViewController.swift
//  Example
//
//  Created by HideakiTouhara on 2018/02/26.
//  Copyright © 2018年 HideakiTouhara. All rights reserved.
//

import UIKit
import Poi

class ViewController: UIViewController, PoiViewDataSource, PoiViewDelegate {
    
    @IBOutlet weak var poiView: PoiView!
    
    var sampleCards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        poiView.dataSource = self
        poiView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createViews() {
        for i in (0..<2) {
            let texts = ["sushi", "steak"]
            let images = [#imageLiteral(resourceName: "sushi"), #imageLiteral(resourceName: "meat")]
            let card = UINib(nibName: "Card", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! Card
            card.prepareUI(text: texts[i], img: images[i])
            sampleCards.append(card)
        }
    }
    
    // MARK: PoiViewDataSource
    func numberOfCards(_ poi: PoiView) -> Int {
        return 2
    }

    func poi(_ poi: PoiView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
    
    func poi(_ poi: PoiView, viewForCardOverlayFor direction: SwipeDirection) -> UIImageView? {
        switch direction {
        case .right:
            let good = UIImageView(image: #imageLiteral(resourceName: "good"))
            good.tintColor = UIColor.green
            return good
        case .left:
            let bad = UIImageView(image: #imageLiteral(resourceName: "bad"))
            bad.tintColor = UIColor.red
            return bad
        }
    }
    
    // MARK: PoiViewDelegate
    func poi(_ poi: PoiView, didSwipeCardAt: Int, in direction: SwipeDirection) {
        switch direction {
        case .left:
            print("left")
        case .right:
            print("right")
        }
    }
    
    func poi(_ poi: PoiView, runOutOfCardAt: Int, in direction: SwipeDirection) {
        print("last")
    }
    
    // MARK: IBAction
    @IBAction func OKAction(_ sender: UIButton) {
        poiView.swipeCurrentCard(to: .right)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        poiView.swipeCurrentCard(to: .left)
    }
    
    @IBAction func undo(_ sender: UIButton) {
        poiView.undo()
    }
}

