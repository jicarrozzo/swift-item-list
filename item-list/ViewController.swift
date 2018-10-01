//
//  ViewController.swift
//  item-list
//
//  Created by admin on 9/6/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

var itemIndex = 0

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, AddItem, RemItem, EditItem {
  
    var mySession: Session?
    var list: [Item] = []
    
    @IBOutlet weak var listOfItems: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        start()
    }
    
    func start(){
        
        SessionController.create { (session, error) in
            if let err = error as? ConnectionHelper.ConnectionError {
                if err == ConnectionHelper.ConnectionError.NoInternet {
                    self.showReloadMessage()
                    return
                }
                ConnectionHelper.ErrorParser(error: err, vc: self)
                return
            }
            self.mySession = session
            print(self.mySession)
            self.reloadList()
        }
    }
    
    func showReloadMessage(){
        let alert = UIAlertController(title: "No Internet Conetion", message: "Something went wrong with the service, please try again in a moment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: .default) { (action) in
            self.start()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }

    
    /// Table Functions
    
    func reloadList(){
        ItemsController.fetch(withSessionID: self.mySession!.session_id, completion: { (items, error) in
            if let err = error as? ConnectionHelper.ConnectionError {
                if err == ConnectionHelper.ConnectionError.NoInternet {
                    self.showReloadMessage()
                    return
                }
                ConnectionHelper.ErrorParser(error: err, vc: self)
                return
            }
            self.list = items!
            DispatchQueue.main.async {
                self.listOfItems.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell
        item.lblBody.text = list[indexPath.row].body
        return item
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemIndex = indexPath.row
        performSegue(withIdentifier: "segueDetail", sender: self)
    }
    /// /Table Functions
    
    /// Segue Handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let back = UIBarButtonItem()
        back.title = "Cancel"
        navigationItem.backBarButtonItem = back

        if(segue.identifier == "segueDetail"){
            let vc = segue.destination as! DetailItemViewController
            vc.myItem = list[itemIndex] as Item
            vc.delegateEdit = self
            vc.delegateRem = self
        } else {
            let vc = segue.destination as! AddItemViewController
            vc.delegate = self
        }
    }
    /// /Segue Handler
    

    /// Oper Functions
    func addItem(body: String) {
        ItemsController.add(withSessionID: self.mySession!.session_id, withBody: body) { (error) in
            if let err = error as? ConnectionHelper.ConnectionError {
                if err == ConnectionHelper.ConnectionError.NoInternet {
                    self.showReloadMessage()
                    return
                }
                ConnectionHelper.ErrorParser(error: err, vc: self)
                return
            }
            self.reloadList()
        }
    }
    func editItem(itemId: String, body: String) {
        ItemsController.edit(withSessionID: self.mySession!.session_id, withItemID: itemId, withBody: body) { (error) in
            if let err = error as? ConnectionHelper.ConnectionError {
                if err == ConnectionHelper.ConnectionError.NoInternet {
                    self.showReloadMessage()
                    return
                }
                ConnectionHelper.ErrorParser(error: err, vc: self)
                return
            }
            self.reloadList()
        }
    }
    func remItem(itemId: String) {
        ItemsController.rem(withSessionID: self.mySession!.session_id, withItemID: itemId) { (error) in
            if let err = error as? ConnectionHelper.ConnectionError {
                if err == ConnectionHelper.ConnectionError.NoInternet {
                    self.showReloadMessage()
                    return
                }
                ConnectionHelper.ErrorParser(error: err, vc: self)
                return
            }
            self.reloadList()
        }
    }
    /// /Oper Functions
}

