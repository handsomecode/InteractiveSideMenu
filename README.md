<p align="center">
    <a href="https://github.com/handsomecode/InteractiveSideMenu">
        <img src="Screenshots/InteractiveSideMenu.gif">
    </a>
</p>
<p align="center">
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/swift-4.0-orange.svg?style=flat.svg" alt="Swift version: 3.0">
    </a>
    <a href="https://cocoapods.org/pods/InteractiveSideMenu">
        <img src="https://img.shields.io/badge/CocoaPods-3.0-green.svg" alt="CocoaPods: 2.1">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible">
    </a>
    <a href="https://github.com/handsomecode/InteractiveSideMenu/blob/master/LICENSE">
        <img src="https://img.shields.io/hexpm/l/plug.svg" alt="License: Apache 2.0">
    </a>
</p>

# Interactive Side Menu
A customizable, interactive, auto expanding and collapsing side menu for iOS written in Swift.

Here are some of the ways `InteractiveSideMenu` can be customized:
- Animation duration
- Visible content width
- Content scale
- UIView spring animations
- Animation curves
- Customized animation settings for different orientations

## Communication

- If you **need help or found a bug**, please, open an issue.
- If you **have a feature request**, open an issue.
- If you **are ready to contribute**, submit a pull request.
- If you **like Interactive Side Menu**, please, give it a star.
- If you **use Interactive Side Menu in your application published to AppStore**, [send us a link](https://github.com/handsomecode/InteractiveSideMenu/issues/new) and we'll create the list with applications used our library.

You can find more details into [CONTRIBUTING](./CONTRIBUTING.md) file.

## Installation

### CocoaPods
To install using [CocoaPods](https://cocoapods.org/), add the following line to your Podfile:
```
pod 'InteractiveSideMenu'
```
Please, don't forget to run `pod update` command to update your local specs repository during migration from one version to another.

### Carthage
To install using [Carthage](https://github.com/Carthage/Carthage), add the following line to your Cartfile:
```
github "handsomecode/InteractiveSideMenu"
```

# Usage
*For updating help when migrating from v2.x to v3.0, see our [migration guide](./Docs/Migration_v3.md).*

### Setting up the Side Menu handler
To implement your side menu you should subclass the `MenuContainerViewController` and `MenuViewController` view controllers.
- `MenuContainerViewController` is the main container that hosts the side menu and a content controller
- `MenuViewController` is the controller for the side menu

Once your subclasses are set up:
##### For this, Host = `MenuContainerViewController` subclass and Menu = `MenuViewController` subclass
1. Set your Host and Menu subclasses in the `InteractiveSideMenu` handler.
2. (Optional) Setup and customize any transition options.
3. (Optional) Setup and customize any content controller presentation options.
4. Tell the Menu to select the initial content controller.

```swift
import InteractiveSideMenu

class HostViewController: MenuContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 1) Instantiate menu view controller by identifier.
        let menuViewController = SampleMenuViewController.storyboardViewController()
        InteractiveSideMenu.shared.setMenuContainerController(self, menuViewController: menuViewController)

        /// 2) Set up any custom transition options.
        let screenSize: CGRect = UIScreen.main.bounds
        let transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
        InteractiveSideMenu.shared.transitionOptions = transitionOptions

        /// 3) Change any content item presentation options.
        InteractiveSideMenu.shared.currentItemOptions.cornerRadius = 10.0

        /// 4) Select the initial content controller.
        menuViewController.selectInitialContentController(KittyViewController.storyboardViewController())
    }
}
```

### Setting up the menu
The `MenuViewController` class uses an array of `SideItemMenuContent` objects to display the menu list and provide the data necessary to create content controllers on-demand.
```swift
import InteractiveSideMenu

class SampleMenuViewController: MenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Create the side menu items to be used by the table view.
        itemContentControllers = createSideMenuContent()
    }

    func createSideMenuContent() -> [SideMenuItemContent] {
        let kittyContent = SideMenuItemContent(menuTitle: "Kitty", classType: KittyViewController.self)
        let tabBarContent = SideMenuItemContent(menuTitle: "Tab Bar", classType: TabBarViewController.self)
        let tweakContent = SideMenuItemContent(menuTitle: "Tweak Settings", classType: TweakViewController.self)

        return [kittyContent, tabBarContent, tweakContent]
    }
}
```

### Showing and hiding the Side Menu
To show the menu, call the `showSideMenu()` function on the `InteractiveSideMenu` handler.
To hide the menu, call the `closeSideMenu()` function on the `InteractiveSideMenu` handler.
```swift
import InteractiveSideMenu

class KittyViewController: UIViewController {
    
    /// Show side menu on menu button click
    @IBAction func openMenu(_ sender: UIButton) {
        InteractiveSideMenu.shared.showSideMenu()
    }

    /// Hide side menu on menu button click
    @IBAction func closeMenu(_ sender: UIButton) {
        InteractiveSideMenu.shared.closeSideMenu()
    }
}
``` 
### Showing a new content controller
To show a different content controller from the side menu, pass the new controller to the Menu's `selectSideItemContent(_ :)` function.  This also automatically closes the side menu.
```swift
class SampleMenuViewController: MenuViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /// Using the `itemContentControllers` array, instantiate the controller only when needed.
        /// Your instantiation mileage may vary.
        let controllerType = itemContentControllers[indexPath.row].classType
        let storyboard = UIStoryboard(name: String(describing: controllerType.self), bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {
            preconditionFailure("Invalid initial view controller")
        }

        /// Tells the system to change the visible content controller
        selectSideItemContent(controller)
    }
}
 ```

### Menu open and close feedback
To get callbacks when the side menu is open, closed, or in transition, you can conform to `InteractiveSideMenuDelegate` to be notified when the side menu state changes.
```swift
public protocol InteractiveSideMenuDelegate: class {
    func interactiveSideMenu(_ sideMenu: InteractiveSideMenu, didChangeMenuState menuState: MenuState)
}
```
 
### Animation customization for different orientations
To customize transition options for different orientations, override `viewWillTransition(to:with:)` and update the `transitionOptions`.  This can also be done with trait collections using `traitCollectionDidChange(_:)`
```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        var options = TransitionOptions()
        options.duration = size.width < size.height ? 0.4 : 0.6
        options.visibleContentWidth = size.width / 6
        InteractiveSideMenu.shared.transitionOptions = options
    }
```

 Check out the [Sample](./Sample) project for more details and usage examples.
 
# Known Issues
There is [an issue](https://github.com/handsomecode/InteractiveSideMenu/issues/53) associated with the content controller's view not properly having the `safeAreaInsets` set.  This causes the view's layout to shift when the side menu is closed.  The issue appears to be tied to the `transitionOptions`'s `contentScale` setting.  Choosing a value in the range 0.87 - 0.91 causes the `safeAreaInsets.top` to be set to `0.0`.  The default value of the library is no longer within this range but be mindful if changing that value for your own application.


# Requirements
- iOS 9.0+
- Xcode 9.x
- Swift 4.0


# License
InteractiveSideMenu is available under the Apache License, Version 2.0. See the [LICENSE](./LICENSE) file for more info.
