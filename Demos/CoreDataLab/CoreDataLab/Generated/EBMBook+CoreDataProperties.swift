//
//  EBMBook+CoreDataProperties.swift
//  CoreDataLab
//
//  Created by Jonathan Lehr on 11/29/17.
//  Copyright © 2017 About Objects. All rights reserved.
//
//

import Foundation
import CoreData


extension EBMBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EBMBook> {
        return NSFetchRequest<EBMBook>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: Int16
    @NSManaged public var iTunesId: Int32
    @NSManaged public var author: EBMAuthor?

}
