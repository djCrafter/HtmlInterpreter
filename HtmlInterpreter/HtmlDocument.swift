//
//  Document.swift
//  HtmlInterpreter
//
//  Created by Crafter on 5/8/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit

class HtmlDocument: UIDocument {
    
    var htmlString: String?
    
    override func contents(forType typeName: String) throws -> Any {
    return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
       
    }
}

