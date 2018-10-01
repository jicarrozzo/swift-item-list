//
//  ItemCell.swift
//  item-list
//
//  Created by admin on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

   
    @IBOutlet weak var lblBody: UILabel!
    
    @IBOutlet weak var btnShowDetail: UIButton!
    @IBAction func onClick(_ sender: Any) {
    }
    
    var itemViewModel: ItemViewModel! {
        didSet{
            lblBody?.text = itemViewModel.body
        }
    }
}
