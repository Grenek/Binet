//
//  EntriesTableViewController.swift
//  
//
//  Created by Вадим on 07/05/2019.
//

import UIKit
import Alamofire
import SwiftyJSON

class EntriesTableViewController: UITableViewController {
    
    let apiManager = APIManager()
    var session = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // проверяем есть ли интернет
        guard apiManager.isConnectedToInternet() == true else {
            showAlert()
            return
        }

        // определяем session
        let defaults = UserDefaults.standard
        guard let session = defaults.string(forKey: "sessionID") else
        {
            apiManager.newSession { result in
                switch result {
                case .failure(let error):
                    print(error)
                    self.showAlert()
                case .success(let sessionID):
                    print(sessionID)
                    defaults.set(sessionID, forKey: "sessionID")
                    self.session = defaults.string(forKey: "sessionID")!
                }
            }
            return
        }
        self.session = session

        //получаем список записей
        apiManager.getEntries(session) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.showAlert()
            case .success(let entries):
                self.apiManager.parseEntries(entries: entries)
                self.apiManager.unixDateCreatedToString(da: self.apiManager.da)
                self.apiManager.unixDateModifiedToString(dm: self.apiManager.dm)
                self.tableView.reloadData()
            }
        }
    }
    
    // "pull to refresh"
    @IBAction func refresh(_ sender: UIRefreshControl) {
        
        guard apiManager.isConnectedToInternet() == true else {
            showAlert()
            sender.endRefreshing()
            return
        }
        
        apiManager.makeArraysEmpty()
        apiManager.getEntries(session) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.showAlert()
            case .success(let entries):
                print(entries)
                self.apiManager.parseEntries(entries: entries)
                self.apiManager.unixDateCreatedToString(da: self.apiManager.da)
                self.apiManager.unixDateModifiedToString(dm: self.apiManager.dm)
                self.tableView.reloadData()
            }
        }
        sender.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiManager.id.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Отображение тела записи с ограничением в 200 символов
        let body = apiManager.body[indexPath.row]
        let nsString = body as NSString
        if nsString.length >= 200 {
            cell.textLabel?.text = nsString.substring(with: NSRange(location: 0, length: nsString.length > 200 ? 200 : nsString.length))
        } else {
            cell.textLabel?.text = apiManager.body[indexPath.row]
        }
        
        // Отображение даты записи и логика отображения даты модификации
        if apiManager.da[indexPath.row] == apiManager.dm[indexPath.row]{
            cell.detailTextLabel?.text = "Создано \(apiManager.dateCreated[indexPath.row])"
        } else {
            cell.detailTextLabel?.text = "Создано \(apiManager.dateCreated[indexPath.row]); Редактировано \(apiManager.dateModified[indexPath.row])"
        }
        return cell
    }
    
    //сегвей в entryviewcontroller
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let body = apiManager.body[indexPath.row]
        let da = apiManager.dateCreated[indexPath.row]
        let dm = apiManager.dateModified[indexPath.row]
        let entryVC = segue.destination as! EntryViewController
        entryVC.body = "\(body)"
        entryVC.da = "\(da)"
        entryVC.dm = "\(dm)"
     }
    
    //показываем ошибку и обновляем данные при нажатии на кнопку
    func showAlert() {
        let ac = UIAlertController(title: "Нет интернета", message: "Проверьте соединение с сетью", preferredStyle: .alert)
        let refresh = UIAlertAction(title: "Обновить данные", style: .default)
        { (action) in
            self.apiManager.getEntries(self.session) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let entries):
                    print(entries)
                    self.apiManager.parseEntries(entries: entries)
                    self.apiManager.unixDateCreatedToString(da: self.apiManager.da)
                    self.apiManager.unixDateModifiedToString(dm: self.apiManager.dm)
                    self.tableView.reloadData()
                }
            }
        }
        ac.addAction(refresh)
        present(ac, animated: true, completion: nil)
    }
}
