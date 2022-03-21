//
//  ViewController.swift
//  Notes
//
//  Created by Анита Самчук on 06.02.2022.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()

    @objc func didTapAdd() {
        let alertController = UIAlertController(title: "Назовите вашу заметку", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Список покупок..."
            textField.autocapitalizationType = .sentences
        }
        let alertAction1 = UIAlertAction(title: "Отмена", style: .default) { (alert) in
        }
        
        let alertAction2 = UIAlertAction(title: "Создать", style: .default) { (alert) in
            let newItem: String
            if alertController.textFields?[0].text != "" {
                newItem = alertController.textFields?[0].text ?? ""
            } else {
                newItem = "Без названия"
            }
            noteItems.append(["title": newItem, "note" : ""])
            let count = noteItems.count - 1
            let vc = NoteViewController(title: newItem, note: "")
            vc.completion = { noteTitle, note in
                noteItems[count]["title"] = noteTitle
                if note == "" {
                    noteItems[count]["note"] = "Нет дополнительного текста"
                } else {
                    noteItems[count]["note"] = note
                }
                self.tableView.reloadData()
                }
            self.navigationController?.pushViewController(vc, animated: true)

    }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        alertController.preferredAction = alertAction2
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func didTapEdit(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        let addBarItem = UIBarButtonItem(image: UIImage(named: "add.imageset"), style: .plain, target: self, action: #selector(didTapAdd))
        let editBarItem = UIBarButtonItem(image: UIImage(named: "edit.imageset"), style: .plain, target: self, action: #selector(didTapEdit))
        navigationItem.rightBarButtonItems = [addBarItem, editBarItem]
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.identifier, for: indexPath
        ) as? TableViewCell else {return UITableViewCell()}
        
        cell.configure(row: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NoteViewController(title: noteItems[indexPath.row]["title"] ?? "Заметка", note: noteItems[indexPath.row]["note"] ?? "")
        vc.completion = { noteTitle, note in
            noteItems[indexPath.row]["title"] = noteTitle
            noteItems[indexPath.row]["note"] = note
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
    }
    
}

