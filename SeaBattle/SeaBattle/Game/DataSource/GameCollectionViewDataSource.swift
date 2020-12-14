//
//  GameCollectionViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

private struct Constants {
    static var edgeInsets: UIEdgeInsets { .zero }
    static var spaceBetweenCells: CGFloat { 0 }
    static var columnsCount: CGFloat { 10 }
}

final class GameCollectionViewDataSource: CollectionViewDataSource<Position> {
    override func configure() {
        collectionView.backgroundColor = .white
        collectionView.register(BattleFieldCell.self)
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BattleFieldCell.self)
        let position = data[indexPath.item]
        cell.configure(x: position.x, y: position.y, isShot: position.isShot)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = ((collectionView.bounds.width - Constants.edgeInsets.horizontal) - (Constants.spaceBetweenCells * (Constants.columnsCount - 1))) / Constants.columnsCount
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
