# Change Log
All notable changes to the library will be documented in this file.

## [Unreleased]
### Added
- UITabBarController and UINavigationController menu items support
- Rotation support
- Right SideMenu support (plan)
- CHANGELOG file

### Changed
- Renamed `showMenu()`/`hideMenu()` methods to `showSideMenu()`/`hideSideMenu()`

### Fixed
- Displaying horizontal images in [Sample](./Sample)

**Migration notes**

- To mark UIViewController as item of SideMenu you should adopt `SideMenuItemContent` protocol instead of inheritance.
To show menu you should call `showSideMenu()` method from this protocol.
```swift
import InteractiveSideMenu

class KittyViewController: UIViewController, SideMenuItemContent {

    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }
}
```
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
- LeftSideMenu with possibility to customize menu animation and content    
- Sample demonstrating using SideMenu library
- README file

[Unreleased]: https://github.com/handsomecode/InteractiveSideMenu/compare/master...feature/nav_and_tab_controllers_support
