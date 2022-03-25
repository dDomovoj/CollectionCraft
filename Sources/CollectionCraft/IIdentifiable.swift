//
//  IIdentifiable.swift
//  CollectionCraft
//
//  Created by dDomovoj on 11/20/19.
//

import Foundation

public protocol IIdentifiable {

    // swiftlint:disable:next type_name
    typealias ID = String

    var id: ID { get }

}

public extension IIdentifiable {

    var id: ID { defaultId }

    var defaultId: ID {
        let base = "\(type(of: self))".hashValue
        let mirror = Mirror(reflecting: self)
        let result = mirror.children
            .compactMap { ($0.value as? AnyHashable)?.hashValue }
            .reduce(base) { $0 ^ $1 }
        return "\(result)"
    }

}
