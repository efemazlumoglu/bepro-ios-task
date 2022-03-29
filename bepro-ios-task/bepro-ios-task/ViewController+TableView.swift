//
//  ViewController+TableView.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 28.03.2022.
//

import Foundation
import UIKit

//MARK: ViewController extension for TableViewDelegate and Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.listOfOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration() // when you are using default table view cell you have to use config cause textLabel etc is deprecated.
        if (data == "First Half") {
            config.text = ViewModel.shared.firstHalfVideoTitle
        } else {
            config.text = ViewModel.shared.secondHalfVideoTitle
        }
        if data == ViewModel.shared.videoURL { // double check for you cannot click on the first half video title if you are already in the first half
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.listOfOptions[indexPath.row]
        if ViewModel.shared.videoURL != data { //you cannot click on the first half video title if you are already in the first half
            self.callHalfs(halfOption: data)
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
