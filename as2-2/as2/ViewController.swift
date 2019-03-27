//
//  ViewController.swift
//  as2
//
//  Created by user145521 on 12/6/18.
//  Copyright © 2018 user145521. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var myData = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     @IBOutlet weak var callTable: UITableView!
    
    
    lazy var allId : [Stocks]? = [Stocks]()
    
    var yahoo = YahooAPI()
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = allId?.count
         {
         return count
         }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let thisStock = allId?[indexPath.row]
         cell?.textLabel?.text = thisStock?.name
         cell?.detailTextLabel?.text = thisStock?.id
        
        return cell!
    }
    
    func showdata() {
        guard let appDelage = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelage.persistentContainer.viewContext
        let fetchReuqst = NSFetchRequest<NSManagedObject>(entityName: "Stocks")
        do {
           let myDa = try managedContext.fetch(fetchReuqst)
            if myDa.count == 0 {
                //sth
            } else {
                // sth
            }
        } catch let err as NSError {
            print("judo", err)
        }
       
        callTable.reloadData()
    }
    
    func fetch()  {
        let myFetchRequest : NSFetchRequest<Stocks> = Stocks.fetchRequest()
        
        do {
            allId =  try  myData.fetch(myFetchRequest)
        }
        catch{
            
            print("fetch throw an error")
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "next")
        {
            if segue.destination is Display{
                
            }
        }
    }
    // for reload
    override func viewWillAppear(_ animated: Bool) {
        fetch()
        callTable.reloadData()
    }
    
    func DeleteAllData(){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       DeleteAllData()
        
        
        fetch()
        
        //showdata()
        yahoo.delegate = self as? YahooDelegate
        
        callTable.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

