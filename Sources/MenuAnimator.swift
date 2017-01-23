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

public class TransitionOptionsBuilder {
    
    public var duration: TimeInterval = 0.5 {
        willSet(newDuration) {
            if(newDuration < 0) {
                fatalError("Invalid duration value (\(newDuration)). It must be non negative")
            }
        }
    }
    
    public var contentScale: CGFloat = 0.88 {
        willSet(newContentScale) {
            if(newContentScale < 0) {
                fatalError("Invalid contentScale value (\(newContentScale)). It must be non negative")
            }
        }
    }
    
    public var visibleContentWidth: CGFloat = 56.0
    public var useFinishingSpringOption = true
    public var useCancelingSpringOption = true
    public var finishingSpringOption = SpringOption(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.3),
                                                    dismissSpringParams: SpringParams(dampingRatio: 0.8, velocity: 0.3))
    public var cancelingSpringOption = SpringOption(presentSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0),
                                                    dismissSpringParams: SpringParams(dampingRatio: 0.7, velocity: 0.0))
    public var animationOptions: UIViewAnimationOptions = .curveEaseInOut
    
    public init(building: (TransitionOptionsBuilder) -> Void) {
        building(self)
    }
    
    class func defaultOptionsBuilder() -> TransitionOptionsBuilder {
        return TransitionOptionsBuilder(){_ in }
    }
}


public struct SpringParams {
    let dampingRatio: CGFloat
    let velocity: CGFloat
}


public struct SpringOption {
    let presentSpringParams: SpringParams
    let dismissSpringParams: SpringParams
}


class MenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveTransition: MenuInteractiveTransition!
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactiveTransition.present = true
        
        return interactiveTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactiveTransition.present = false
        
        return interactiveTransition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.interactionInProgress ? interactiveTransition : nil
    }
}

class MenuInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning {
    
    typealias Action = () -> ()
    
    //MARK: - Properties
    var present: Bool = false
    var interactionInProgress: Bool = false
    
    private var transitionDuration: TimeInterval!
    private var scaleDiff: CGFloat!
    private var visibleContentWidth: CGFloat!
    private var useFinishingSpringOption: Bool!
    private var useCancelingSpringOption: Bool!
    private var finishingSpringOption: SpringOption!
    private var cancelingSpringOption: SpringOption!
    private var animationOptions: UIViewAnimationOptions!
    
    private var presentAction: Action!
    private var dismissAction: Action!
    
    private var transitionShouldStarted = false
    private var transitionStarted = false
    private var transitionContext: UIViewControllerContextTransitioning!
    private var contentSnapshotView: UIView!

    private var tapRecognizer: UITapGestureRecognizer!
    private var panRecognizer: UIPanGestureRecognizer!
    
    required init(presentAction: @escaping Action, dismissAction: @escaping Action, transitionOptionsBuilder: TransitionOptionsBuilder? = nil) {
        super.init()
  
        self.presentAction = presentAction
        self.dismissAction = dismissAction
        
        let options = transitionOptionsBuilder ?? TransitionOptionsBuilder.defaultOptionsBuilder()
        
        self.transitionDuration = options.duration
        self.scaleDiff = 1 - options.contentScale
        self.visibleContentWidth = options.visibleContentWidth
        self.useFinishingSpringOption = options.useFinishingSpringOption
        self.useCancelingSpringOption = options.useCancelingSpringOption
        self.finishingSpringOption = options.finishingSpringOption
        self.cancelingSpringOption = options.cancelingSpringOption
        self.animationOptions = options.animationOptions
    }
    
    //MARK: - Delegate methods
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        startTransition(transitionContext: transitionContext)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
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

