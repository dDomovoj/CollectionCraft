//
//  CollectionSource~State.swift
//  CollectionCraft
//
//  Created by dDomovoj on 10/28/19.
//

import Foundation

public class State<T: Equatable> {

    public typealias Change = (T) -> Void
    public typealias Provider = () -> T

    private let getter: Provider
    private var onChanges: [Change] = []

    public var value: T { getter() }

    private var isInsideSetBlock = false
    private var deferredValue: T?

    // MARK: - Init

    public init(getter: @escaping Provider, setter: Change? = nil) {
        self.getter = getter
        if let setter = setter {
            onChanges.append(setter)
        }
    }

    // MARK: - Public

    public func onChange(_ onChange: @escaping Change) {
        onChanges.append(onChange)
    }

    public func set(_ value: T) {
        if isInsideSetBlock {
            deferredValue = value
            return
        }

        isInsideSetBlock = true
        onChanges.forEach { $0(value) }
        isInsideSetBlock = false

        if let value = deferredValue {
            deferredValue = nil
            set(value)
        }
    }

}
