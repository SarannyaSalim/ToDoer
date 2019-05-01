//
//  Item.swift
//  ToDoer
//
//  Created by Sarannya on 30/04/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //Relation to parent Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
