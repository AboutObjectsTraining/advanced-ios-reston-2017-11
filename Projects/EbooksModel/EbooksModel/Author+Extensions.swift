// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import CoreData

extension Author
{
    static let booksKey = "books"
    
    public override func setValuesForKeys(_ keyedValues: JsonDictionary) {
        let attributeValues = keyedValues.filter { $0.key != Author.booksKey }
        super.setValuesForKeys(attributeValues)
        
        guard let context = managedObjectContext,
            let bookDicts = keyedValues[Author.booksKey] as? [JsonDictionary] else {
            return
        }
        
        let books = orderedBooks(from: bookDicts, insertedIn: context)
        super.setValue(books, forKey: Author.booksKey)
    }
    
    func orderedBooks(from dictionaries: [JsonDictionary], insertedIn context: NSManagedObjectContext) -> NSOrderedSet {
        let books: [Book] = dictionaries.map {
            let book = Book(dictionary: $0, context: context)
            book.author = self
            return book
        }
        return NSOrderedSet(array: books)
    }
}