    private func createSnapshotView(from: UIView) -> UIView {
        let snapshotView = from.snapshotView(afterScreenUpdates: true)!
        snapshotView.frame = from.frame
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
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let screenWidth = containerView.frame.size.width
        
        if present {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            self.tapRecognizer = UITapGestureRecognizer(target: toViewController as! MenuViewController,
                                                        action: #selector(MenuViewController.handleTap(recognizer:)))
            
            self.panRecognizer = UIPanGestureRecognizer(target: self,
                                                        action: #selector(MenuInteractiveTransition.handlePanDismission(recognizer:)))

            contentSnapshotView = createSnapshotView(from: fromViewController.view)
            containerView.addSubview(contentSnapshotView)

            fromViewController.view.isHidden = true
        } else {
            containerView.addSubview(toViewController.view)

            toViewController.view.transform = CGAffineTransform(scaleX: 1 - scaleDiff, y: 1 - scaleDiff)
            addShadow(toView: toViewController.view)

            let newOrigin = CGPoint(x: screenWidth - visibleContentWidth, y: toViewController.view.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: toViewController.view.frame.size)

            toViewController.view.frame = rect
        }

        toViewController.view.isUserInteractionEnabled = false
        fromViewController.view.isUserInteractionEnabled = false
    }

    private func updateTransition(percentComplete: CGFloat) {
        let containerView = transitionContext.containerView
        let screenWidth = containerView.frame.size.width
        
        let totalWidth = screenWidth - visibleContentWidth
        
        if present {

            let newScale = 1 - (scaleDiff * percentComplete)
            let newX = totalWidth * percentComplete

            contentSnapshotView.transform = CGAffineTransform(scaleX: newScale, y: newScale)
            
            let newOrigin = CGPoint(x: newX, y: contentSnapshotView.frame.origin.y)
            let rect = CGRect(origin: newOrigin, size: contentSnapshotView.frame.size)
            
            contentSnapshotView.frame = rect
        } else {
            contentSnapshotView.isHidden = true

            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            let newX = totalWidth * (1 - percentComplete)

            let newScale = 1 - scaleDiff + (scaleDiff * percentComplete)
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
                let fromViewController = transition.transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
                let toViewController = transition.transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
                
                if transition.present {
                    fromViewController.view.isHidden = false
                    
                    transition.contentSnapshotView.removeFromSuperview()
                    transition.contentSnapshotView.addGestureRecognizer(transition.panRecognizer)
                    transition.contentSnapshotView.addGestureRecognizer(transition.tapRecognizer)
                    
                    toViewController.view.addSubview(transition.contentSnapshotView)
                } else {
                    toViewController.view.isHidden = false
                    transition.removeShadow(fromView: toViewController.view)
                }
                
                toViewController.view.isUserInteractionEnabled = true
                fromViewController.view.isUserInteractionEnabled = true
                
                transition.transitionContext.completeTransition(true)
            }
        }
        
        guard let useFinishingSpringOption = self.useFinishingSpringOption else {
            return
        }
        
        if useFinishingSpringOption {
            UIView.animate(withDuration: transitionDuration - transitionDuration * Double(currentPercentComplete),
                           delay: 0,
                           usingSpringWithDamping: present ? finishingSpringOption.presentSpringParams.dampingRatio : finishingSpringOption.dismissSpringParams.dampingRatio,
                           initialSpringVelocity: present ? finishingSpringOption.presentSpringParams.velocity : finishingSpringOption.dismissSpringParams.velocity,
                           options: animationOptions,
                           animations: animation,
                           completion: completion)
        } else {
            UIView.animate(withDuration: transitionDuration - transitionDuration * Double(currentPercentComplete),
                           delay: 0,
                           options: animationOptions,
                           animations: animation,
                           completion: completion)
        }
    }
    
    private func cancelTransition(currentPercentComplete : CGFloat) {
        transitionStarted = false
        
        let animation : () -> Void = { [weak self] in self?.updateTransition(percentComplete: 0) }
        let completion : (Bool) -> Void = { [weak self] _ in
            if let transition = self {
                let fromViewController = transition.transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
                let toViewController = transition.transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
                
                if transition.present {
                    fromViewController.view.isHidden = false
                } else {
                    toViewController.view.removeFromSuperview()
                    transition.contentSnapshotView.isHidden = false
                    fromViewController.view.isUserInteractionEnabled = true
                }
                
                toViewController.view.isUserInteractionEnabled = true
                fromViewController.view.isUserInteractionEnabled = true
                
                transition.transitionContext.completeTransition(false)
            }
        }
        
        guard let useCancelingSpringOption = self.useCancelingSpringOption else {
            return
        }
        
        if useCancelingSpringOption {
            UIView.animate(withDuration: transitionDuration - transitionDuration * Double(currentPercentComplete),
                           delay: 0,
                           usingSpringWithDamping: present ? cancelingSpringOption.presentSpringParams.dampingRatio : cancelingSpringOption.dismissSpringParams.dampingRatio,
                           initialSpringVelocity: present ? cancelingSpringOption.presentSpringParams.velocity : cancelingSpringOption.dismissSpringParams.velocity,
                           options: animationOptions,
                           animations: animation,
                           completion: completion)
        } else {
            UIView.animate(withDuration: transitionDuration - transitionDuration * Double(currentPercentComplete),
                           delay: 0,
                           options: animationOptions,
                           animations: animation,
                           completion: completion)
        }
    }
    
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view!.superview!)
        let dx = translation.x / recognizer.view!.bounds.width
        let progress: CGFloat = abs(dx)
        var velocity = recognizer.velocity(in: recognizer.view!.superview!).x
        
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
                    updateTransition(percentComplete: progress)
                    transitionContext.updateInteractiveTransition(progress)
                }
            
            case .cancelled, .ended:
                if transitionStarted {
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
                            if self.transitionStarted {
                                self.cancelTransition(currentPercentComplete: progress)
                                self.transitionContext.cancelInteractiveTransition()
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
