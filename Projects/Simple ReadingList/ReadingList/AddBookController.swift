import UIKit

@objc protocol BookEditing {
    // TODO: Add completion closure property
    var completion: ((_: Book) -> Void)? { get set }
}

class AddBookController: UITableViewController, BookEditing, UndoManaging
{
    var selectedTextField: UITextField!
    
    var completion: ((Book) -> Void)?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var redoButton: UIButton!
    @IBOutlet var accessoryView: UIView?
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
    
    var book: Book {
        return Book(dictionary: [Book.titleKey: titleField.text ?? "",
                                 Book.yearKey: yearField.text ?? "",
                                 Book.authorKey: [Author.firstNameKey: firstNameField.text ?? "",
                                                  Author.lastNameKey: lastNameField.text ?? ""]])
    }
    
    func loadUndoRedoNib() {
        Bundle.main.loadNibNamed("UndoRedo", owner: self, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUndoManagerObservation()
        loadUndoRedoNib()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Done" {
            completion?(book)
        }
    }
}

extension AddBookController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return editingChanged(textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingEnded()
    }
}

