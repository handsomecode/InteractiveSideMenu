//
// MenuAnimator.swift
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
 Options that define menu transition settings.
 Class lets user customize their transitioning animation: duration, content scale, visible content width, animationOptions, using spring animation or not and params if yes.
 */
public struct TransitionOptions {

    /**
     The duration of showing/hiding menu animation. Default value is 0.5.
     */
    public var duration: TimeInterval = 0.5 {
        willSet(newDuration) {
            if(newDuration < 0) {
                fatalError("Invalid `duration` value (\(newDuration)). It must be non negative")
            }
        }
    }

    /**
     The scale factor of content menu item when the menu is opened. Default value is 0.88.
     */
    public var contentScale: CGFloat = 0.88 {
        willSet(newContentScale) {
            if(newContentScale < 0) {
                fatalError("Invalid `contentScale` value (\(newContentScale)). It must be non negative")
            }
        }
    }

    /// The width of visible part of content menu item when the menu is shown. Default value is 56 points.
    public var visibleContentWidth: CGFloat = 56.0

    /// Defines if spring animation will be used on menu transition finishing. Default value is true.
    public var useFinishingSpringSettings = true

    /// Defines if spring animation will be used on menu transition cancelling (when user let draggable view to go back to the begining position). Default value is true.
    public var useCancellingSpringSettings = true

    /// Spring animation settings if `useFinishingSpringSettings` is set to true.
    public var finishingSpringSettings = SpringSettings(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.3),
                                                    dismissSpringParams: SpringParams(dampingRatio:
                                                        0.8, velocity: 0.3))
    /// Spring animation settings if `useCancellingSpringSettings` is set to true.
    public var cancellingSpringSettings = SpringSettings(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0),
                                                    dismissSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0))

    /// Regular view animation options. Default value is `curveEaseInOut`.
    public var animationOptions: UIViewAnimationOptions = .curveEaseInOut

    public init() {
    }

    public init(duration: TimeInterval) {
        self.duration = duration
    }

    public init(contentScale: CGFloat) {
        self.contentScale = contentScale
    }

    public init(visibleContentWidth: CGFloat) {
        self.visibleContentWidth = visibleContentWidth
    }

    public init(duration: TimeInterval, contentScale: CGFloat) {
        self.duration = duration
        self.contentScale = contentScale
    }

    public init(duration: TimeInterval, visibleContentWidth: CGFloat) {
        self.duration = duration
        self.visibleContentWidth = visibleContentWidth
    }

    public init(contentScale: CGFloat, visibleContentWidth: CGFloat) {
        self.contentScale = contentScale
        self.visibleContentWidth = visibleContentWidth
    }

    public init(duration: TimeInterval, contentScale: CGFloat, visibleContentWidth: CGFloat) {
        self.duration = duration
        self.contentScale = contentScale
        self.visibleContentWidth = visibleContentWidth
    }
}

/**
 Settings of spring animation for presenting and dismissing actions.
 */
public struct SpringSettings {
    let presentSpringParams: SpringParams
    let dismissSpringParams: SpringParams

    public init(presentSpringParams: SpringParams, dismissSpringParams: SpringParams) {
        self.presentSpringParams = presentSpringParams
        self.dismissSpringParams = dismissSpringParams
    }
}

/**
 Basic spring params.
 */
public struct SpringParams {

    /// The damping ratio from 0 to 1 for the spring animation as it approaches its quiescent state.
    let dampingRatio: CGFloat

    /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity.
    let velocity: CGFloat

    public init(dampingRatio: CGFloat, velocity: CGFloat) {
        self.dampingRatio = dampingRatio
        self.velocity = velocity
    }
}

/**
 Delegate of menu transitioning actions.
 */
class MenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveTransition: MenuInteractiveTransition!
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if interactiveTransition == nil {
            fatalError("Invalid `interactiveTransition` value. This property should not be nil")
        }
        interactiveTransition.present = true
        
        return interactiveTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if interactiveTransition == nil {
            fatalError("Invalid `interactiveTransition` value. This property should not be nil")
        }
        interactiveTransition.present = false
        
        return interactiveTransition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveTransition == nil {
            fatalError("Invalid `interactiveTransition` value. This property should not be nil")
        }
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveTransition == nil {
            fatalError("Invalid `interactiveTransition` value. This property should not be nil")
        }
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }
}

/**
 The side menu interactive transitioning implementation.
 */
class MenuInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning {
    
    typealias Action = () -> ()
    
    //MARK: - Properties
    //
    var present: Bool = false
    var interactionInProgress: Bool = false

    var options = TransitionOptions()
    private let presentAction: Action
    private let dismissAction: Action
    
    private var transitionShouldStarted = false
    private var transitionStarted = false
    private var transitionContext: UIViewControllerContextTransitioning?
    private var contentSnapshotView: UIView?

    private var tapRecognizer: UITapGestureRecognizer?
    private var panRecognizer: UIPanGestureRecognizer?
    
    required init(presentAction: @escaping Action, dismissAction: @escaping Action) {

        self.presentAction = presentAction
        self.dismissAction = dismissAction
        super.init()
    }
    
