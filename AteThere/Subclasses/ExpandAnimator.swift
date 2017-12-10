//
//  ExpandAnimator.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 11/20/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import UIKit

class ExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    let duration = 0.5
    var selectedCellFrame = CGRect.zero
    var originalCollectionViewY: CGFloat = 0.0
    var presenting = true
    private let backgroundScale: CGFloat = 0.7
    var selectedCell = MealCollectionViewCell()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let mealDetailVC = transitionContext.viewController(forKey: presenting ? .to : .from) as? MealDetailController else { return }
        
        let containerView = transitionContext.containerView
        let mealView = presenting ? toView : fromView

        containerView.backgroundColor = .white
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: mealView)

        let imageView = createTransitionImageViewWithFrame(frame: presenting ? selectedCellFrame : mealDetailVC.mealImageVIew.frame)
        imageView.image = mealDetailVC.mealImageVIew.image
        containerView.addSubview(imageView)

        let snapshotView = presenting ? fromView : toView
        
        let topView = UIImageView()
        let topViewY = presenting ? 0 : -selectedCellFrame.origin.y
        topView.frame = CGRect(x: 0, y: topViewY, width: fromView.frame.width, height: selectedCellFrame.origin.y)
        topView.image = snapshotView.snapshot(of: CGRect(x: 0, y: 0, width: snapshotView.frame.width, height: selectedCellFrame.origin.y))
        containerView.addSubview(topView)
        
        let bottomView = UIImageView()
        let bottomViewY = presenting ? selectedCellFrame.origin.y + selectedCellFrame.height: fromView.frame.height
        bottomView.frame = CGRect(x: 0, y: bottomViewY, width: fromView.frame.width, height: fromView.frame.height - selectedCellFrame.origin.y - selectedCellFrame.height)
        bottomView.image = snapshotView.snapshot(of: CGRect(x: 0, y: selectedCellFrame.origin.y + selectedCellFrame.height, width: fromView.frame.width, height: fromView.frame.height - selectedCellFrame.origin.y - selectedCellFrame.height))
        containerView.addSubview(bottomView)
        
        if presenting {
            mealDetailVC.view.alpha = 0.0
            fromView.isHidden = true

            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                    topView.transform = CGAffineTransform(translationX: 0, y: -topView.frame.height)
                    bottomView.transform = CGAffineTransform(translationX: 0, y: bottomView.frame.height)
                    imageView.frame = CGRect(x: 0.0, y: 0.0, width: mealDetailVC.mealImageVIew.frame.width, height: mealDetailVC.mealImageVIew.frame.height)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    mealDetailVC.view.alpha = 1.0
                })
            }, completion: { (_) in
                imageView.removeFromSuperview()
                topView.removeFromSuperview()
                bottomView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromView.isHidden = false
            })
        } else {
            toView.isHidden = true

            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.02, animations: {
                    mealDetailVC.detailContainerView.alpha = 0.0
                    mealDetailVC.backButton.alpha = 0.0
                    mealDetailVC.mealImageVIew.alpha = 0.0
                })
                UIView.addKeyframe(withRelativeStartTime: 0.02, relativeDuration: 0.5, animations: {
                    topView.transform = CGAffineTransform(translationX: 0, y: topView.frame.height)
                    bottomView.transform = CGAffineTransform(translationX: 0, y: -bottomView.frame.height)
                    imageView.frame = CGRect(x: self.selectedCellFrame.origin.x, y: self.selectedCellFrame.origin.y, width: self.selectedCellFrame.width, height: self.selectedCellFrame.height)
                    mealDetailVC.view.alpha = 0.0
                })
            }, completion: { (_) in
                imageView.removeFromSuperview()
                topView.removeFromSuperview()
                bottomView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                toView.isHidden = false
            })
        }
    }
    
    private func createTransitionImageViewWithFrame(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }
}
