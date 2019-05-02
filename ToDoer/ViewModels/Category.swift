//
//  Category.swift
//  ToDoer
//
//  Created by Sarannya on 30/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var cellColor = ""
    
    //Relation to Items
    let items = List<Item>()
}
