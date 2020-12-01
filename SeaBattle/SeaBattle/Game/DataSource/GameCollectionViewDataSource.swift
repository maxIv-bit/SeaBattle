//
//  GameCollectionViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

private struct Constants {
    static var edgeInsets: UIEdgeInsets { .zero }
    static var spaceBetweenCells: CGFloat { 2 }
    static var columnsCount: CGFloat { 10 }
}

final class GameCollectionViewDataSource: CollectionViewDataSource<FieldCell> {
    override func configure() {
        collectionView.backgroundColor = .white
        collectionView.register(FieldCellCollectionViewCell.self)
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FieldCellCollectionViewCell.self)
        let fieldCell = data[indexPath.item]
        cell.configure(fieldCell.isBoat ? .red : .blue)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = ((collectionView.bounds.width) - (Constants.spaceBetweenCells * (Constants.columnsCount - 1))) / Constants.columnsCount
        return CGSize(width: side, height: side)
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
