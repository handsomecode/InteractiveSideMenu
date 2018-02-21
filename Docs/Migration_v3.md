# Migration Guide to v3.x

The main interaction points for the InteractiveSideMenu library have shifted in v3.  Instead of largely interacting with the `MenuContainerViewController`, a new handler object, `InteractiveSideMenu`, has been created to better manage the global state of the side menu.


## MenuContainerViewController -> InteractiveSideMenu
`MenuContainerViewController` no longer manages the side menu controller, transition options, or the transition delegate.  In order to reduce complexity and performance overhead, this logic has been moved to the `InteractiveSideMenu` handler.  This allows the menu to be accessed at a more global level.

The `menuViewController` property on the `MenuContainerViewController` is now set on the `InteractiveSideMenu` using
```swift
func setMenuContainerController(_ containerController: MenuContainerViewController,
                                menuViewController: MenuViewController)
```

The same applies to the `transitionOptions` and `currentItemOptions` properties of the `MenuContainerViewController`.  These are also now on the `InteractiveSideMenu` handler.

Using the Sample project as an example, the Host Controller's `viewDidLoad()` function goes from
```swift
class HostViewController: MenuContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
        self.menuViewController = SampleMenuViewController.storyboardViewController()
        self.contentViewControllers = contentControllers()
        self.selectContentViewController(contentViewControllers.first!)
        self.currentItemOptions.cornerRadius = 10.0
    }
}
```
to 
```swift
class HostViewController: MenuContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuViewController = SampleMenuViewController.storyboardViewController()
        InteractiveSideMenu.shared.setMenuContainerController(self, menuViewController: menuViewController)

        let screenSize: CGRect = UIScreen.main.bounds
        let transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
        InteractiveSideMenu.shared.transitionOptions = transitionOptions
        InteractiveSideMenu.shared.currentItemOptions.cornerRadius = 10.0

        menuViewController.selectInitialContentController(KittyViewController.storyboardViewController())
    }
```

## MenuContainerViewController -> MenuViewController
Management of the menu items has moved exclusively to the `MenuViewController`.

`MenuViewController` has a new property for storing the array of side menu items
```swift
public var itemContentControllers = [SideMenuItemContent]()
```

`SideMenuItemContent` is no longer a protocol. It is now a struct that holds the necessary data to display the side menu item and instantiate the content controller when needed
```swift
public struct SideMenuItemContent {
    public let menuTitle: String
    public let classType: UIViewController.Type
    public let menuImage: UIImage?

    public init(menuTitle: String, menuImage: UIImage? = nil, classType: UIViewController.Type) {
        self.menuTitle = menuTitle
        self.menuImage = menuImage
        self.classType = classType
    }
}
```

This allows the content controllers on demand rather than preloading everything when the Host Container is instantiated.  Here is how the Sample app creates the content controllers
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controllerType = itemContentControllers[indexPath.row].classType
        let storyboard = UIStoryboard(name: String(describing: controllerType.self), bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {
            preconditionFailure("Invalid initial view controller")
        }
        selectSideItemContent(controller)
    }
```

This also now means that controls are deinit'd when not in use by the side menu.

## Opening and Closing the side menu
In v2, `MenuContainerViewController` was responsible for opening and closing the side menu.  These actions have no been moved to the `InteractiveSideMenu` handler.  This removes the need for content controllers to conform to any protocols or create any "weird" workarounds to get the menu to open and close.

To open the menu, use
```swift
InteractiveSideMenu.shared.showSideMenu()
```
To close it
```swift
InteractiveSideMenu.shared.closeSideMenu()
```

