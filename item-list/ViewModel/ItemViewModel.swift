//
//  ItemViewModel.swift
//  item-list
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct ItemViewModel {
    let id:String
    let body:String
    let da:String
    let dm:String
    
    // DI
    init(item:Item) {
        self.id = item.id
        self.body = item.body
        self.da = item.da
        self.dm = item.dm
    }
    
}
