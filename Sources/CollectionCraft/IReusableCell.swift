//
//  IReusableCell.swift
//  CollectionCraft
//
//  Created by dDomovoj on 11/19/19.
//

import Foundation
import UIKit

public protocol IReusableCell: IReusable {

    associatedtype Data

    var containerView: UICollectionView? { get }

    var indexPath: IndexPath { get }

    func setup(with data: Data)

    static func size(for data: Data, ctx: CollectionLayoutContext) -> CGSize

}

public extension IReusableCell where Data == Void {

    func setup(with data: Data) { }

}
