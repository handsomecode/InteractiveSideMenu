# Change Log
All notable changes to this library will be documented in this file.

## [Unreleased]
### Added
- Added UITabBarController and UINavigationController menu items support
- Rotation support
- Right SideMenu support
- CHANGELOG file

### Changed
- Renamed `showMenu()` method to `showSideMenu()`

### Fixed
- Fixed displayng horizontal images in Sample

*Migration note:* To mark UIViewController as item of SideMenu you should adopt `SideMenuItemContent` protocol instead of inheritance.
To show menu you should call `showSideMenu()` method from `SideMenuItemContent` protocol.
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
- LeftSideMenu with possibility to customize menu animation and content size
- Sample demonstrating using SideMenu library
- README file

[2.0]: https://github.com/handsomecode/InteractiveSideMenu/compare/master...feature/nav_and_tab_controllers_support
