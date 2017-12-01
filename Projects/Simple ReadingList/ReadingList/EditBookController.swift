import UIKit

class EditBookController: UITableViewController, UndoManaging
{
    var book: Book?
    
    @IBOutlet weak var titleCell: EditBookCell!
    @IBOutlet weak var yearCell: EditBookCell!
    @IBOutlet weak var firstNameCell: EditBookCell!
    @IBOutlet weak var lastNameCell: EditBookCell!
    
    weak var selectedTextField: UITextField?
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    @IBOutlet var accessoryView: UIView?
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
    
    func loadUndoRedoNib() {
        Bundle.main.loadNibNamed("UndoRedo", owner: self, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUndoManagerObservation()
        loadUndoRedoNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleCell.textField.text = book?.title
        yearCell.textField.text = book?.year
        firstNameCell.textField.text = book?.author?.firstName
        lastNameCell.textField.text = book?.author?.lastName
    }
    
    func updateBook() {
        book?.title = titleCell.textField.text
        book?.year = yearCell.textField.text
        book?.author?.firstName = firstNameCell.textField.text
        book?.author?.lastName = lastNameCell.textField.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Done" {
            updateBook()
        }
    }
}

extension EditBookController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return editingChanged(textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingEnded()
    }
}
