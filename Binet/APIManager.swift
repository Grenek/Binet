//
//  APIManager.swift
//  
//
//  Created by Вадим on 07/05/2019.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    var id: [String] = []
    var body: [String] = []
    var da: [String] = []
    var dm: [String] = []
    var dateCreated: [String] = []
    var dateModified: [String] = []
    let header = ["token" : "TDUo6EV-7P-gF2EyMd"]
    
    func newSession(completion: @escaping (Result<String>) -> Void) {
        
        let parameters: [String: Any] = ["a" : "new_session"]
        
        Alamofire.request("https://bnet.i-partner.ru/testAPI/", method: .post, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let sessionID = json["data"]["session"].string!
                completion(.success(sessionID))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getEntries(_ session: String, completion: @escaping (Result<[[String: String]]>) -> Void){

        let parameters: [String: Any] = ["a": "get_entries", "session": session]

        Alamofire.request("https://bnet.i-partner.ru/testAPI/", method: .post, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {

            case .success(let value):
                let json = JSON(value)
                let entries = json["data"][0].arrayObject as! [[String: String]]
                completion(.success(entries))

            case .failure(let error):
                completion(.failure(error))

            }
        }
    }
    
    func addEntry(session: String, body: String) {
        
        let parameters: [String: Any] = ["a": "add_entry", "session": session, "body": body]
        
        Alamofire.request("https://bnet.i-partner.ru/testAPI/", method: .post, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func editEntry(session: String, id: String, body: String) {
        
        let parameters: [String: Any] = ["a": "edit_entry", "session": session, "id": id, "body": body]
        
        Alamofire.request("https://bnet.i-partner.ru/testAPI/", method: .post, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeEntry(session: String, id: String) {
        
        let parameters: [String: Any] = ["a": "remove_entry", "session": session, "id": id]
        
        Alamofire.request("https://bnet.i-partner.ru/testAPI/", method: .post, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
  
    // MARK: TODO переделать в одну функцию 
    func unixDateCreatedToString(da: [String]) {
        for i in 0..<da.count {
            let unixDate = Double(da[i])
            let nsDate = NSDate(timeIntervalSince1970: unixDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = .current
            dateFormatter.locale = Locale(identifier: "ru_RU")
            let date = dateFormatter.string(from: nsDate as Date)
            dateCreated.append(date)
        }
    }
    
    func unixDateModifiedToString(dm: [String]) {
        for i in 0..<da.count {
            let unixDate = Double(da[i])
            let nsDate = NSDate(timeIntervalSince1970: unixDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = .current
            dateFormatter.locale = Locale(identifier: "ru_RU")
            let date = dateFormatter.string(from: nsDate as Date)
            dateModified.append(date)
        }
    }
    
    //парсим json в массивы
    func parseEntries(entries: [[String: String]]){
        for i in 0..<entries.count {
            let entry = entries[i]
            let id = entry["id"]
            let body = entry["body"]
            let da = entry["da"]
            let dm = entry["dm"]
            
            self.id.append(id!)
            self.body.append(body!)
            self.da.append(da!)
            self.dm.append(dm!)
        }
    }
    
    func makeArraysEmpty() {
        self.id = []
        self.body = []
        self.da = []
        self.dm = []
        self.dateCreated = []
        self.dateModified = []
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
