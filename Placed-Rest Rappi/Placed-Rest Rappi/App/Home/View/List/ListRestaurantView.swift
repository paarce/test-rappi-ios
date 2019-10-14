//
//  ListRestaurantView.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import UIKit

class ListRestaurantView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?
    var parent : HomeViewController?
    
    var restaurants : [RestaurantModel] = [] {
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    func iniUI(parent : HomeViewController) {
        
        self.parent = parent
        self.configTableView()
    }
    
    func configTableView() {
        
        tableView = UITableView()
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //self.tableView?.allowsSelection = false
        
        self.addSubview(self.tableView!)
        tableView!.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.restaurants[indexPath.row].restaurant.name ?? "No title"
        cell.detailTextLabel?.text = self.restaurants[indexPath.row].restaurant.location.address ?? "No title"
        cell.imageView?.image = UIImage(named: "Flag")
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parent?.showDetailof(restaurant: self.restaurants[indexPath.row])
    }

}
