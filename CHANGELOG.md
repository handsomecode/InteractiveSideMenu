# Change Log
All notable changes to the library will be documented in this file.

## [Unreleased]
### Added
- UITabBarController and UINavigationController menu items support
- Rotation support (plan)
- Right SideMenu support (plan)
- CHANGELOG file

### Changed
- Renamed `showMenu()`/`hideMenu()` methods to `showSideMenu()`/`hideSideMenu()`

### Fixed
- Displaying horizontal images in [Sample](./Sample)

**Migration note:** to mark UIViewController as item of SideMenu you should adopt `SideMenuItemContent` protocol instead of inheritance.
To show menu you should call `showSideMenu()` method from this protocol.
```swift
import InteractiveSideMenu

class KittyViewController: UIViewController, SideMenuItemContent {

    @IBAction func didOpenMenu(_ sender: UIButton) {
        showSideMenu()
    }
}
```

## 1.0 - 2017-01-23
### Added
- LeftSideMenu with possibility to customize menu animation and content    
- Sample demonstrating using SideMenu library
- README file

[Unreleased]: https://github.com/handsomecode/InteractiveSideMenu/compare/master...feature/nav_and_tab_controllers_support
