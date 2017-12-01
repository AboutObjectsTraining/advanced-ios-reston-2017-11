import UIKit

@objc protocol BookViewing {
    var book: Book? { get set }
}

class BookDetailController: UITableViewController, BookViewing
{
    var book: Book?
    
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var yearCell: UITableViewCell!
    @IBOutlet weak var firstNameCell: UITableViewCell!
    @IBOutlet weak var lastNameCell: UITableViewCell!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleCell.detailTextLabel?.text = book?.title
        yearCell.detailTextLabel?.text = book?.year
        firstNameCell.detailTextLabel?.text = book?.author?.firstName
        lastNameCell.detailTextLabel?.text = book?.author?.lastName
        imageView.image = UIImage.image(named: book?.author?.lastName ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editController = segue.realDestination as? EditBookController else {
            fatalError("Unable to downcast to EditBookController")
        }
        editController.book = book
    }
    
    @IBAction func cancelEditing(segue: UIStoryboardSegue) {
        // TODO: (never mind)
    }
}

extension UIImage
{
    class func image(named name: String, default: String = "NoImage") -> UIImage? {
        guard let image = UIImage(named: name) else { return UIImage(named: `default`) }
        return image
    }
}

