//
//  Category.swift
//  Todoey2
//
//  Created by Aya Bassi on 27/10/2018.
//  Copyright © 2018 Green Balloons. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var randCelColHexCodeInStr : String = ""
    let items = List<Item>()
}
