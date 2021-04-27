//
//  UINibResource.swift
//  CollectionCraft
//
//  Created by dDomovoj on 8/13/19.
//

import UIKit

public enum UINibResource {

    case named(String, Bundle?)
    case data(Data, Bundle?)

}

public extension UINib {

    convenience init(resource: UINibResource) {
        switch resource {
        case .data(let data, let bundle):
            self.init(data: data, bundle: bundle)
        case .named(let name, let bundle):
            self.init(nibName: name, bundle: bundle)
        }
    }

}
