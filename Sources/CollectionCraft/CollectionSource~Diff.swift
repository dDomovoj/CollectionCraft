//
//  CollectionSource~Diff.swift
//  CollectionCraft
//
//  Created by dDomovoj on 3/4/20.
//

import DifferenceKit

private struct DiffSection: Differentiable {

    typealias DifferenceIdentifier = IIdentifiable.ID

    let section: CollectionSection

    var differenceIdentifier: IIdentifiable.ID {
        section.identifier ?? preconditionFailure("\(type(of: self)) identifier not specified")
    }

    func isContentEqual(to source: DiffSection) -> Bool { section.identifier == source.section.identifier }

}

private struct DiffCell: Differentiable {

    typealias DifferenceIdentifier = IIdentifiable.ID

    let cell: ICollectionCell

    var differenceIdentifier: IIdentifiable.ID {
        cell.id
    }

    func isContentEqual(to source: DiffCell) -> Bool { cell.id == source.cell.id }

}

extension CollectionSource {

    func reloadUsingDiff(_ sections: [CollectionSection]) {
        let source = self.sections.map {
            ArraySection(model: DiffSection(section: $0), elements: $0.items.map { DiffCell(cell: $0) })
        }
        let target = sections.map {
            ArraySection(model: DiffSection(section: $0), elements: $0.items.map { DiffCell(cell: $0) })
        }

        let changeset = StagedChangeset(source: source, target: target)
        containerView.reload(using: changeset) { data in
            let sections = data.map { item -> CollectionSection in
                let section = item.model.section
                let cells = item.elements.map { $0.cell }
                return CollectionSection(section.identifier, header: section.header,
                                         items: cells, footer: section.footer)
            }
            apply(sections)
        }
    }

}
