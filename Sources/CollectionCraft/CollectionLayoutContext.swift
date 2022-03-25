//
//  CollectionLayoutContext.swift
//  CollectionCraft
//
//  Created by dDomovoj on 11/20/19.
//

import UIKit

public struct CollectionLayoutContext {

    public let layout: UICollectionViewLayout
    let indexPath: IndexPath

    public var containerSize: CGSize {
        collectionView?.bounds.size ?? .zero
    }

    public var contentInset: UIEdgeInsets {
        collectionView?.contentInset ?? .zero
    }

    public var sectionInset: UIEdgeInsets {
        if let collectionView = collectionView,
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let flowDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
            return flowDelegate?.collectionView?(collectionView, layout: flowLayout,
                                                 insetForSectionAt: indexPath.section) ?? flowLayout.sectionInset
        }
        return .zero
    }

    public var fitWidth: CGFloat {
        let contentInset = self.contentInset
        let sectionInset = self.sectionInset
        let width = layout.collectionView?.bounds.size.width ?? 0.0
        return max(width
            - (contentInset.left + contentInset.right)
            - (sectionInset.left + sectionInset.right), 0.0)
    }

    public var fitHeight: CGFloat {
        let contentInset = self.contentInset
        let sectionInset = self.sectionInset
        let height = layout.collectionView?.bounds.size.height ?? 0.0
        return max(height
            - (contentInset.top + contentInset.bottom)
            - (sectionInset.top + sectionInset.bottom), 0.0)
    }

    private var collectionView: UICollectionView? {
        layout.collectionView
    }

    // MARK: - Init

    public init(collectionView: UICollectionView, at indexPath: IndexPath) {
        layout = collectionView.collectionViewLayout
        self.indexPath = indexPath
    }

}
