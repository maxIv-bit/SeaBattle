//
//  CollectionViewDataSource.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

class CollectionViewDataSource<T>: NSObject,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    let collectionView: UICollectionView
    lazy var data = [T]()
    
    // MARK: - Callbacks
    var didSelect: ((T, IndexPath) -> Void)?

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView

        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        configure()
    }
    
    func configure() {}
    func update(data: [T], shouldReload: Bool) {
        self.data = data
        
        if shouldReload {
            collectionView.reloadData()
        }
    }
    
    func delete(indices: [Int], data: [T]) {
        let indexPathes = indices.map { IndexPath(item: $0, section: 0) }
        self.data = data
        collectionView.deleteItems(at: indexPathes)
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func reload(at indices: [Int]) {
        reload(at: indices.map { IndexPath(item: $0, section: 0) })
    }
    
    func reload(at indexPathes: [IndexPath]) {
        collectionView.reloadItems(at: indexPathes)
    }
    
    func scrollTillTheEnd() {
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { data.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { UICollectionViewCell() }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { UICollectionReusableView() }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row < data.count {
            didSelect?(data[indexPath.row], indexPath)
        }
    }
    
    // MARK: - UIScrollView
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { .zero }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { .zero }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { .zero }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize { .zero }
    
    // MARK: - UICollectionViewDragDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {}
}