    //MARK: - Delegate methods
    //
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        startTransition(transitionContext: transitionContext)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return options.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startTransition(transitionContext: transitionContext)
        
        finishTransition(currentPercentComplete: 0)
    }
    
    func handlePanPresentation(recognizer: UIPanGestureRecognizer) {
        present = true
        
        handlePan(recognizer: recognizer)
    }
    
    func handlePanDismission(recognizer: UIPanGestureRecognizer) {
        present = false
        
        handlePan(recognizer: recognizer)
    }

    //MARK: - Private methods
    //
    private func createSnapshotView(from: UIView) -> UIView {
        guard let snapshotView = from.snapshotView(afterScreenUpdates: true) else {
            print("Invalid snapshot view. Default color will be used")
            let placeholderView = UIView()
            placeholderView.frame = from.frame
            placeholderView.backgroundColor = from.backgroundColor
            addShadow(toView: placeholderView)
            return placeholderView
        }
        addShadow(toView: snapshotView)
        return snapshotView
    }

    private func addShadow(toView: UIView) {
        toView.layer.shadowColor = UIColor.black.cgColor
        toView.layer.shadowOpacity = 0.3
        toView.layer.shadowOffset = CGSize(width: -5, height: 5)
    }

    private func removeShadow(fromView: UIView) {
        fromView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    private func startTransition(transitionContext: UIViewControllerContextTransitioning) {
        transitionStarted = true
        
        self.transitionContext = transitionContext
        
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            fatalError("Invalid fromViewController key. Can't start transition")
        }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            fatalError("Invalid toViewController key. Can't start transition")
        }
        let containerView = transitionContext.containerView
        
        let screenWidth = containerView.frame.size.width
        
        if present {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            if self.tapRecognizer == nil {

                guard toViewController is MenuViewController else {
                    fatalError("Invalid toViewController type. It must be MenuViewController")
                }
                self.tapRecognizer = UITapGestureRecognizer(target: toViewController,
                                                            action: #selector(MenuViewController.handleTap(recognizer:)))
                self.panRecognizer = UIPanGestureRecognizer(target: self,
                                                        action: #selector(MenuInteractiveTransition.handlePanDismission(recognizer:)))
            }

            contentSnapshotView = createSnapshotView(from: fromViewController.view)

            guard let contentSnapshotView = self.contentSnapshotView else {
                fatalError("Invalid `contentSnapshotView` value. This property should not be nil")
            }

            containerView.addSubview(contentSnapshotView)

            fromViewController.view.isHidden = true
        } else {
            containerView.addSubview(toViewController.view)

            toViewController.view.transform = CGAffineTransform(scaleX: options.contentScale, y: options.contentScale)
            addShadow(toView: toViewController.view)

            let newOrigin = CGPoint(x: screenWidth - options.visibleContentWidth, y: toViewController.view.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: toViewController.view.frame.size)

            toViewController.view.frame = rect
        }

        toViewController.view.isUserInteractionEnabled = false
        fromViewController.view.isUserInteractionEnabled = false
    }

    private func updateTransition(percentComplete: CGFloat) {
        guard let transitionContext = self.transitionContext else {
            fatalError("Invalid `transitionContext` value. This property should not be nil")
        }
        let containerView = transitionContext.containerView
        let screenWidth = containerView.frame.size.width
        
        let totalWidth = screenWidth - options.visibleContentWidth

        guard let contentSnapshotView = self.contentSnapshotView else {
            fatalError("Invalid `contentSnapshotView` value. This property should not be nil")
        }
        
        if present {

            let newScale = 1 - (1 - options.contentScale) * percentComplete
            let newX = totalWidth * percentComplete

            contentSnapshotView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
            
            let newOrigin = CGPoint(x: newX, y: contentSnapshotView.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: contentSnapshotView.frame.size)
            
            contentSnapshotView.frame = rect
        } else {
            contentSnapshotView.isHidden = true

            guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                fatalError("Invalid toViewController key. Can't update transition")
            }
            let newX = totalWidth * (1 - percentComplete)

            let newScale = options.contentScale + (1 - options.contentScale) * percentComplete
            toViewController.view.transform = CGAffineTransform(scaleX: newScale, y: newScale)

            let newOrigin = CGPoint(x: newX, y: toViewController.view.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: toViewController.view.frame.size)

            toViewController.view.frame = rect
        }
    }
    
    private func finishTransition(currentPercentComplete : CGFloat) {
        transitionStarted = false

        let animation : () -> Void = { [weak self] in self?.updateTransition(percentComplete: 1.0) }
        let completion : (Bool) -> Void = { [weak self] _ in
            if let transition = self {
                guard let transitionContext = transition.transitionContext else {
                    fatalError("Invalid `transition.transitionContext` value. This property should not be nil")
                }
                guard let contentSnapshotView = transition.contentSnapshotView else {
                    fatalError("Invalid `transition.contentSnapshotView` value. This property should not be nil")
                }
                guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                    fatalError("Invalid fromViewController key. Can't finish transition")
                }
                guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                    fatalError("Invalid toViewController key. Can't finish transition")
                }

                if transition.present {
                    fromViewController.view.isHidden = false
                    contentSnapshotView.removeFromSuperview()

                    if let panRecognizer = transition.panRecognizer {
                        contentSnapshotView.addGestureRecognizer(panRecognizer)
                    }
                    if let tapRecognizer = transition.tapRecognizer {
                        contentSnapshotView.addGestureRecognizer(tapRecognizer)
                    }

                    toViewController.view.addSubview(contentSnapshotView)
                } else {
                    toViewController.view.isHidden = false
                    transition.removeShadow(fromView: toViewController.view)
                }
                
                toViewController.view.isUserInteractionEnabled = true
                fromViewController.view.isUserInteractionEnabled = true
                
                transitionContext.completeTransition(true)
            }
        }
        
        if options.useFinishingSpringSettings {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           usingSpringWithDamping: present ? options.finishingSpringSettings.presentSpringParams.dampingRatio : options.finishingSpringSettings.dismissSpringParams.dampingRatio,
                           initialSpringVelocity: present ? options.finishingSpringSettings.presentSpringParams.velocity : options.finishingSpringSettings.dismissSpringParams.velocity,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        } else {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        }
    }
    
    private func cancelTransition(currentPercentComplete : CGFloat) {
        transitionStarted = false
        
        let animation : () -> Void = { [weak self] in self?.updateTransition(percentComplete: 0) }
        let completion : (Bool) -> Void = { [weak self] _ in
            if let transition = self {

                guard let transitionContext = transition.transitionContext else {
                    fatalError("Invalid `transition.transitionContext` value. This property should not be nil")
                }
                guard let contentSnapshotView = transition.contentSnapshotView else {
                    fatalError("Invalid `transition.contentSnapshotView` value. This property should not be nil")
                }
                guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                    fatalError("Invalid fromViewController key. Can't cancel transition")
                }
                guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                    fatalError("Invalid toViewController key. Can't cancel transition")
                }
                
                if transition.present {
                    fromViewController.view.isHidden = false
                } else {
                    toViewController.view.removeFromSuperview()
                    contentSnapshotView.isHidden = false
                    fromViewController.view.isUserInteractionEnabled = true
                }
                
                toViewController.view.isUserInteractionEnabled = true
                fromViewController.view.isUserInteractionEnabled = true
                
                transitionContext.completeTransition(false)
            }
        }
        
        if options.useCancellingSpringSettings {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           usingSpringWithDamping: present ? options.cancellingSpringSettings.presentSpringParams.dampingRatio : options.cancellingSpringSettings.dismissSpringParams.dampingRatio,
                           initialSpringVelocity: present ? options.cancellingSpringSettings.presentSpringParams.velocity : options.cancellingSpringSettings.dismissSpringParams.velocity,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        } else {
            UIView.animate(withDuration: options.duration - options.duration * Double(currentPercentComplete),
                           delay: 0,
                           options: options.animationOptions,
                           animations: animation,
                           completion: completion)
        }
    }
    
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            fatalError("Invalid recognizer view value")
        }
        let translation = recognizer.translation(in: recognizerView)
        let dx = translation.x / recognizerView.bounds.width
        let progress: CGFloat = abs(dx)
        var velocity = recognizer.velocity(in: recognizerView).x
        
        if !present {
            velocity = -velocity
        }

        switch recognizer.state {
            case .began:
                interactionInProgress = true
                
                if velocity >= 0 {
                    transitionShouldStarted = true
                    if present {
                        presentAction()
                    } else {
                        dismissAction()
                    }
                }
                
            case .changed:
                if transitionStarted && (present && dx > 0 || !present && dx < 0) {
                    guard let transitionContext = transitionContext else {
                        fatalError("Invalid `transitionContext` value. This property should not be nil")
                    }
                    updateTransition(percentComplete: progress)
                    transitionContext.updateInteractiveTransition(progress)
                }
            
            case .cancelled, .ended:
                if transitionStarted {
                    guard let transitionContext = transitionContext else {
                        fatalError("Invalid `transitionContext` value. This property should not be nil")
                    }
                    if progress > 0.4 && velocity >= 0 || progress > 0.01 && velocity > 100 {
                        finishTransition(currentPercentComplete: progress)
                        transitionContext.finishInteractiveTransition()
                    } else {
                        cancelTransition(currentPercentComplete: progress)
                        transitionContext.cancelInteractiveTransition()
                    }

                } else if transitionShouldStarted && !transitionStarted {
                    if transitionStarted {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            guard let transitionContext = self.transitionContext else {
                                fatalError("Invalid `transitionContext` value. This property should not be nil")
                            }
                            if self.transitionStarted {
                                self.cancelTransition(currentPercentComplete: progress)
                                transitionContext.cancelInteractiveTransition()
                            }
                        }
                    }
                }
        
                transitionShouldStarted = false
                interactionInProgress = false
        
            default:
                break
        }
    }
}
