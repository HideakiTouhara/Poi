# TinderCard
You can use tinder UI like tableview method

[![https://gyazo.com/6ceb654c12fd68fe7caf1fa7bf7dd9ed](https://i.gyazo.com/6ceb654c12fd68fe7caf1fa7bf7dd9ed.gif)](https://gyazo.com/6ceb654c12fd68fe7caf1fa7bf7dd9ed)

## Instalation
Cocoa Pods
Please write the below code in Podfile

```
pod ‘TinderCard’, :git => 'https://github.com/HideakiTouhara/TinderCard.git’
```

Carthage can too

## Usage
Create TinderCardView in storyboard or swift file

```
@IBOutlet weak var tinderCardView: TinderCardView!
```

Designate delegate target

```
tinderCardView.dataSource = self
tinderCardView.delegate = self
```

Set swipeable card number

```
func numberOfCards(_ tinderCard: TinderCardView) -> Int
```

Set swipeable card

```
func tinderCard(_ tinderCard: TinderCardView, viewForCardAt index: Int) -> UIView
```

When did swipe, this method called

```
func tinderCard(_ tinderCard: TinderCardView, didSwipeCardAt: Int, in direction: SwipeDirection)
```

When last card was swiped, this method called

```
func tinderCard(_ tinderCard: TinderCardView, runOutOfCardAt: Int, in direction: SwipeDirection)
```

## Example
Check the Example file!

```
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

    func tinderCard(_ tinderCard: TinderCardView, runOutOfCardAt: Int, in direction: SwipeDirection) {
        print("last")
    }
}
```
## Contribution
Please create issues or submit pull requests for anything.

## License
TinderCard is released under the MIT license.

© 2018 GitHub, Inc.
