//
//  ItemsController.swift
//  item-list
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class ItemsController{
    
    static func fetch(withSessionID:String,completion: @escaping ([Item]?, Error?) -> ()){
        
        let parameters = "a=get_entries&session=" + withSessionID
        
        ConnectionHelper.CreateRequest(withParameters: parameters) { (request) in
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
                if let data = data {
                    do{
                        if let resp = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            do{
                                try ConnectionHelper.ParseResponse(withResponse: resp)
                                
                                if let dataBody = resp["data"] as? [Any]{
                                    if let dataArray = dataBody[0] as? [Any]{
                                        if(dataArray.count == 0){
                                            return completion([], nil)
                                        }
                                        var finalList:[Item] = [];
                                        
                                        for i in dataArray {
                                            let a = i as! [String:String]
                                            finalList.append(Item(id: a["id"]!, body: a["body"]!, da: a["da"]!, dm: a["dm"]!))
                                        }
                                        
                                        completion(finalList, nil)
                                    }
                                }
                            }
                            catch let er as ConnectionHelper.ConnectionError {
                                completion(nil, er)
                            }
                            
                        }
                    }catch{
                        completion(nil, ConnectionHelper.ConnectionError.NoInternet)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    static func add(withSessionID:String,withBody:String, completion: @escaping (Error?) -> ()){
        
        let parameters = "a=add_entry&session=" + withSessionID + "&body=" + withBody
        ConnectionHelper.generaticCUD(withParameters: parameters) { (error) in
            if let err = error {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    static func rem(withSessionID:String,withItemID:String, completion: @escaping (Error?) -> ()){
        
        let parameters = "a=remove_entry&session=" + withSessionID + "&id=" + withItemID
        ConnectionHelper.generaticCUD(withParameters: parameters) { (error) in
            if let err = error {
                completion(err)
                return
            }
            completion(nil)
        }
        
    }
    
    static func edit(withSessionID:String, withItemID:String, withBody:String, completion: @escaping (Error?) -> ()){
        
        let parameters = "a=edit_entry&session=" + withSessionID + "&id=" + withItemID + "&body=" + withBody
        ConnectionHelper.generaticCUD(withParameters: parameters) { (error) in
            if let err = error {
                completion(err)
                return
            }
            completion(nil)
        }
    }
}
