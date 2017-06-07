# Interactive Side Menu

[![Swift version](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat.svg)](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/hexpm/l/plug.svg)](./LICENSE)

iOS Interactive Side Menu written in Swift. 

![sample](Screenshots/InteractiveSideMenu.gif)

It supports following customization:
- Animation duration
- Visible content width
- Content scale
- Using spring animation with params customization
- Animation options like animation curve

All these parameters could vary for different orientations.

# Installation

## CocoaPods
To install it through [CocoaPods](https://cocoapods.org/), add the following line to your Podfile:
```
pod 'InteractiveSideMenu'
```

## Carthage
To install it through [Carthage](https://github.com/Carthage/Carthage), add the following line to your Cartfile:
```
github "handsomecode/InteractiveSideMenu"
```


# Usage
To implement your side menu you should create subclasses of basic View Controllers.
- ```MenuContainerViewController``` is a host for menu and content views
- ```MenuViewController``` is a container for menu view

Also, ensure that every menu item ViewController adopts relevant protocol.
- ```SideMenuItemContent``` is a ViewController's protocol for data that corresponds menu item

To setup your side menu you need to do three things:
- Provide implementation of base ```MenuViewController``` and assing it to  ```menuViewController``` property
- Provide implementation of menu content and assing array of content controllers to ```contentViewControllers``` property
- Select initial content controller by calling ```selectContentViewController(_ selectedContentVC: MenuItemContentViewController)```

```swift
import InteractiveSideMenu

class HostViewController: MenuContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
	contentViewControllers = contentControllers()
        selectContentViewController(contentViewControllers.first!)
    }

    private func contentControllers() -> [MenuItemContentViewController] {
    	var contentList = [MenuItemContentViewController]()
    	contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "First") as! MenuItemContentViewController)
    	contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "Second") as! MenuItemContentViewController)
    	return contentList
    }
}
```

To show menu, call ```showSideMenu()``` method from `SideMenuItemContent` protocol.
```swift
import InteractiveSideMenu

class KittyViewController: UIViewController, SideMenuItemContent {
    
    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }
}
``` 

To change content view, choose desired content controller and hide menu.
```swift
    let index = 2 // second menu item
    guard let menuContainerViewController = self.menuContainerViewController else { return }
    let contentController = menuContainerViewController.contentViewControllers[index]
    menuContainerViewController.selectContentViewController(contentController)
    menuContainerViewController.hideMenu()
 ```

To customize animation for menu opening or closing, update ```transitionOptions``` property that is available in ```MenuContainerViewColtroller``` class. Initial setup could be done, for example, on controller's ```viewDidLoad()```.
 ```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let screenSize: CGRect = UIScreen.main.bounds
    self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
    ...
}
```

Also, you have possibility to update customization settings, e.g. set another options for landscape orientation. To do it, override ```viewWillTransition(to:with:)``` mehod and add desired parameters to ```transitionOptions``` property.
```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    var options = TransitionOptions()
    options.duration = size.width < size.height ? 0.4 : 0.6
    options.visibleContentWidth = size.width / 6
    self.transitionOptions = options
}
```

Transition options could be used to set different parameters for Compact and Regular sizes as well. Implement ViewController's ```traitCollectionDidChange(_: )``` method to add these settings.

 See [Sample](./Sample) for more details.

# Requirements
- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+


# License
InteractiveSideMenu is available under the Apache License, Version 2.0. See the [LICENSE](./LICENSE) file for more info.
