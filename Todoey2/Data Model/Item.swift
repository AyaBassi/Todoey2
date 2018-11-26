//
//  Item.swift
//  Todoey2
//
//  Created by Aya Bassi on 27/10/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
