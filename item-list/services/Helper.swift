//
//  Helper.swift
//  item-list
//
//  Created by admin on 9/27/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class ConnectionHelper{
    static let token:String = "H42A1cP-qm-EjM4hOG"
    static let baseUrl:String = "https://bnet.i-partner.ru/testAPI/"

    enum ConnectionError: Error {
        case NoInternet
        case TokenError
        case SessionError
        case EntryError
        case UnknownError
    }
    
    
    init() {
        
    }
    
    static func CreateRequest(withParameters: String, completion: @escaping (NSMutableURLRequest) -> ()){
        // Harcode token from API request_token method => H42A1cP-qm-EjM4hOG
        // fyi: API not working properly. Use hardcode token and session ID
        
        let headers = [
            "token": token,
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let postData = NSMutableData(data: withParameters.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        completion(request)
    }
    
    static func generaticCUD(withParameters:String, completion: @escaping(Error?) -> ()){
        ConnectionHelper.CreateRequest(withParameters: withParameters) { (request) in
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
                if let data = data {
                    do{
                        print(data)
                        if let resp = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            do{
                                try ConnectionHelper.ParseResponse(withResponse: resp)
                                completion(nil)
                            }
                            catch let er as ConnectionHelper.ConnectionError {
                                completion(er)
                            }
                        }
                    }catch{
                        completion(ConnectionError.NoInternet)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    static func ErrorParser(error:ConnectionError, vc: UIViewController){
        switch(error){
        case .NoInternet:
            Alert.showBasic(title: "No Internet", message: "Something went wrong, please try later", vc: vc)
        case .TokenError:
            Alert.showBasic(title: "Wrong token", message: "Please check your token", vc: vc)
        case .SessionError:
            Alert.showBasic(title: "Session error", message: "You have a wrong session id.", vc: vc)
        case .EntryError:
            Alert.showBasic(title: "Item not found", message: "The item does not exist on our DB", vc: vc)
        case .UnknownError:
            Alert.showBasic(title: "Unknown error", message: "Ups! this is an unspecified error", vc: vc)
        }
        
    }
    
    
    static func ParseResponse(withResponse:[String:Any]) throws   {
        let status: NSNumber = withResponse["status"] as! NSNumber
        if status == 0 {
            let error: String = withResponse["error"] as! String
            switch(error){
            case "unspecified header 'token'":
               throw ConnectionError.TokenError
            case "unspecified field 'session'":
                throw ConnectionError.SessionError
            case "invalid session":
                throw ConnectionError.SessionError
            case "invalid token":
                throw ConnectionError.TokenError
            case "Entry not found":
                throw ConnectionError.EntryError
            default:
                print(error)
                throw ConnectionError.UnknownError
            }
        }
        
    }
    
}
