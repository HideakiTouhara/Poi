# Poi  
[![Pod version](https://badge.fury.io/co/Poi.svg)](https://badge.fury.io/co/Poi) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE) ![Swift 4.0.x](https://img.shields.io/badge/Swift-4.0.x-orange.svg)

You can use tinder UI like tableview method

![demo](https://github.com/HideakiTouhara/Poi/blob/resources/Resources/demo.gif)

## Installation
### Manual Installation
1. you use this command

```
git clone git@github.com:HideakiTouhara/Poi.git
```

2. Import Poi.xcodeproj to your project

![direct_import1](https://github.com/HideakiTouhara/Poi/blob/resources/Resources/direct_import1.jpg)

3. Add Poi.frameworkiOS to Embedded Binaries

![direct_import2](https://github.com/HideakiTouhara/Poi/blob/resources/Resources/direct_import2.jpg)



### Cocoa Pods
Please write the below code in Podfile

```
pod ‘Poi’
```
### Carthage
Write this code in your Cartfile.

```
github "HideakiTouhara/Poi"
```

and implement this command

```
carthage update
```

Add Poi.framework in /Carthage/Build/iOS/ to Embedded Binaries.

![carthage_import](https://github.com/HideakiTouhara/Poi/blob/resources/Resources/carthage_import.jpg)

## Usage
Create PoiView in storyboard or swift file

```
import Poi

@IBOutlet weak var PoiView: PoiView!
// You should change poiView's class to PoiView in Attributes inspector.
```

or

```
import Poi

let poiView = PoiView()
self.view.addSubView(poiView)
```

Conform to PoiViewDataSource and PoiViewDelegate

```
class ViewController: UIViewController, PoiViewDataSource, PoiViewDelegate {
```

Designate delegate target.

Please put this code after setting card contents.

```
poiView.dataSource = self
poiView.delegate = self
```

### PoiViewDataSource method

Set swipeable card number(required method)

```
func numberOfCards(_ poi: PoiView) -> Int
```

Set swipeable card(required method)

```
func poi(_ poi: PoiView, viewForCardAt index: Int) -> UIView
```

Set overlay image if right or left swiped

```
func poi(_ poi: PoiView, viewForCardOverlayFor direction: SwipeDirection) -> UIImageView? {
    switch direction {
    case .right:
        return UIImageView(image: #imageLiteral(resourceName: "good"))
    case .left:
        return UIImageView(image: #imageLiteral(resourceName: "bad"))
    }
}
```

### PoiViewDelegate method

When did swipe, this method is called

```
func poi(_ poi: PoiView, didSwipeCardAt: Int, in direction: SwipeDirection)
```

When last card was swiped, this method is called

```
func poi(_ poi: PoiView, runOutOfCardAt: Int, in direction: SwipeDirection)
```

### Public method

Swipe current card

```
func swipeCurrentCard(to direction: SwipeDirection)
```

Undo animation and go back previous card

```
func undo()
```

## Example
Check the Example file!

```
import UIKit
import Poi

class ViewController: UIViewController, PoiViewDataSource, PoiViewDelegate {

    @IBOutlet weak var poiView: PoiView!

    var sampleCards = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor.red, UIColor.orange]
        for i in (0..<2) {
            sampleCards.append(UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 128)))
            sampleCards[i].backgroundColor = colors[i]
        }
        poiView.dataSource = self
        poiView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            return UIImageView(image: #imageLiteral(resourceName: "good"))
        case .left:
            return UIImageView(image: #imageLiteral(resourceName: "bad"))
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

    @IBAction func undo(_ sender: UIButton) {
        poiView.undo()
    }
}
```
## Contribution
Please create issues or submit pull requests for anything.

## License
Poi is released under the MIT license.

© 2018 GitHub, Inc.
