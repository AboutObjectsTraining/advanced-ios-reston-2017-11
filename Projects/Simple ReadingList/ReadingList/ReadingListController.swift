import UIKit

class ReadingListController: UITableViewController
{
    @IBOutlet var dataSource: BookDataSource!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            UIView.animate(withDuration: 0.1) { [weak self] in
                var frame = self?.tableView?.tableHeaderView?.frame
                frame?.size.height = 0
                self?.spinner.alpha = 0
                self?.tableView?.tableHeaderView?.frame = frame ?? CGRect.zero }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        dataSource.load(delay: 0) { [weak self] in self?.hideSpinner() }
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "View":
            guard let detailController = segue.realDestination as? BookViewing,
                let indexPath = tableView.indexPathForSelectedRow else {
                    fatalError("View Book controller must conform to the BookViewing protocol")
            }
            detailController.book = dataSource.book(at: indexPath)
        case "Add":
            guard let addController = segue.realDestination as? BookEditing else {
                fatalError("Add Book controller must conform to the BookEditing protocol")
            }
            addController.completion = { [weak self] book in self?.dataSource.insert(book: book) }
        default:
            fatalError("Unknown segue identifier: \(segue.identifier ?? "null")")
        }
    }
}

// MARK: - Unwind Segues
extension ReadingListController
{
    @IBAction func doneEditing(segue: UIStoryboardSegue) { dataSource.save() }
    @IBAction func doneAdding(segue: UIStoryboardSegue) { }
    @IBAction func cancelAdding(segue: UIStoryboardSegue) { }
}
