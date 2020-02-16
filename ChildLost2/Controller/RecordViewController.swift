//
//  RecordViewController.swift
//  ChildLost2
//
//  Created by 龙锐 on 2019/12/6.
//  Copyright © 2019 龙锐. All rights reserved.
//

import Foundation
import UIKit
class RecordViewController: UITableViewController{
 
     override func viewDidLoad() {
           super.viewDidLoad()
       }
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let myheadlines = headlines else{return 0}
        return getInformation().headlins.count
    }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
//            guard let myheadlines = headlines else{return UITableViewCell(style: .subtitle, reuseIdentifier: "Item")}
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)

            let headline = getInformation().headlins[indexPath.row]
            let lat = Float(headline.lat)
            let lng = Float(headline.lng)
    cell.textLabel?.text = headline.title
    cell.detailTextLabel?.text = "Lattitude:\(lat),Longtitude:\(lng)"
    cell.imageView?.image = UIImage(named: headline.picname)

            return cell
        }
    
    func getInformation()->Headlines{
        if let url = try?FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Untitled.json"){
        if let jsonData = try? Data(contentsOf: url){
            return Headlines(json:jsonData)!
        }
        }
        return Headlines()
            
        
    }
}
