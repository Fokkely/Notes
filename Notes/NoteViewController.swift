//
//  NoteViewController.swift
//  Notes
//
//  Created by Анита Самчук on 06.02.2022.
//

import UIKit
import SnapKit

class NoteViewController: UIViewController, UITextViewDelegate {

    var noteTitle: String
    var noteText: String
    
    public var completion: ((String, String) -> Void)?
    
    init(title: String, note: String) {
        self.noteTitle = title
        self.noteText = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.font = UIFont.boldSystemFont(ofSize: 40)
        return title
    }()

    private let noteTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 20)
        text.isEditable = true
        text.isSelectable = true
        text.spellCheckingType = UITextSpellCheckingType.yes
        return text
    }()
    
    @objc func didTapDone() {
        if let text = noteTextView.text, !text.isEmpty {
            completion?(titleLabel.text ?? "", text)
        }
        self.noteTextView.endEditing(true)
    }
    
    @objc func didTapEdit() {
        let alertController = UIAlertController(title: "Переименовать заметку", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Название..."
            textField.autocapitalizationType = .sentences
        }
        let alertAction1 = UIAlertAction(title: "Отмена", style: .default) { (alert) in
        }
            
        let alertAction2 = UIAlertAction(title: "Готово", style: .default) { [self] (alert) in
            if let text = alertController.textFields?[0].text, !text.isEmpty {
                completion?(text, noteTextView.text)
                titleLabel.text = alertController.textFields?[0].text
            }
            }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        alertController.preferredAction = alertAction2
        present(alertController, animated: true, completion: nil)
        }
    
    
    func noteTypeset() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(10)        }
        
        view.addSubview(noteTextView)
        noteTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configurate(with title: String, note: String) {
        titleLabel.text = title
        noteTextView.text = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        
        navigationItem.largeTitleDisplayMode = . never
        
        noteTypeset()
        configurate(with: noteTitle, note: noteText)
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
                self.titleLabel.isUserInteractionEnabled = true
                self.titleLabel.addGestureRecognizer(labelTap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 10, right: 0)
        }

        noteTextView.scrollIndicatorInsets = noteTextView.contentInset

        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.noteTextView.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let doneBarItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItems = [doneBarItem]
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if let text = noteTextView.text{
            completion?(titleLabel.text ?? "", text)
        }
        navigationItem.rightBarButtonItems?.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if let text = noteTextView.text {
                completion?(titleLabel.text ?? "", text)
            }
        }
    }

}
