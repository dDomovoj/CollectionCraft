//
//  CollectionFooter.swift
//  CollectionCraft
//
//  Created by dDomovoj on 11/20/19.
//

import UIKit

public protocol ICollectionFooter: IIdentifiable {

    typealias View = UICollectionReusableView
    typealias Container = UICollectionView

    func register(in containerView: Container)

    func instance(for containerView: Container, at indexPath: IndexPath) -> View

    func size(for containerView: Container, at section: Int) -> CGSize

    func display(in view: View)

}

public struct CollectionFooter<T: UICollectionReusableView & IReusableCell>: ICollectionFooter {

    public typealias Data = T.Data
    public typealias View = T

    public let data: Data

    private var uniqueReuseIdentifer: String?
    private var reuseIdentifier: String { uniqueReuseIdentifer ?? T.reuseIdentifier }

    // MARK: - Init

    public init(_ data: Data) {
        self.data = data
    }

    // MARK: - Accessor

    public func unique(_ reuseIdentifier: String) -> Self {
        var copy = Self.init(data)
        copy.uniqueReuseIdentifer = reuseIdentifier
        return copy
    }

    // MARK: - ICollectionFooter

    public func register(in containerView: Container) {
        T.register(in: containerView, kind: UICollectionView.elementKindSectionFooter, reuseIdentifier: reuseIdentifier)
    }

    public func instance(for containerView: Container, at indexPath: IndexPath) -> UICollectionReusableView {
        containerView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                       withReuseIdentifier: T.reuseIdentifier, for: indexPath)
    }

    public func size(for containerView: Container, at section: Int) -> CGSize {
        let ctx = CollectionLayoutContext(collectionView: containerView, at: [section, 0])
        return T.size(for: data, ctx: ctx)
    }

    public func display(in view: UICollectionReusableView) {
        (view as? T)?.setup(with: data)
    }

}

extension CollectionFooter where Data: IIdentifiable {

    var id: Self.ID { data.id }

}

extension CollectionFooter where Data: ExpressibleByNilLiteral {

    init() { self.init(nil) }

    var id: Self.ID { "\(type(of: self))" }

}

extension CollectionFooter where Data == Void {

    init() { self.init(Void()) }

    var id: Self.ID { "\(type(of: self))" }

}
