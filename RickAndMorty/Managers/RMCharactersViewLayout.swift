//
//  RMCharactersViewFlowLayout.swift
//  RickAndMorty
//
//  Created by  on 03/05/23.
//

import UIKit

protocol RMCharactersViewLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

final class RMCharactersViewLayout: UICollectionViewLayout {
    
    public var delegate: RMCharactersViewLayoutDelegate!
    private var showFooter = true
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat { return collectionView!.bounds.width }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override public func prepare() {
        if cache.isEmpty {
            
            let defaultSpacing: CGFloat = RMCharactersView.defaultSpacing
            let numberOfColumns: Int = RMCharactersView.numberOfColumns
            let footerHeight: CGFloat = RMCharactersView.footerHeight
            let columnWidth: CGFloat = RMCharactersView.columnWidth

            var xOffset = [CGFloat](repeating: 0.0, count: numberOfColumns)
            xOffset.indices.forEach({ xOffset[$0] = CGFloat($0)*(columnWidth+defaultSpacing)+defaultSpacing })
            
            var yOffset = [CGFloat](repeating: defaultSpacing, count: numberOfColumns)

            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let column = item % numberOfColumns
                let indexPath = IndexPath(item: item, section: 0)
                
                let cellWidth = columnWidth
                let cellHeight = delegate.collectionView(collectionView!, heightForItemAt: indexPath)
                let cellFrame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: cellHeight)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = cellFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, cellFrame.maxY+defaultSpacing)
                yOffset[column] += cellHeight+defaultSpacing
            }
            
            if(showFooter) {
                
                let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 1, section: 0))
                attr.frame = CGRect(x: 0.0, y: contentHeight, width: contentWidth, height: footerHeight)
                contentHeight = max(contentHeight, attr.frame.maxY)
                cache.append(attr)
            }
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
