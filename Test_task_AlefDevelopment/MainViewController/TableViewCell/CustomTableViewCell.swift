//
//  CustomTableViewCell.swift
//  Test_task_AlefDevelopment
//
//  Created by Assylzhan Nurlybekuly on 08.11.2021.
//

import UIKit
protocol CustomDelegate: AnyObject {
    func remove(at index: Int)
}
class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var id: Int?
    
    var delegate: CustomDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpBorders()
        setUpTextFields()
    }
    private func setUpTextFields(){
        nameTextField.borderStyle = .none
        ageTextField.borderStyle = .none
        
        nameTextField.isEnabled = false
        ageTextField.isEnabled = false
    }
    private func setUpBorders(){
        nameView.layer.cornerRadius = 2
        nameView.layer.borderWidth = 1
        nameView.layer.borderColor = UIColor.lightGray.cgColor
        
        ageView.layer.cornerRadius = 2
        ageView.layer.borderWidth = 1
        ageView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let id = self.id else {return}
        self.delegate?.remove(at: id)
    }
    public func configure(model: Model){
        nameTextField.text = model.name
        ageTextField.text = String(model.age)
        self.id = model.id
    }
}
