//
//  DismissCardAnimator.swift
//  Kickster
//
//  Created by Razvan Chelemen on 06/05/2019.
//  Copyright © 2019 appssemble. All rights reserved.
//

import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: CardCollectionViewCell
        let settings: TransitionSettings
    }
    
    struct Constants {
        static let relativeDurationBeforeNonInteractive: TimeInterval = 0.5
        static let minimumScaleBeforeNonInteractive: CGFloat = 0.8
    }
    
    private let params: Params
    
    init(params: Params) {
        self.params = params
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return params.settings.dismissalAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let container = ctx.containerView
        
        var toViewController: CardsViewController! = ctx.viewController(forKey: .to)?.cardsViewController()
        
        let screens: (cardDetail: CardDetailViewController, home: CardsViewController) = (
            ctx.viewController(forKey: .from)! as! CardDetailViewController,
            toViewController
        )
        
        let cardDetailView = ctx.view(forKey: .from)!
        
        let animatedContainerView = UIView()
        if params.settings.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 2
        }
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        container.removeConstraints(container.constraints)
        
        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(cardDetailView)
        
        // Card fills inside animated container view
        cardDetailView.edges(to: animatedContainerView)
        
        let animatedHorizontalConstraint: NSLayoutConstraint = {
            switch params.settings.cardHorizontalEPositioningStyle {
            case .fromLeft:
                return animatedContainerView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 0)
            case .fromCenter:
                return animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            case .fromRight:
                return animatedContainerView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: 0)
            }
        }()
        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: params.settings.cardContainerDismissInsets.top)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width - (params.settings.cardContainerDismissInsets.left + params.settings.cardContainerDismissInsets.right))
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height - (params.settings.cardContainerDismissInsets.top + params.settings.cardContainerDismissInsets.bottom))
        let animatedContainerBottomConstraint = animatedContainerView.bottomAnchor.constraint(equalTo: screens.cardDetail.cardContentView.bottomAnchor, constant: params.settings.cardContainerDismissInsets.bottom)
        
        NSLayoutConstraint.activate([animatedHorizontalConstraint, animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint, animatedContainerBottomConstraint])
        
        // Fix weird top inset
        let topTemporaryFix = screens.cardDetail.cardContentView.topAnchor.constraint(equalTo: cardDetailView.topAnchor)
        topTemporaryFix.isActive = params.settings.isEnabledWeirdTopInsetsFix
        
        container.layoutIfNeeded()
        
    
        func animateCardViewBackToPlace() {
            //stretchCardToFillBottom.isActive = true
            //screens.cardDetail.isFontStateHighlighted = false
            // Back to identity
            // NOTE: Animated container view in a way, helps us to not messing up `transform` with `AutoLayout` animation.
            switch params.settings.cardHorizontalEPositioningStyle {
            case .fromLeft:
                animatedHorizontalConstraint.constant =  params.settings.cardContainerDismissInsets.left
            case .fromCenter: break
            case .fromRight:
                animatedHorizontalConstraint.constant =  params.settings.cardContainerDismissInsets.right
            }
            
            cardDetailView.transform = CGAffineTransform.identity
            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY + params.settings.cardContainerDismissInsets.top
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height
            container.layoutIfNeeded()
        }
        
        func completeEverything() {
            let success = !ctx.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            if success {
                cardDetailView.removeFromSuperview()
                self.params.fromCell.isHidden = false
            } else {
                //screens.cardDetail.isFontStateHighlighted = true
                
                // Remove temporary fixes if not success!
                topTemporaryFix.isActive = false
                
                cardDetailView.removeConstraint(topTemporaryFix)
                
                container.removeConstraints(container.constraints)
                
                container.addSubview(cardDetailView)
                cardDetailView.edges(to: container)
            }
            ctx.completeTransition(success)
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            animateCardViewBackToPlace()
        }) { (finished) in
            completeEverything()
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.4) { [weak self] () in
            guard let self = self else { return }
            //screens.cardDetail.scrollView.setContentOffset(self.params.settings.dismissalScrollViewContentOffset, animated: true)
            screens.cardDetail.scrollView.contentOffset = self.params.settings.dismissalScrollViewContentOffset
        }
    }
}
