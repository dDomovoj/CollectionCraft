//
//  CollectionSource~Builder.swift
//  CollectionCraft
//
//  Created by dDomovoj on 10/15/19.
//

import Foundation

public protocol ICollectionSourceBuilderContent { }
extension CollectionSection: ICollectionSourceBuilderContent { }
extension Array: ICollectionSourceBuilderContent where Element: ICollectionSourceBuilderContent { }
extension Optional: ICollectionSourceBuilderContent where Wrapped: ICollectionSourceBuilderContent { }
fileprivate extension ICollectionSourceBuilderContent {

    var unwrapped: [CollectionSection] {
        if let section = self as? CollectionSection {
            return [section]
        }
        if let array = self as? [ICollectionSourceBuilderContent] {
            return array.flatMap { $0.unwrapped }
        }
        switch self as Any {
        case Optional<Any>.some(let value): // swiftlint:disable:this syntactic_sugar
            return (value as? ICollectionSourceBuilderContent)?.unwrapped ?? []
        default:
            return []
        }
    }

}

public extension CollectionSource {

    @resultBuilder
    enum Builder {
        public typealias Content = ICollectionSourceBuilderContent
        public static func buildBlock() -> Content { [CollectionSection]() }
        public static func buildBlock(_ content: Content...) -> Content { content.flatMap { $0.unwrapped } }
        public static func buildIf(_ content: Content?) -> Content { content?.unwrapped ?? [] }
        public static func buildEither(first: Content) -> Content { first }
        public static func buildEither(second: Content) -> Content { second }
    }

    func reload(animated: Bool = false, @Builder _ block: () -> Builder.Content) {
        let new = block().unwrapped
        guard animated, !sections.isEmpty else {
            sections = new
            return
        }

        reloadUsingDiff(new)
    }

}

private enum ContentCell {

    case cell(ICollectionCell)
    case header(ICollectionHeader)
    case footer(ICollectionFooter)

}

public protocol ICollectionSeсtionBuilderContent { }
extension ContentCell: ICollectionSeсtionBuilderContent { }
extension CollectionCell: ICollectionSeсtionBuilderContent { }
extension CollectionHeader: ICollectionSeсtionBuilderContent { }
extension CollectionFooter: ICollectionSeсtionBuilderContent { }
extension Array: ICollectionSeсtionBuilderContent where Element: ICollectionSeсtionBuilderContent { }
extension Optional: ICollectionSeсtionBuilderContent where Wrapped: ICollectionSeсtionBuilderContent { }
fileprivate extension ICollectionSeсtionBuilderContent {

    var unwrapped: [ContentCell] {
        if let container = self as? ContentCell {
            return [container]
        }
        if let cell = self as? ICollectionCell {
            return [.cell(cell)]
        }
        if let header = self as? ICollectionHeader {
            return [.header(header)]
        }
        if let footer = self as? ICollectionFooter {
            return [.footer(footer)]
        }
        if let array = self as? [ICollectionSeсtionBuilderContent] {
            return array.flatMap { $0.unwrapped }
        }
        switch self as Any {
        case Optional<Any>.some(let value): // swiftlint:disable:this syntactic_sugar
            return (value as? ICollectionSeсtionBuilderContent)?.unwrapped ?? []
        default:
            return []
        }
    }

}

public extension CollectionSection {

    @resultBuilder
    enum Builder {
        public typealias Content = ICollectionSeсtionBuilderContent
        public static func buildBlock() -> Content { [ContentCell]() }
        public static func buildBlock(_ content: Content...) -> Content { content.flatMap { $0.unwrapped } }
        public static func buildIf(_ content: Content?) -> Content { content?.unwrapped ?? [] }
        public static func buildEither(first: Content) -> Content { first }
        public static func buildEither(second: Content) -> Content { second }
    }

    // Overdriven init with non-optional identifier (XCode 11.2+ throws compilation error if there is an optional param with builder block)
    init(_ identifier: IIdentifiable.ID, @Builder _ block: () -> Builder.Content) {
        var items: [ICollectionCell] = []
        var header: ICollectionHeader?
        var footer: ICollectionFooter?
        block().unwrapped.forEach { container in
            switch container {
            case .cell(let item): items.append(item)
            case .header(let item) where header == nil: header = item
            case .footer(let item): footer = item
            default: break
            }
        }
        self.init(identifier, header: header, items: items, footer: footer)
    }

    init(@Builder _ block: () -> Builder.Content) {
        var items: [ICollectionCell] = []
        var header: ICollectionHeader?
        var footer: ICollectionFooter?
        block().unwrapped.forEach { container in
            switch container {
            case .cell(let item): items.append(item)
            case .header(let item) where header == nil: header = item
            case .footer(let item): footer = item
            default: break
            }
        }
        self.init(header: header, items: items, footer: footer)
    }

}
