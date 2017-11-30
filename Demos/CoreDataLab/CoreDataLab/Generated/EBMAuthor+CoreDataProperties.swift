//
//  EBMAuthor+CoreDataProperties.swift
//  CoreDataLab
//
//  Created by Jonathan Lehr on 11/29/17.
//  Copyright © 2017 About Objects. All rights reserved.
//
//

import Foundation
import CoreData


extension EBMAuthor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EBMAuthor> {
        return NSFetchRequest<EBMAuthor>(entityName: "Author")
    }

    @NSManaged public var name: String?
    @NSManaged public var iTunesId: Int32
    @NSManaged public var books: NSOrderedSet?

}

// MARK: Generated accessors for books
extension EBMAuthor {

    @objc(insertObject:inBooksAtIndex:)
    @NSManaged public func insertIntoBooks(_ value: EBMBook, at idx: Int)

    @objc(removeObjectFromBooksAtIndex:)
    @NSManaged public func removeFromBooks(at idx: Int)

    @objc(insertBooks:atIndexes:)
    @NSManaged public func insertIntoBooks(_ values: [EBMBook], at indexes: NSIndexSet)

    @objc(removeBooksAtIndexes:)
    @NSManaged public func removeFromBooks(at indexes: NSIndexSet)

    @objc(replaceObjectInBooksAtIndex:withObject:)
    @NSManaged public func replaceBooks(at idx: Int, with value: EBMBook)

    @objc(replaceBooksAtIndexes:withBooks:)
    @NSManaged public func replaceBooks(at indexes: NSIndexSet, with values: [EBMBook])

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: EBMBook)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: EBMBook)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSOrderedSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSOrderedSet)

}
