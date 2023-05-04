//
//  RMCharactersViewFlowLayout.swift
//  RickAndMorty
//
//  Created by  on 03/05/23.
//

import UIKit

protocol RMCharactersViewLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForFooterInSection section: Int) -> CGFloat
}

final class RMCharactersViewLayout: UICollectionViewLayout {
    
    public var delegate: RMCharactersViewLayoutDelegate!
    
    private static let defaultSpacing: CGFloat = 5.0
    private static let numberOfColumns: Int = 3
    
    public static var columnWidth: CGFloat {
        let columns = CGFloat(RMCharactersViewLayout.numberOfColumns)
        let spacing = RMCharactersViewLayout.defaultSpacing
        let availableWidth = UIScreen.main.bounds.width
        let columnWidth = (availableWidth-spacing*(columns+1))/columns
        return columnWidth
    }
    
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    private let xOffset: [CGFloat] = Array(0..<numberOfColumns).map({ CGFloat($0)*(columnWidth+defaultSpacing)+defaultSpacing })
    private var yOffset: [CGFloat] = [CGFloat](repeating: defaultSpacing, count: numberOfColumns)
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat { return collectionView!.bounds.width }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override public func prepare() {
        
        if cachedAttributes.count < collectionView!.numberOfItems(inSection: 0) {
            if !cachedAttributes.isEmpty { cachedAttributes.removeLast() }
            
            setupLayout()
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cachedAttributes[indexPath.item]
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cachedAttributes.last
    }
    
    private func setupLayout() {
                
        let defaultSpacing: CGFloat = RMCharactersViewLayout.defaultSpacing
        let numberOfColumns: Int = RMCharactersViewLayout.numberOfColumns
        let columnWidth: CGFloat = RMCharactersViewLayout.columnWidth
        let footerHeight: CGFloat = delegate.collectionView(collectionView!, heightForFooterInSection: 0)
        
        print(yOffset)
        
        let i = cachedAttributes.count
        print("Num of items: \(collectionView!.numberOfItems(inSection: 0))")
        for item in i ..< collectionView!.numberOfItems(inSection: 0) {
            let column = item % numberOfColumns
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellWidth = columnWidth
            let cellHeight = delegate.collectionView(collectionView!, heightForItemAt: indexPath)
            let cellFrame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: cellHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = cellFrame
            cachedAttributes.append(attributes)
            
            contentHeight = max(contentHeight, cellFrame.maxY+defaultSpacing)
            yOffset[column] += cellHeight+defaultSpacing
        }
        
        let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 1, section: 0))
        attr.frame = CGRect(x: 0.0, y: contentHeight, width: contentWidth, height: footerHeight)
        contentHeight = max(contentHeight, attr.frame.maxY)
        cachedAttributes.append(attr)
        
        print("Attributes cache: \(cachedAttributes.count)")
    }
}
