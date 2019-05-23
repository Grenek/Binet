//
//  NewEntryViewController.swift
//  Binet
//
//  Created by Вадим on 22/05/2019.
//  Copyright © 2019 Shamratov Vadim. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController {
    
    let apiManager = APIManager()
    let entriesTableVC = EntriesTableViewController()
    var body = String()
    var session = ""

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.session = defaults.string(forKey: "sessionID")!
        
        saveButton.isEnabled = false
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        newEntry()
        apiManager.addEntry(session: session, body: self.body)
        dismiss(animated: true)
    }
    
    @objc private func textFieldChanged(){
        if textField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func newEntry() {
        body = textField.text!
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
