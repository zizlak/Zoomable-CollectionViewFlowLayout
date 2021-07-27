//
//  PinchFlowLayout.swift
//  ZoomableCell
//
//  Created by Aleksandr Kurdiukov on 27.07.21.
//

import UIKit

class PinchFlowLayout: UICollectionViewFlowLayout {

    
    //MARK: - Properties
    
    private var initialLocation: CGPoint?
    
    private var pinchedCellPath: IndexPath!
    private var pinchedCellScale: CGFloat!
    private var pinchedCellCenter: CGPoint!
    
    
    //MARK: - LifeCycle Methods
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        return attributes
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let allAttributesInRect = super.layoutAttributesForElements(in: rect)
        
        for attribute in allAttributesInRect! {
            self.applyPinchLayoutAttributes(attribute)
        }
        return allAttributesInRect
    }
    
    
    
    //MARK: - Methods
    
    
    private func applyPinchLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        if layoutAttributes.indexPath == self.pinchedCellPath {
            layoutAttributes.transform3D = CATransform3DMakeScale(self.pinchedCellScale, pinchedCellScale, 1)
            layoutAttributes.center = self.pinchedCellCenter
            layoutAttributes.zIndex = 1
        }
    }
    
    
    
    
    private func setPinchedCellScale(scale: CGFloat) {
        pinchedCellScale = scale
        self.invalidateLayout()
    }
    
    private func setPinchedCellCenter(origin: CGPoint) {
        pinchedCellCenter = origin
        self.invalidateLayout()
    }
    private func setPinchedCellPath(path: IndexPath) {
        pinchedCellPath = path
    }
    
    
    
    
    func setupCollectionViewPan() {
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePan))
        collectionView?.addGestureRecognizer(pinchGestureRecognizer)
        
    }
    
    @objc private func handlePan(sender: UIPinchGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        
        switch sender.state {
        case .began:
            
            let initialPoint = sender.location(in: collectionView)
            
            guard let indexPath = collectionView.indexPathForItem(at: initialPoint) else { return }
            let cellCenter = collectionView.cellForItem(at: indexPath)?.center
            initialLocation = cellCenter
            setPinchedCellPath(path: indexPath)
            
        case .changed:
            setPinchedCellScale(scale: sender.scale)
            setPinchedCellCenter(origin: sender.location(in: collectionView))
            
        case .ended:
            //   UIView.animate(withDuration: 1) {
            self.setPinchedCellScale(scale: 1)
            self.setPinchedCellCenter(origin: self.initialLocation!)
        //   }
        default:
            break
        }
    }
    
}
