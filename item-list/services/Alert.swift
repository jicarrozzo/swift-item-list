//
//  Alert.swift
//  item-list
//
//  Created by admin on 10/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    typealias AlertRereshAction = (_ handler : UIAlertAction) -> Void
    
    class func showBasic(title: String, message: String, vc:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    /*
    class func showRefresh(vc:UIViewController, refreshAction: AlertRereshAction){
        let alert = UIAlertController(title: "No Internet Conetion", message: "Something went wrong with the service, please try again in a moment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: {action in vc.refreshAction})
            
        //alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
        vc.present(alert, animated: true)
    }
 */
}
