//
// MenuViewController.swift
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

@objc public protocol MenuViewController
{
    // UIViewController
    var transitioningDelegate: UIViewControllerTransitioningDelegate? { get set }
    var view: UIView! { get }
    
    // MenuViewController
    weak var menuContainerViewController: MenuContainerViewController? { get set }
    var navigationMenuTransitionDelegate: MenuTransitioningDelegate? { get set }
    @objc func handleTap(recognizer: UIGestureRecognizer)
}

private var key_menuContainerViewController = "menuContainerViewController"
private var key_navigationMenuTransitionDelegate = "navigationMenuTransitionDelegate"

extension UIViewController: MenuViewController
{
    public var menuContainerViewController: MenuContainerViewController?
    {
        get {
            return objc_getAssociatedObject(self, &key_menuContainerViewController) as? MenuContainerViewController
        }
        set {
            objc_setAssociatedObject(self, &key_menuContainerViewController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationMenuTransitionDelegate: MenuTransitioningDelegate?
    {
        get {
            return objc_getAssociatedObject(self, &key_navigationMenuTransitionDelegate) as? MenuTransitioningDelegate
        }
        set {
            objc_setAssociatedObject(self, &key_navigationMenuTransitionDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func handleTap(recognizer: UIGestureRecognizer) {
        menuContainerViewController?.hideSideMenu()
    }
}

