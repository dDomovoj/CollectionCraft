//
//  CollectionSection.swift
//  CollectionCraft
//
//  Created by dDomovoj on 11/20/19.
//

import Foundation

public struct CollectionSection {

    public typealias Item = ICollectionCell
    public typealias Header = ICollectionHeader
    public typealias Footer = ICollectionFooter

    public let identifier: IIdentifiable.ID?
    public let items: [ICollectionCell]
    public let header: Header?
    public let footer: Footer?

    subscript(_ idx: Int) -> Item { items[idx] }

    var size: Int { return items.count }

    public init(_ identifier: IIdentifiable.ID? = nil, header: Header? = nil, items: [Item], footer: Footer? = nil) {
        self.identifier = identifier
        self.items = items
        self.header = header
        self.footer = footer
    }

}
