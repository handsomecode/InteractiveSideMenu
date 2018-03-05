# Change Log
All notable changes of the library will be documented in this file.

## 3.0
Please review the v2 -> v3 migration guide _before_ updating to this version to make sure you understand the changes that will be needed.  Portions of the public interface needed to be changed to make the internals of the library more robust and scalable.

### Added
- `InteractiveSideMenu` is a global helper class for managing the current open/close state of the side menu.
- `InteractiveSideMenuDelegate` to provide callbacks for open/close state changes of the side menu.
- `sectionItemContentControllers` for handling a side menu with sections
- `TransitionOptions` has a new flag called `rightToLeft` that allows the side menu to be opened either Left-to-Right or Right-to-Left.

### Changed
- Content controllers are no longer pre-loaded when `MenuContainerViewController` is created and are now init'd/deinit'd only when needed.

### Breaking
- InteractiveSideMenu is now built using Swift 4.
- Most of the presentation logic in `MenuContainerViewController` is now handled by `InteractiveSideMenu`.
- Changed how `SideMenuItemContent` works.

## 2.3
### Changed
- Renamed `SideMenuItemShadow` to `SideMenuItemOptions` to allow for additional visual properties to be changed. (Sorry for the volitility. The new name gives better flexibility going forward.)
- Moved the drop shadow customization for the opened menu item to a property on `SideMenuItemOption` called `shadow`.  Use the `Shadow` struct now to assign your custom values.
- `MenuContainerViewController`'s `shadowOptions` property has been renamed to `currentItemOptions`

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
