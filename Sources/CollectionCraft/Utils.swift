//
//  Utils.swift
//  CollectionCraft
//
//  Created by Dmitry Duleba on 1/22/21.
//

import Foundation

func fatalError<T>(_ message: @autoclosure () -> String = #function, file: StaticString = #file, line: UInt = #line) -> T {
    Swift.fatalError(message(), file: file, line: line)
}

func preconditionFailure<T>(_ message: @autoclosure () -> String = #function) -> T {
    Swift.preconditionFailure(message())
}
