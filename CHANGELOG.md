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

    @IBAction func didOpenMenu(_ sender: UIButton) {
        showSideMenu()
    }
}
```
- To set custom animation options you should now override ```menuTransitionOptions()``` method from ```MenuContainerViewColtroller``` class.
```swift
override func menuTransitionOptions() -> TransitionOptions? {
    var options = TransitionOptions(duration: 0.4, contentScale: 0.9)
    options.useFinishingSpringOption = false
    options.useCancelingSpringOption = false
    return options
}
```

- Now you have possibility to update customization settings using ```viewWillTransition(to:with:)``` mehod.
```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    var options = TransitionOptions()
    options.duration = size.width < size.height ? 0.4 : 0.6
    options.visibleContentWidth = size.width / 5
    updateMenuTransition(options: options)
}
```

## 1.0 - 2017-01-23
### Added
- LeftSideMenu with possibility to customize menu animation and content    
- Sample demonstrating using SideMenu library
- README file

[Unreleased]: https://github.com/handsomecode/InteractiveSideMenu/compare/master...feature/nav_and_tab_controllers_support
