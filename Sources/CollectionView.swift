//
//  CollectionView.swift
//  CollectionCraft
//
//  Created by dDomovoj on 8/12/19.
//

import UIKit

open class CollectionView: UICollectionView {

    convenience public init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }

    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open func setup() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
    }

}

open class CollectionViewCell: UICollectionViewCell {

    public enum Source {
        case nib(UINibResource)
        case regular
    }

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Public

    open func setup() {
        setNeedsUpdateConstraints()
    }

}

// MARK: - IReusable

extension IReusable where Self: UICollectionViewCell {

    public static func register(in collectionView: UICollectionView, reuseIdentifier: String? = nil) {
        let reuseIdentifier = reuseIdentifier ?? self.reuseIdentifier
        switch reuseSource {
        case .regular:
            collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier)
        case .nib(let resource):
            let nib = UINib(resource: resource)
            collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        case .storyboard:
            break
        }
    }

}

extension IReusable where Self: UICollectionReusableView {

    public static func register(in collectionView: UICollectionView, kind: String, reuseIdentifier: String? = nil) {
        let reuseIdentifier = reuseIdentifier ?? self.reuseIdentifier
        switch reuseSource {
        case .regular:
            collectionView.register(self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        case .nib(let resource):
            let nib = UINib(resource: resource)
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        case .storyboard:
            break
        }
    }

}
