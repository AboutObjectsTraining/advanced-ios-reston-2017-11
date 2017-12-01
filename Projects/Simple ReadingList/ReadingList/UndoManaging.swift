import UIKit

@objc protocol UndoManaging
{
    @objc var undoButton: UIButton! { get }
    @objc var redoButton: UIButton! { get }
    @objc var selectedTextField: UITextField! { get set }
}

extension UndoManaging
{
    func editingChanged(_ textField: UITextField) -> Bool {
        undoButton.isEnabled = true
        selectedTextField = textField
        return true
    }
    
    func editingEnded() {
        undoButton.isEnabled = false
        redoButton.isEnabled = false
    }
    
    func configureUndoManagerObservation() {
        NotificationCenter.default.addObserver(forName: .NSUndoManagerDidUndoChange, object: nil, queue: nil) { [weak self] notification in
            self?.undoButton.isEnabled = self?.selectedTextField?.undoManager?.canUndo ?? false
            self?.redoButton.isEnabled = true
        }
        NotificationCenter.default.addObserver(forName: .NSUndoManagerDidRedoChange, object: nil, queue: nil) { [weak self] notification in
            self?.redoButton.isEnabled = self?.selectedTextField?.undoManager?.canRedo ?? false
            self?.undoButton.isEnabled = true
        }
    }
}
