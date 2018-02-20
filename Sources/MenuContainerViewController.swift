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

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentContentViewController?.preferredStatusBarStyle ?? .lightContent
    }

    fileprivate weak var currentContentViewController: UIViewController?

    /**
     The list of all content view controllers corresponding to side menu items.
     */
    public var contentViewControllers = [UIViewController]()

    // MARK: - Controller lifecycle
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let sideMenu = InteractiveSideMenu.shared
        if let menuViewController = sideMenu.menuViewController {
            let viewBounds = CGRect(x: 0.0, y: 0.0, width:size.width, height:size.height)
            let viewCenter = CGPoint(x: (size.width / 2), y: (size.height / 2))
            coordinator.animate(alongsideTransition: { _ in
                menuViewController.view.bounds = viewBounds
                menuViewController.view.center = viewCenter
                self.view.bounds = viewBounds
                self.view.center = viewCenter
                if sideMenu.menuState == .open {
                    InteractiveSideMenu.shared.closeSideMenu()
                }
            }, completion: nil)
        }
    }
}

// MARK: - Public
extension MenuContainerViewController {
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
}

extension MenuContainerViewController: MenuViewControllerDelegate {
    func menuController(_ menuController: MenuViewController, showContentController contentController: UIViewController) {
        selectContentViewController(contentController)
        InteractiveSideMenu.shared.closeSideMenu()
    }
}

// MARK: - Private
private extension MenuContainerViewController {
    /**
     Adds proper content view controller as a child.

     - parameter selectedContentVC: The view controller to be added.
     */
    func setCurrentView(_ selectedContentVC: UIViewController) {
        addChildViewController(selectedContentVC)
        view.addSubviewWithFullSizeConstraints(view: selectedContentVC.view)
        currentContentViewController = selectedContentVC
    }
}

extension UIView {
    func addSubviewWithFullSizeConstraints(view : UIView) {
        insertSubviewWithFullSizeConstraints(view: view, atIndex: subviews.count)
    }

    func insertSubviewWithFullSizeConstraints(view : UIView, atIndex: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, at: atIndex)

        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}
