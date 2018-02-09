# Change Log
All notable changes of the library will be documented in this file.

## 2.2
### Added
- Ability to globally change the drop shadow of the current content view while the menu is open (#61)
- New sample project controller to tweak the transition settings
- Status bar color can now be updated on a controller by controller basis

### Changed
- Changed default `contentScale` value from `0.88` to `0.86` (#53, #66, #72)
- Updated sample project to better reflect the README demo gif

### Breaking
- Dropped support for iOS 8

## 2.1 - [2017-10-23]
### Added
- Swift 4 support
- Code refactoring
- Check if menu is opened before a transition

### Fixed
- Small UI fix of Sample, associated with iOS 11

## 2.0 - [2017-06-07]
### Added
- UITabBarController and UINavigationController menu items support
- Rotation support
- Public methods documentation in code
- CHANGELOG file

### Changed
- Renamed `showMenu()`/`hideMenu()` methods to `showSideMenu()`/`hideSideMenu()`
- Reworked [Sample](./Sample)

### Fixed
- Customization of spring animation parameters: [Issue #17]
- Displaying horizontal images in [Sample](./Sample)

**Migration notes**

- To mark UIViewController as item of SideMenu you should adopt `SideMenuItemContent` protocol instead of inheritance from `MenuItemContentViewController`.
To show menu you should call `showSideMenu()` method from this protocol.
```swift
import InteractiveSideMenu

class KittyViewController: UIViewController, SideMenuItemContent {

    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }
}
```
Please, keep in mind, that now you are manipulating with `UIViewControllers` instead of `MenuItemContentViewControllers` in your `HostViewController` class.

-  To customize animation you should now update ```transitionOptions``` property in ```MenuContainerViewColtroller``` class.
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let screenSize: CGRect = UIScreen.main.bounds
    self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
    ...
}
```

- Now you have possibility to update customization settings using ```viewWillTransition(to:with:)``` mehod.
```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    var options = TransitionOptions()
    options.duration = size.width < size.height ? 0.4 : 0.6
    options.visibleContentWidth = size.width / 6
    self.transitionOptions = options
}
```

## 1.0 - 2017-01-23
### Added
- Left SideMenu with possibility to customize menu animation and content    
- Sample demonstrating using SideMenu library
- README file

[2017-10-23]: https://github.com/handsomecode/InteractiveSideMenu/compare/2.0...2.1
[2017-06-07]: https://github.com/handsomecode/InteractiveSideMenu/compare/1.0...2.0
[Issue #17]: https://github.com/handsomecode/InteractiveSideMenu/issues/17
