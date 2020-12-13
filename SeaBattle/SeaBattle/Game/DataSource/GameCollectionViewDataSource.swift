//
//  GameCollectionViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

private struct Constants {
    static var edgeInsets: UIEdgeInsets { UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1) }
    static var spaceBetweenCells: CGFloat { 2 }
    static var columnsCount: CGFloat { 10 }
}

final class GameCollectionViewDataSource: CollectionViewDataSource<FieldCell> {
    override func configure() {
        collectionView.backgroundColor = .white
        collectionView.register(FieldCellCollectionViewCell.self)
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FieldCellCollectionViewCell.self)
        let fieldCell = data[indexPath.item]
        cell.configure(fieldCell.isBoat ? .red : .blue, indexPath: indexPath, axis: fieldCell.positions.first!.description)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = ((collectionView.bounds.width - Constants.edgeInsets.horizontal) - (Constants.spaceBetweenCells * (Constants.columnsCount - 1))) / Constants.columnsCount
        var height = side
        var width = side
        let fieldCell = data[indexPath.row]
        switch fieldCell.axisPosition {
        case .horizontal:
            height = CGFloat(data[indexPath.row].positions.count) * side
        case .vertical:
            width = CGFloat(data[indexPath.row].positions.count) * side
        }
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.edgeInsets
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spaceBetweenCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spaceBetweenCells
    }
}

// MARK: - UICollectionViewDragDelegate
extension GameCollectionViewDataSource: UICollectionViewDragDelegate {
    // MARK: - UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
//        dragSessionEnd?()
        session.localContext = nil
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        guard shouldAllowDragForIndexPath?(indexPath) == true else { return [] }
//        dragSessionBegin?()
        guard let cell = collectionView.cellForItem(at: indexPath)?.toImage() else {
            return []
        }
        let provider = NSItemProvider(object: cell)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = data[indexPath.row]
        
        return [item]
    }
}
  
extension GameCollectionViewDataSource: UICollectionViewDropDelegate {
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard
            let item = coordinator.items.first?.dragItem,
            let sourceIndexPath = coordinator.items.first?.sourceIndexPath,
            let destinationIndexPath = coordinator.destinationIndexPath,
            let entity = item.localObject as? FieldCell
            else {
                return
        }
        collectionView.performBatchUpdates({ [unowned self] in
//            dropEntityAtIndexPath?(entity, destinationIndexPath)
            self.collectionView.deleteItems(at: [sourceIndexPath])
            self.collectionView.insertItems(at: [destinationIndexPath])
        }, completion: nil)
        coordinator.drop(item, toItemAt: destinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if
            session.localDragSession != nil,
            let path = destinationIndexPath/*,
            shouldAllowDropForIndexPath?(path) == true*/ {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
}

extension GameCollectionViewDataSource: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath) -> CGFloat {
        let side = ((collectionView.bounds.width - Constants.edgeInsets.horizontal) - (Constants.spaceBetweenCells * (Constants.columnsCount - 1))) / Constants.columnsCount
        return CGFloat(data[indexPath.row].positions.count) * side
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForIndexPath indexPath: IndexPath) -> CGFloat {
        let side = ((collectionView.bounds.width - Constants.edgeInsets.horizontal) - (Constants.spaceBetweenCells * (Constants.columnsCount - 1))) / Constants.columnsCount
        return side
    }
}

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    lazy var data = [FieldCell]()
    
    init(data: [FieldCell]) {
        super.init()
        self.data = data
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var delegate: PinterestLayoutDelegate?
    private let numberOfColumns = 10
    private let numberOfRows = 10
    private let cellPadding: CGFloat = 2
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        var row = 0
        var xOffset: [CGFloat] = .init(repeating: 0, count: numberOfRows)
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var positionsPerColumn = [Int: Int]()
        var minColumn = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellWidth = delegate?.collectionView(collectionView, widthForIndexPath: indexPath) ?? 0
            let cellHeight = delegate?.collectionView(collectionView, heightForIndexPath: indexPath) ?? 0
            let width = cellPadding + cellWidth
            let height = cellPadding + cellHeight
            let frame = CGRect(x: xOffset[row],
                               y: yOffset[column],
                               width: width,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            row = row < (numberOfRows - 1) ? (row + 1) : 0
            xOffset[row] = row > 0 ? xOffset[row - 1] + width : xOffset[row]
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            
            positionsPerColumn[column] = (positionsPerColumn[column] ?? 0) + data[indexPath.item].positions.count
            if positionsPerColumn[column] ?? 0 >= 10 {
                minColumn += 1
                print(minColumn)
            }
            
//            if let currentColumn = positionsPerColumn[column],
//               let nextColumn = positionsPerColumn[column + 1],
//               currentColumn - nextColumn > 1 {
//                print(row += 1)
//            } else {
//
//            }
//            print(positionsPerColumn[column])
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
