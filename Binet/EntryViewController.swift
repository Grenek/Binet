//
//  EntryViewController.swift
//  Binet
//
//  Created by Вадим on 22/05/2019.
//  Copyright © 2019 Shamratov Vadim. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    var da = ""
    var dm = ""
    var body = ""
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var modificationDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyLabel.text = body
        creationDateLabel.text = "Создано: \(da)"
        if dm != da {
            modificationDateLabel.text = "Редактировано: \(dm)"
        } else {
            modificationDateLabel.text = ""
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
