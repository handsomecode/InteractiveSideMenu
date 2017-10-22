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

## Communication

- If you **need help or found a bug**, please, open an issue.
- If you **have a feature request**, open an issue.
- If you **are ready to contribute**, submit a pull request.
- If you **like Interactive Side Menu**, please, give it a star.
- If you **use Interactive Side Menu in your application published to AppStore**, [send us a link](https://github.com/handsomecode/InteractiveSideMenu/issues/new) and we'll create the list with applications used our library.

You can find more details into [CONTRIBUTING](./CONTRIBUTING.md) file.

# Installation

## CocoaPods
To install it through [CocoaPods](https://cocoapods.org/), add the following line to your Podfile:
```
pod 'InteractiveSideMenu'
```
Please, don't forget to run `pod update` command to update your local specs repository during migration from one version to another.

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

## HostViewController implementation
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

## Items content
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
    let index = 2 // Second menu item
    guard let menuContainerViewController = self.menuContainerViewController else { return }
    let contentController = menuContainerViewController.contentViewControllers[index]
    menuContainerViewController.selectContentViewController(contentController)
    menuContainerViewController.hideSideMenu()
 ```
 
### TabBar and Navigation controllers

To use menu with **TabBar** or **NavigationController**, ensure that you indicate UITabBarController or UINavigationController as item content directly, not any corresponding ViewControllers.
```swift
class NavigationViewController: UINavigationController, SideMenuItemContent {
}

class InnerViewController: UIViewController {

    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
}
```
Please, find UITabBarController implementation details in [Sample](./Sample).
 
## Animation Customization
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

 Use [Sample](./Sample) to see implementation details and [CHANGELOG](./CHANGELOG.md) to get more information about updating library from v1.0 to v2.0.
 
# Known Issues
There is [an issue](https://github.com/handsomecode/InteractiveSideMenu/issues/53) associated with scaling of NavigationBar in iOS 11. Status bar background is hidden during side menu closing if `contentScale < 1`. It’s supposed to be *iOS 11* Navigation Bar issue that's been reported to Apple.


# Requirements
- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+


# License
InteractiveSideMenu is available under the Apache License, Version 2.0. See the [LICENSE](./LICENSE) file for more info.
