//
//  AddItemViewController.swift
//  item-list
//
//  Created by admin on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol AddItem{
    func addItem(body:String)
}

class AddItemViewController: UIViewController {

    var delegate: AddItem?
    @IBOutlet weak var txtBody: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onClick(_ sender: Any) {
    
        if txtBody.text != "" {
            delegate?.addItem(body: txtBody.text!)
            navigationController?.popViewController(animated: true)
        }
        else
        {
            Alert.showBasic(title: "Ups", message: "Looks like you forgot the item", vc: self)
        }
        
    }
    
    
    

}

