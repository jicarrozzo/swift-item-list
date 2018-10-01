//
//  DetailItemViewController.swift
//  item-list
//
//  Created by admin on 10/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


protocol RemItem{
    func remItem(itemId:String)
}

protocol EditItem{
    func editItem(itemId:String, body:String)
}


class DetailItemViewController: UIViewController {

    var myItem: Item?
    var delegateEdit: EditItem?
    var delegateRem: RemItem?
    
    @IBOutlet weak var txtItem: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if myItem != nil {
            txtItem.text = myItem?.body
        }
    }


    @IBAction func onDelete(_ sender: Any) {
        delegateRem?.remItem(itemId: myItem!.id)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        delegateEdit?.editItem(itemId: myItem!.id, body: txtItem.text!)
        navigationController?.popViewController(animated: true)    }
}
