//
//  CollectionSource.swift
//  CollectionCraft
//
//  Created by dDomovoj on 9/13/19.
//

import UIKit
import ObjectiveC.runtime

open class CollectionSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public typealias Cell = ICollectionCell
    public typealias Section = CollectionSection
    public typealias Header = ICollectionHeader
    public typealias Footer = ICollectionFooter

    // MARK: Public

    public var sections: [Section] = [] {
        didSet {
            willReloadData()
            if shouldReloadData {
                collectionView.reloadData()
            }
        }
    }

    public var scrollHandler: (() -> Void)?

    public enum VisibleCellsChange {
        case willDisplay
        case endDisplay
    }
    public var visibleCellsChange: ((VisibleCellsChange, Cell) -> Void)?

    // MARK: Read-only

    public var containerView: UICollectionView {
        collectionView
    }

    public var visibleCells: [Cell] {
        containerView.indexPathsForVisibleItems.map { self[item: $0] }
    }

    // MARK: Private

    private let collectionView: UICollectionView
    private var shouldReloadData = true

    // MARK: - Init

    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Public

    /// For use with animated insertion, delete
    open func apply(_ sections: [Section]) {
        let previous = shouldReloadData
        shouldReloadData = false
        self.sections = sections
        shouldReloadData = previous
    }

    // MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].size
    }

    // MARK: Cell

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self[item: indexPath].instance(for: collectionView, at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
        self[item: indexPath].size(for: collectionView, at: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                             forItemAt indexPath: IndexPath) {
        let item = self[item: indexPath]
        cell._indexPath = indexPath
        cell._containerView = collectionView
        item.display(in: cell)
        visibleCellsChange?(.willDisplay, item)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell,
                             forItemAt indexPath: IndexPath) {
        guard indexPath.section < sections.count else { return }

        let section = sections[indexPath.section]
        guard indexPath.item < section.items.count else { return }

        let item = section.items[indexPath.item]
        visibleCellsChange?(.endDisplay, item)
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self[item: indexPath].selector?(indexPath)
    }

    // MARK: Supplementary

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return self[header: indexPath.section]?.instance(for: collectionView, at: indexPath) ?? fatalError(#function)
        case UICollectionView.elementKindSectionFooter:
            return self[footer: indexPath.section]?.instance(for: collectionView, at: indexPath) ?? fatalError(#function)
        default: fatalError(#function)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView,
                             forElementKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            self[header: indexPath.section]?.display(in: view)
        case UICollectionView.elementKindSectionFooter:
            self[footer: indexPath.section]?.display(in: view)
        default: break
        }
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForHeaderInSection section: Int) -> CGSize {
        self[header: section]?.size(for: collectionView, at: section) ?? .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForFooterInSection section: Int) -> CGSize {
        self[footer: section]?.size(for: collectionView, at: section) ?? .zero
    }

    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHandler?()
    }

}

// MARK: - Private

private extension CollectionSource {

    subscript(item indexPath: IndexPath) -> Cell {
        sections[indexPath.section][indexPath.item]
    }

    subscript(header section: Int) -> Header? {
        sections[section].header
    }

    subscript(footer section: Int) -> Footer? {
        sections[section].footer
    }

    func willReloadData() {
        sections.flatMap { $0.items }
            .forEach { $0.register(in: collectionView) }
        sections.compactMap { $0.header }
            .forEach { $0.register(in: collectionView) }
        sections.compactMap { $0.footer }
            .forEach { $0.register(in: collectionView) }
    }

}

// MARK: - UICollectionViewCell

public extension UICollectionViewCell {

    private enum Keys {
        static var indexPath: UInt = 0
        static var containerView: UInt = 0
    }

    fileprivate var _indexPath: IndexPath? {
        get { objc_getAssociatedObject(self, &Keys.indexPath) as? IndexPath }
        set { objc_setAssociatedObject(self, &Keys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    fileprivate var _containerView: UICollectionView? {
        get { objc_getAssociatedObject(self, &Keys.containerView) as? UICollectionView }
        set { objc_setAssociatedObject(self, &Keys.containerView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var indexPath: IndexPath { _indexPath ?? IndexPath() }
    var containerView: UICollectionView? { _containerView }

}
