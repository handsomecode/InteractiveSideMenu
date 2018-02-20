//
//  InteractiveSideMenu.swift
//  InteractiveSideMenu
//
//  Created by Eric Miller on 2/20/18.
//  Copyright © 2018 Handsome. All rights reserved.
//

import Foundation

enum MenuState {
    case opening, open, closing, closed
}

public class InteractiveSideMenu {

    public static let shared = InteractiveSideMenu()

    /**
     The options defining side menu transitioning.
     */
    public var transitionOptions: TransitionOptions {
        didSet {
            navigationMenuTransitionDelegate.interactiveTransition.options = transitionOptions
        }
    }
    public var currentItemOptions = SideMenuItemOptions() {
        didSet {
            navigationMenuTransitionDelegate.currentItemOptions = currentItemOptions
        }
    }

    var containerController: MenuContainerViewController?
    var menuViewController: MenuViewController?
    var menuState: MenuState = .closed
    
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
    func setMenuContainerController(_ containerController: MenuContainerViewController,
                                    menuViewController: MenuViewController) {
        self.containerController = containerController
        setupPanGestureRecognizer(on: containerController)

        menuViewController.transitioningDelegate = navigationMenuTransitionDelegate
        menuViewController.delegate = containerController
        self.menuViewController = menuViewController
    }

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
