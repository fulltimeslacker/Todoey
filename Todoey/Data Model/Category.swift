//
//  Category.swift
//  Todoey
//
//  Created by Alan Wei Jung Lai on 2019-03-05.
//  Copyright © 2019 Alan Wei Jung Lai. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>() // Making one to many relationships
}
