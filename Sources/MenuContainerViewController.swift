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

open class MenuContainerViewController: UIViewController {
    
    public var menuViewController: MenuViewController! {
        didSet {
            menuViewController.menuContainerViewController = self
            menuViewController.transitioningDelegate = self.navigationMenuTransitionDelegate
            menuViewController.navigationMenuTransitionDelegate = self.navigationMenuTransitionDelegate
        }
    }
    
    public var contentViewControllers: [MenuItemContentViewController]!
    
    private weak var currentContentViewController: MenuItemContentViewController?
    private var navigationMenuTransitionDelegate: MenuTransitioningDelegate!
    
    open func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
        return nil
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMenuTransitionDelegate = MenuTransitioningDelegate()
        navigationMenuTransitionDelegate.interactiveTransition = MenuInteractiveTransition(
            presentAction: { [weak self] in self?.presentNavigationMenu() },
            dismissAction: { [weak self] in self?.dismiss(animated: true, completion: nil) },
            transitionOptionsBuilder: menuTransitionOptionsBuilder()
        )
        
        let screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(
            target: navigationMenuTransitionDelegate.interactiveTransition,
            action: #selector(MenuInteractiveTransition.handlePanPresentation(recognizer:))
        )
        
        screenEdgePanRecognizer.edges = .left
        self.view.addGestureRecognizer(screenEdgePanRecognizer)
    }
    
    public func showMenu() {
        presentNavigationMenu()
    }
    
    public func hideMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func selectContentViewController(_ selectedContentVC: MenuItemContentViewController) {
        if let currentContentVC = self.currentContentViewController {
            if currentContentVC != selectedContentVC {
                currentContentVC.view.removeFromSuperview()
                currentContentVC.removeFromParentViewController()
                
                self.currentContentViewController = selectedContentVC
                
                setCurrentView()
            }
        } else {
            self.currentContentViewController = selectedContentVC
            setCurrentView()
        }
    }
    
    private func setCurrentView() {
        self.addChildViewController(currentContentViewController!)
        self.view.addSubview(currentContentViewController!.view)
        self.view.addSubviewWithFullSizeConstraints(view: currentContentViewController!.view)
    }
    
    private func presentNavigationMenu() {
        self.present(menuViewController, animated: true, completion: nil)
    }
}

extension UIView {
    func addSubviewWithFullSizeConstraints(view : UIView) {
        insertSubviewWithFullSizeConstraints(view: view, atIndex: self.subviews.count)
    }
    
    func insertSubviewWithFullSizeConstraints(view : UIView, atIndex: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(view, at: atIndex)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view]))
    }
}
