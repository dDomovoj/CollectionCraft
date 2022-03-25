//
//  CollectionCell.swift
//  CollectionCraft
//
//  Created by dDomovoj on 11/20/19.
//

import UIKit

public protocol ICollectionCell: IIdentifiable, CustomDebugStringConvertible {

    typealias View = UICollectionViewCell
    typealias Container = UICollectionView
    typealias SelectBlock = (IndexPath) -> Void

    var selector: SelectBlock? { get }

    func register(in containerView: Container)

    func instance(for containerView: Container, at indexPath: IndexPath) -> View

    func size(for containerView: Container, at indexPath: IndexPath) -> CGSize

    func display(in view: View)

}

public struct CollectionCell<T: UICollectionViewCell & IReusableCell>: ICollectionCell {

    public typealias Data = T.Data
    public typealias View = T
    public typealias SelectBlock = (IndexPath) -> Void

    public let data: Data
    public let selector: SelectBlock?

    private var uniqueReuseIdentifer: String?
    private var reuseIdentifier: String { uniqueReuseIdentifer ?? T.reuseIdentifier }

    // MARK: - Init

    public init(_ data: Data, selector: SelectBlock? = nil) {
        self.data = data
        self.selector = selector
    }

    public var id: Self.ID {
        (data as? IIdentifiable)?.id ?? "not defined"
    }

    public var debugDescription: String { id }

    // MARK: - Accessor

    public func onClick(_ selector: @escaping SelectBlock) -> Self { Self.init(data, selector: selector) }

    public func unique(_ reuseIdentifier: String) -> Self {
        var copy = Self.init(data, selector: selector)
        copy.uniqueReuseIdentifer = reuseIdentifier
        return copy
    }

    // MARK: - ICollectionCell

    public func register(in containerView: UICollectionView) {
        T.register(in: containerView, reuseIdentifier: reuseIdentifier)
    }

    public func instance(for containerView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        containerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }

    public func size(for containerView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        let ctx = CollectionLayoutContext(collectionView: containerView, at: indexPath)
        return T.size(for: data, ctx: ctx)
    }

    public func display(in view: UICollectionViewCell) {
        (view as? T)?.setup(with: data)
    }

}

public extension CollectionCell where Data: IIdentifiable {

    var id: Self.ID { data.id }

}

public extension CollectionCell where Data: ExpressibleByNilLiteral {

    init(selector: SelectBlock? = nil) { self.init(nil, selector: selector) }

    var id: Self.ID { "\(type(of: self))" }

}

public extension CollectionCell where Data == Void {

    init(selector: SelectBlock? = nil) { self.init(Void(), selector: selector) }

    var id: Self.ID { "\(type(of: self))" }

}
