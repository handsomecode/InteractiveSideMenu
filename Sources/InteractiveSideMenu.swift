//
//  InteractiveSideMenu.swift
//  InteractiveSideMenu
//
//  Created by Eric Miller on 2/20/18.
//  Copyright © 2018 Handsome. All rights reserved.
//

import Foundation

public protocol InteractiveSideMenuDelegate: class {
    func interactiveSideMenu(_ sideMenu: InteractiveSideMenu, didChangeMenuState menuState: MenuState)
}

public enum MenuState: Int {
    case opening, open, closing, closed
}

/**
 The main interface class of the library.
*/
public class InteractiveSideMenu {

    public static let shared = InteractiveSideMenu()
    public weak var delegate: InteractiveSideMenuDelegate?

    /**
     The options defining side menu transitioning.
     */
    public var transitionOptions: TransitionOptions {
        didSet {
            navigationMenuTransitionDelegate.interactiveTransition.options = transitionOptions
        }
    }

    /**
     Customization options for the appearance of the content item while the menu is open
    */
    public var currentItemOptions = SideMenuItemOptions() {
        didSet {
            navigationMenuTransitionDelegate.currentItemOptions = currentItemOptions
        }
    }

    var containerController: MenuContainerViewController?
    var menuViewController: MenuViewController?
    var menuState: MenuState = .closed {
        didSet {
            delegate?.interactiveSideMenu(self, didChangeMenuState: menuState)
        }
    }
    
    private var navigationMenuTransitionDelegate: MenuTransitioningDelegate

    private init() {
        self.transitionOptions = TransitionOptions()

        let interactiveTransition = MenuInteractiveTransition(currentItemOptions: currentItemOptions)
        interactiveTransition.options = self.transitionOptions
        self.navigationMenuTransitionDelegate = MenuTransitioningDelegate(interactiveTransition: interactiveTransition)

        interactiveTransition.presentAction = { [weak weakSelf = self] in
            guard let strongSelf = weakSelf else { return }
            strongSelf.showSideMenu()
        }
        interactiveTransition.dismissAction = { [weak weakSelf = self] in
            guard let strongSelf = weakSelf else { return }
            strongSelf.closeSideMenu()
        }
    }
}

public extension InteractiveSideMenu {
    /**
     Sets up the host container and side menu controllers for usage inside of the library system.
    */
    func setMenuContainerController(_ containerController: MenuContainerViewController,
                                    menuViewController: MenuViewController) {
        self.containerController = containerController
        setupPanGestureRecognizer(on: containerController)

        menuViewController.transitioningDelegate = navigationMenuTransitionDelegate
        menuViewController.delegate = containerController
        self.menuViewController = menuViewController
    }

    /**
     Notifies the system to show the side menu.
     The animation is implicitly dispatched to the main queue.
    */
    @objc func showSideMenu() {
        guard menuState != .opening || menuState != .open else { return }

        guard let containerController = self.containerController else {
            assertionFailure("Container controller was nil")
            return
        }
        guard let menuViewController = self.menuViewController else {
            assertionFailure("Menu View Controller was nil")
            return
        }

        menuState = .opening
        DispatchQueue.main.async {
            containerController.present(menuViewController, animated: true, completion: { [weak self] in
                self?.menuState = .open
            })
        }
    }

    /**
     Notifies the system to close the side menu.
     The animation is implicitly dispatched to the main queue.
    */
    @objc func closeSideMenu() {
        guard menuState != .closing || menuState != .closed else { return }
        guard let containerController = self.containerController else {
            assertionFailure("Container controller was nil")
            return
        }
        menuState = .closing
        DispatchQueue.main.async {
            containerController.dismiss(animated: true, completion: { [weak self] in
                self?.menuState = .closed
            })
        }
    }
}

private extension InteractiveSideMenu {
    func setupPanGestureRecognizer(on controller: UIViewController) {
        let screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(
            target: navigationMenuTransitionDelegate.interactiveTransition,
            action: #selector(MenuInteractiveTransition.handlePanPresentation(recognizer:))
        )

        screenEdgePanRecognizer.edges = .left
        controller.view.addGestureRecognizer(screenEdgePanRecognizer)
    }
}
