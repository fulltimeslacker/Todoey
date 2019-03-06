//
//  Item.swift
//  Todoey
//
//  Created by Alan Wei Jung Lai on 2019-03-05.
//  Copyright © 2019 Alan Wei Jung Lai. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?

    
    var parentCategory = LinkingObjects (fromType: Category.self, property: "items") //Links relationship back to Category as a to one relationship
}


