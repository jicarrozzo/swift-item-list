//
//  SessionController.swift
//  item-list
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class SessionController{
    
    init() {
        
    }
    
    static func create(completion: @escaping (Session?, Error?) -> ())
    {
        ConnectionHelper.CreateRequest(withParameters: "a=new_session") { (request) in
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
                if let data = data {
                    do{
                        if let resp = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            do{
                                try ConnectionHelper.ParseResponse(withResponse: resp)
                                if let dataBody = resp["data"] as? [String:Any]{
                                    
                                    if let session = dataBody["session"] as? String{
                                        completion( Session(id: session), nil)
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
    
}
