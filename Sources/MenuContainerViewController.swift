//
// MenuContainerViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

/**
 Container for menu view controller.
 */
open class MenuContainerViewController: UIViewController {

    // Describes if side menu is shown or not.
    var isShown = false

    /**
     The view controller for side menu.
     */
    public var menuViewController: MenuViewController! {
        didSet {
            if menuViewController == nil {
                fatalError("Invalid `menuViewController` value. It should not be nil")
            }
            menuViewController.menuContainerViewController = self
            menuViewController.transitioningDelegate = navigationMenuTransitionDelegate
            menuViewController.navigationMenuTransitionDelegate = navigationMenuTransitionDelegate
        }
    }

    /**
     The options defining side menu transitioning.
     Could be set at any time of controller lifecycle.
     */
    public var transitionOptions: TransitionOptions {
        get {
            return navigationMenuTransitionDelegate?.interactiveTransition.options ?? TransitionOptions()
        }
        set {
            navigationMenuTransitionDelegate?.interactiveTransition.options = newValue
        }
    }

    /**
     The list of all content view controllers corresponding to side menu items.
     */
    public var contentViewControllers = [UIViewController]()

    /**
     Shows left side menu.
     */
    public func showSideMenu() {
        presentNavigationMenu()
    }

    /**
     Hides left side menu.
     Controller from the right side will be visible.
     */
    public func hideSideMenu() {
        dismissNavigationMenu()
    }

    /**
     Embeds menu item content view controller.

     - parameter selectedContentVC: The view controller to be embedded.
     */
    public func selectContentViewController(_ selectedContentVC: UIViewController) {
        if let currentContentVC = currentContentViewController {
            if currentContentVC != selectedContentVC {
                currentContentVC.view.removeFromSuperview()
                currentContentVC.removeFromParentViewController()
                setCurrentView(selectedContentVC)
            }
        } else {
            setCurrentView(selectedContentVC)
        }
    }

    // MARK: - Controller lifecycle
    //
    override open func viewDidLoad() {
        super.viewDidLoad()

        navigationMenuTransitionDelegate = MenuTransitioningDelegate(interactiveTransition: MenuInteractiveTransition(
            presentAction: { [unowned self] in
                self.presentNavigationMenu()
            },
            dismissAction: { [unowned self] in
                self.dismissNavigationMenu()
            }
        ))

        let screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(
            target: navigationMenuTransitionDelegate.interactiveTransition,
            action: #selector(MenuInteractiveTransition.handlePanPresentation(recognizer:))
        )

        screenEdgePanRecognizer.edges = .left
        view.addGestureRecognizer(screenEdgePanRecognizer)
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let viewBounds = CGRect(x:0, y:0, width:size.width, height:size.height)
        let viewCenter = CGPoint(x:size.width/2, y:size.height/2)
        coordinator.animate(alongsideTransition: { _ in
            if self.menuViewController == nil {
                fatalError("Invalid `menuViewController` value. It should not be nil")
            }
            self.menuViewController.view.bounds = viewBounds
            self.menuViewController.view.center = viewCenter
            self.view.bounds = viewBounds
            self.view.center = viewCenter
            if self.isShown {
                self.hideSideMenu()
            }
        }, completion: nil)
    }

    // MARK: - Private
    //
    private weak var currentContentViewController: UIViewController?
    private var navigationMenuTransitionDelegate: MenuTransitioningDelegate!

    /**
     Adds proper content view controller as a child.

     - parameter selectedContentVC: The view controller to be added.
     */
    private func setCurrentView(_ selectedContentVC: UIViewController) {
        addChildViewController(selectedContentVC)
        view.addSubviewWithFullSizeConstraints(view: selectedContentVC.view)
        currentContentViewController = selectedContentVC
    }

    /**
     Presents left side menu.
     */
    private func presentNavigationMenu() {
        if menuViewController == nil {
            fatalError("Invalid `menuViewController` value. It should not be nil")
        }
        present(menuViewController, animated: true, completion: nil)
        isShown = true
    }

    /**
     Dismisses left side menu.
     */
    private func dismissNavigationMenu() {
        self.dismiss(animated: true, completion: nil)
        isShown = false
    }
}

extension UIView {
    func addSubviewWithFullSizeConstraints(view : UIView) {
        insertSubviewWithFullSizeConstraints(view: view, atIndex: subviews.count)
    }

    func insertSubviewWithFullSizeConstraints(view : UIView, atIndex: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, at: atIndex)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view]))
    }
}
