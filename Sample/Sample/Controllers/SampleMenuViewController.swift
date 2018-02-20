//
// SampleMenuViewController.swift
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
import InteractiveSideMenu

/**
 Menu controller is responsible for creating its content and showing/hiding menu using 'menuContainerViewController' property.
 */
class SampleMenuViewController: MenuViewController, Storyboardable {

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var avatarImageViewCenterXConstraint: NSLayoutConstraint!
    private var gradientLayer = CAGradientLayer()
    private var selectedIndexPath: IndexPath?

    private var gradientApplied: Bool = false

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentControllerTypes = createSideMenuContent()

        // Select the initial row
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        selectedIndexPath = indexPath

        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageViewCenterXConstraint.constant = -(InteractiveSideMenu.shared.transitionOptions.visibleContentWidth/2)

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        let topColor = UIColor(red: 16.0/255.0, green: 12.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 57.0/255.0, green: 33.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension SampleMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentControllerTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SampleTableCell.self), for: indexPath) as? SampleTableCell else {
            preconditionFailure("Unregistered table view cell")
        }
        
        cell.titleLabel.text = contentControllerTypes[indexPath.row].menuTitle

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath, selectedIndexPath == indexPath {
            InteractiveSideMenu.shared.closeSideMenu()
            return
        }

        let controllerType = contentControllerTypes[indexPath.row].classType
        let storyboard = UIStoryboard(name: String(describing: controllerType.self), bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {
            preconditionFailure("Invalid initial view controller")
        }
        selectSideItemContent(controller)
        selectedIndexPath = indexPath
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}

private extension SampleMenuViewController {
    func createSideMenuContent() -> [SideMenuItemContent] {
        let kittyContent = SideMenuItemContent(menuTitle: "Kitty", classType: KittyViewController.self)
        let tabBarContent = SideMenuItemContent(menuTitle: "Tab Bar", classType: TabBarViewController.self)
        let tweakContent = SideMenuItemContent(menuTitle: "Tweak Settings", classType: TweakViewController.self)

        return [kittyContent, tabBarContent, tweakContent]
    }
}
