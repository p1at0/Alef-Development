//
//  ViewController.swift
//  Test_task_AlefDevelopment
//
//  Created by Assylzhan Nurlybekuly on 08.11.2021.
//

import UIKit
struct Model {
    let name: String
    let age: Int
    var id: Int
}
class ViewController: UIViewController {
    
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteAllButton: UIButton!
    private var data = [Model]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBorders()
        setUpViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped))
        addView.addGestureRecognizer(tap)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    @objc private func addButtonTapped(){
        let alert = UIAlertController(title: nil , message: "Введите имя и возраст ребенка", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.addConstraint(textfield.heightAnchor.constraint(equalToConstant: 34))
            textfield.font = UIFont(name: "System", size: 17)
            textfield.placeholder = "Имя"
            textfield.becomeFirstResponder()
        }
        alert.addTextField { textfield in
            textfield.addConstraint(textfield.heightAnchor.constraint(equalToConstant: 34))
            textfield.font = UIFont(name: "System", size: 17)
            textfield.placeholder = "Возраст"
            textfield.keyboardType = .numberPad
        }
        let action = UIAlertAction(title: "Добавить ребенка", style: .default) {[weak self] action in
            guard let textfields = alert.textFields else {return}
            let nameTextField = textfields[0]
            let ageTextField = textfields[1]
            guard let name = nameTextField.text,
                  !name.replacingOccurrences(of: " ", with: "").isEmpty else {
                self?.createAlert(with: "Введите имя ребенка!")
                return
            }
            guard let ageText = ageTextField.text,
                  !ageText.replacingOccurrences(of: " ", with: "").isEmpty else {
                self?.createAlert(with: "Введите возраст ребенка")
                return
            }
            let age = Int(ageText) ?? 0
            self?.addChild(model: Model(name: name, age: age, id: 0))
        }
        
        alert.addAction(action)
        present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissSelf)))
        }
    }
    @objc private func dismissSelf(){
        self.dismiss(animated: true, completion: nil)
    }
    private func addChild(model: Model){
        data.append(Model(name: model.name, age: model.age,id: model.id))
        tableView.reloadData()
        if (data.count==5){
            addView.isHidden = true
        }
        dismissKeyboard()
    }
    private func setUpViews(){
        nameTextField.borderStyle = .none
        ageTextField.borderStyle = .none
        
        deleteAllButton.layer.cornerRadius = 27
        deleteAllButton.layer.borderWidth = 1
        deleteAllButton.layer.borderColor = UIColor.systemRed.cgColor
    }
    private func setUpBorders(){
        nameView.layer.cornerRadius = 2
        nameView.layer.borderWidth = 1
        nameView.layer.borderColor = UIColor.lightGray.cgColor
        
        ageView.layer.cornerRadius = 2
        ageView.layer.borderWidth = 1
        ageView.layer.borderColor = UIColor.lightGray.cgColor
        
        addView.layer.cornerRadius = 27
        addView.layer.borderWidth = 1
        addView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    @IBAction func deleteAllButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Сбросить данные", style: .default, handler: {[weak self]_ in
            self?.deleteAllData()
        }))
        present(actionSheet, animated: true)
    }
    private func deleteAllData(){
        if (data.count==5){
            addView.isHidden = false
        }
        nameTextField.text = ""
        ageTextField.text = ""
        data.removeAll()
        tableView.reloadData()
    }
    private func createAlert(with message: String){
        let title = "Внимание!"
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell else { return
            UITableViewCell()
        }
        data[indexPath.row].id = indexPath.row
        cell.configure(model: data[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 204
    }
}

extension ViewController: CustomDelegate {
    func remove(at id: Int) {
        for index in 0..<data.count {
            if data[index].id == id {
                data.remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                break
            }
        }
        if (data.count==4){
            addView.isHidden = false
        }
    }
    
    
}

