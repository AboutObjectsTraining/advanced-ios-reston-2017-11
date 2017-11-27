// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var iTunesId: Int32
    @NSManaged public var rating: Int16
    @NSManaged public var title: String?
    @NSManaged public var year: Int16
    @NSManaged public var author: Author?

}
