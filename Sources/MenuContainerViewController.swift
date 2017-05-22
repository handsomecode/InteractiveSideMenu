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
    
    public var contentViewControllers: [UIViewController]!
    
    private weak var currentContentViewController: UIViewController?
    private var navigationMenuTransitionDelegate: MenuTransitioningDelegate!
    
    open func menuTransitionOptions() -> TransitionOptions? {
        return nil
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMenuTransitionDelegate = MenuTransitioningDelegate()
        navigationMenuTransitionDelegate.interactiveTransition = MenuInteractiveTransition(
            presentAction: { [weak self] in self?.presentNavigationMenu() },
            dismissAction: { [weak self] in self?.dismiss(animated: true, completion: nil) },
            transitionOptions: menuTransitionOptions()
        )
        
        let screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(
            target: navigationMenuTransitionDelegate.interactiveTransition,
            action: #selector(MenuInteractiveTransition.handlePanPresentation(recognizer:))
        )
        
        screenEdgePanRecognizer.edges = .left
        self.view.addGestureRecognizer(screenEdgePanRecognizer)
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let viewBounds = CGRect(x:0, y:0, width:size.width, height:size.height)
        let viewCenter = CGPoint(x:size.width/2, y:size.height/2)
        coordinator.animate(alongsideTransition: { _ in
            self.menuViewController.view.bounds = viewBounds
            self.menuViewController.view.center = viewCenter
            self.view.bounds = viewBounds
            self.view.center = viewCenter
            self.hideSideMenu()
        }, completion: nil)
    }
    
    public func showSideMenu() {
        presentNavigationMenu()
    }
    
    public func hideSideMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func selectContentViewController(_ selectedContentVC: UIViewController) {
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

    public func updateMenuTransition(options: TransitionOptions) {
        navigationMenuTransitionDelegate.interactiveTransition.updateTransition(options: options)
    }
    
    private func setCurrentView() {
        self.addChildViewController(currentContentViewController!)
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
