//
//  IReusable.swift
//  CollectionCraft
//
//  Created by dDomovoj on 8/13/19.
//

import Foundation

public enum ReusableViewSource {
    case nib(UINibResource)
    case regular
    case storyboard
}

public protocol IReusable {

    static var reuseIdentifier: String { get }

    static var reuseSource: ReusableViewSource { get }

}

public extension IReusable {

    static var reuseIdentifier: String { "\(self)" }

    static var reuseSource: ReusableViewSource { .regular }

}

public extension IReusable where Self: NSObject {

    static var reuseIdentifier: String { description() }

    static var reuseSource: ReusableViewSource { .regular }

}
