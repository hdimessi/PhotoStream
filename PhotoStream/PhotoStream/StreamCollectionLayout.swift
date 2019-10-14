//
//  ViewController.swift
//  MVImagesBoard
//
//  Created by HDimes on 10/8/19.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

protocol StreamCollectionLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
    var collectionView: UICollectionView! { get }
}

class StreamCollectionLayout: UICollectionViewLayout {
  
    weak var delegate: StreamCollectionLayoutDelegate?

    private var numberOfColumnsValue = 2
    private var numberOfColumns: Int  {
        return (contentWidth / 160) > 0 ? Int(contentWidth / 160) : 0
    }
    private let cellPadding: CGFloat = 6

    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentHeight: CGFloat = 0

    private var contentWidthValue: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = delegate?.collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        
        switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                contentWidthValue = min(collectionView.bounds.width, collectionView.bounds.height)
            case .landscapeLeft, .landscapeRight:
                contentWidthValue = max(collectionView.bounds.width, collectionView.bounds.height)
            default:
                break
        }
        return contentWidthValue - (insets.left + insets.right)
    }

  
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareOrientationLayout()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(prepareOrientationLayout),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    override func prepare() {
        if cache.isEmpty {
            prepareOrientationLayout()
        }
    }

    @objc
    func prepareOrientationLayout() {
        cache.removeAll()
        
        guard let collectionView = delegate?.collectionView, numberOfColumns > 0
          else {
            return
        }
        
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
          xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
          
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
          let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight: CGFloat
            if let size = delegate?.collectionView(collectionView, sizeForPhotoAtIndexPath: indexPath) {
                photoHeight = size.height * columnWidth / size.width
            } else {
                photoHeight = 180
            }
            
          let height = cellPadding * 2 + photoHeight
          let frame = CGRect(x: xOffset[column],
                             y: yOffset[column],
                             width: columnWidth,
                             height: height)
          let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
          let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          attributes.frame = insetFrame
          cache.append(attributes)
            
          contentHeight = max(contentHeight, frame.maxY)
          yOffset[column] = yOffset[column] + height
          
          column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        invalidateLayout()
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
          if attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
          }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
  
  deinit {
    UIDevice.current.endGeneratingDeviceOrientationNotifications()
    NotificationCenter.default.removeObserver(self)
  }
  
}
