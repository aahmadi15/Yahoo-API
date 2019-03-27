//
//  YahooAPI.swift
//  as2
//
//  Created by user145521 on 12/6/18.
//  Copyright © 2018 user145521. All rights reserved.
//

import Foundation

protocol YahooDelegate{
    
    func didFinish(temp : NSArray)
}

class YahooAPI{
    var delegate : YahooDelegate?
    
    func getData(url : URL, handler : @escaping (Data)->()){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config) // fifth
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                handler(data!) // seventh
            }
            else {
                
                print (error ?? "error")
            }
        }
        task.resume()
        
    }
    
    func getYahoo(text : String){
        let urlString = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=\(text)&region=1&lang=en"// second
        
        
        
       // let urlObject = URL(string: urlString) // third
        
        //do{
        
//        var json = try! String(contentsOf: URL(string: urlString)!, encoding: String.Encoding.utf8)
//        //}
//          /*  catch {
//                print(Error.self)
//            }*/
//        let index: String.Index = json.index(json.startIndex, offsetBy: 39)
//
//        json = "\(index)"
//
//        json.removeLast()
//        json.removeLast()
        let newUrlObject = URL(string: urlString)
        getData(url: newUrlObject!, handler: { (jsonData) in
            // parse json // eighth step
            do {
                
                let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary;
                // let temp = jsonDic.value(forKeyPath: "main.temp") as! Double
                var value : NSArray
                value = jsonDic.value(forKeyPath: "ResultSet.Result") as! NSArray
                
                DispatchQueue.main.async {
                    self.delegate?.didFinish(temp: value)
                }
                
            }
            catch {
                print(error)
            }
        })
        
    }
    
}

