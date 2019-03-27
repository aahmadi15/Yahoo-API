//
//  Display.swift
//  as2
//
//  Created by user145521 on 12/7/18.
//  Copyright © 2018 user145521. All rights reserved.
//

import UIKit
import CoreData

class Display: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, YahooDelegate {
    
    var arr : NSArray = []
    
    var yahoo = YahooAPI()
    
    @IBOutlet weak var pickTable: UITableView!
    
    func didFinish(temp: NSArray) {
        arr = temp
        pickTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        yahoo.getYahoo(text: searchText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
     //   let myDic = self.arr.index(of: indexPath) as! NSDictionary
     let   myDic = arr[indexPath.row] as! NSDictionary
        
        
        var myName : String
        var mySymbol : String
        
        myName = myDic.value(forKey: "name") as! String
        
        mySymbol = myDic.value(forKey: "symbol") as! String
        
        cell.textLabel?.text = myName
        cell.detailTextLabel?.text = mySymbol
        return cell;
    }
    
    var viewc = ViewController()
    var myData = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var allId : [Stocks]? = [Stocks]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   //     pickTable.reloadData()
    let name = pickTable.cellForRow(at: indexPath)?.textLabel?.text
        
        if !checkForDublication(name: name!) {// not in database
         
            let newStock = NSEntityDescription.insertNewObject(forEntityName: "Stocks", into: myData) as! Stocks
            if let name = pickTable.cellForRow(at: indexPath)?.textLabel?.text{
                if let id = pickTable.cellForRow(at: indexPath)?.detailTextLabel?.text{
                    
                    newStock.name = name
                    newStock.id = id
                    
            allId?.append(newStock)
            
            let indexToinsert = (allId?.count)! - 1
            let newIndexPath = NSIndexPath(item: indexToinsert, section: 0)
            //viewc.callTable.insertRows(at: [newIndexPath as IndexPath], with: UITableView.RowAnimation.fade)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        }
    }
        
    if let navController = self.navigationController{
    navController.popViewController(animated: true)
    }
        
        
         
    }
    
    //checks for duplication 
    func checkForDublication(name : String) -> Bool {
        var isInDatabase = false
    
        let myFetchRequest : NSFetchRequest<Stocks> = Stocks.fetchRequest()
        let predicate = NSPredicate(format: "name contains[cd]  %@" , name)
        myFetchRequest.predicate = predicate
        
        
        do {
            let results =  try  myData.fetch(myFetchRequest)
            if results.count ?? 0 > 0{ // the stock is  in database
                isInDatabase = true
            }
            else{ // the stock is not in database
                isInDatabase = false
            }
        }
        catch{
            
            print("fetch throw an error")
        }
    
        
        return isInDatabase
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        yahoo.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
