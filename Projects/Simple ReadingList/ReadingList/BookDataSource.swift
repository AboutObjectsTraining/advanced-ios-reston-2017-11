import UIKit

class BookDataSource: NSObject
{
    @IBOutlet var tableView: UITableView!
    
    lazy var store: ReadingListStore = ReadingListStore("BooksAndAuthors")
    var readingList: ReadingList?
    
    func load(delay seconds: Double = 0, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: DispatchTime.now() + seconds) { [weak self] in
            self?.readingList = self?.store.fetch()
            self?.refresh()
            completion()
        }
    }
    
    func load() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.readingList = self?.store.fetch()
            self?.refresh()
        }
    }
    
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func save() {
        guard let readingList = readingList else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.store.save(readingList: readingList)
        }
    }
    
    func book(at indexPath: IndexPath) -> Book? {
        return readingList?.books[indexPath.row]
    }
    
    func insert(book: Book) {
        readingList?.books.insert(book, at: 0)
        if let readingList = readingList { store.save(readingList: readingList) }
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

extension BookDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList?.books.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookSummary") else {
            fatalError("Unable to dequeue cell with identifier \"BookSummary\". Make sure identifier is correctly set in storyboard.")
        }
        let book = readingList?.books[indexPath.row]
        cell.textLabel?.text = book?.title
        cell.detailTextLabel?.text = "\(book?.year ?? "   ") \(book?.author?.fullName ?? "Unknown")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let readingList = readingList else { return }
        readingList.books.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        store.save(readingList: readingList)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let readingList = readingList else { return }
        let book = readingList.books[sourceIndexPath.row]
        readingList.books.remove(at: sourceIndexPath.row)
        readingList.books.insert(book, at: destinationIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        store.save(readingList: readingList)
    }
}
