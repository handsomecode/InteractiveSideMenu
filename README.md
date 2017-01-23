#Interactive Side Menu
iOS Interactive Side Menu written in Swift. 

![sample1](Screenshots/InteractiveSideMenu1.gif)
![sample2](Screenshots/InteractiveSideMenu2.gif)

It supports following customization:
- Animation duration
- Visible content width
- Content scale
- Using spring animation with params customization
- Animation options like animation curve

#Installation

##CocoaPods
To install it through [CocoaPods](https://cocoapods.org/), add the following line to your Podfile:
```
pod 'InteractiveSideMenu'
```

##Carthage
To install it through [Carthage](https://github.com/Carthage/Carthage), add the following line to your Cartfile:
```
github "handsomecode/InteractiveSideMenu"
```


#Usage
You should use 3 basic ViewControllers for creating subclasses for implementing your side menu.
- ```MenuContainerViewController``` is a host for menu and content views
- ```MenuViewController``` is a container for menu view
- ```MenuItemContentControlller``` is a container for content that corresponds menu item

To setup your side menu you shoud do 3 things:
- Provide implementation of base ```MenuViewController``` and assing it to  ```menuViewController``` property
- Provide implementation of menu content and assing array of content controllers to ```contentViewControllers``` property
- Select initial content controller by calling ```selectContentViewController(_ selectedContentVC: MenuItemContentViewController)```

```swift
import InteractiveSideMenu

class MainContainerViewController: MenuContainerViewController {
    
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

To show menu you should call ```showMenu()``` method that is available in MenuItemContentViewController class.
```swift
import InteractiveSideMenu

class FirstViewController: MenuItemContentViewController {
    
    @IBAction func didOpenMenu(_ sender: UIButton) {
        showMenu()
    }
}
``` 

To change content view you should choose desired content controller and hide menu.
```swift
let index = 2 // second menu item
guard let menuContainerViewController = self.menuContainerViewController else { return }
let contentController = menuContainerViewController.contentViewControllers[index]
menuContainerViewController.selectContentViewController(contentController)
menuContainerViewController.hideMenu()
 ```

 To customize animation for menu opening or closing you should override ```menuTransitionOptionsBuilder()``` method that is available in ```MenuContainerViewColtroller``` class.
 ```swift
 override func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
    return TransitionOptionsBuilder() { builder in
        builder.duration = 0.5
        builder.contentScale = 1
    }
}
  ```

 See [Sample](./Sample) for more details.

# Requirements
- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+


# License
InteractiveSideMenu is available under the Apache License, Version 2.0. See the [LICENSE](./LICENSE) file for more info.