//
//  ListRestaurantView.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import UIKit
import Kingfisher

class ListRestaurantView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?
    var parent : HomeViewController?
    var loadMoreControl : LoadMoreControl?
    
    var restaurants : [RestaurantModel] = [] {
        didSet{
            self.tableView?.reloadData()
            self.loadMoreControl?.stop()
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
        
        self.addSubview(self.tableView!)
        tableView!.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        self.loadMoreControl = LoadMoreControl(scrollView: tableView!, spacingFromLastCell: 10, indicatorHeight: 60)
        self.loadMoreControl!.delegate = self
        
    }
    
    
    // MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.restaurants[indexPath.row].restaurant.name ?? "No title"
        cell.detailTextLabel?.text = self.restaurants[indexPath.row].restaurant.location?.address ?? "No title"
        
        if let str = self.restaurants[indexPath.row].restaurant.thumb, let url = URL(string: str) {
            
            cell.imageView?.kf.setImage(with: url,placeholder: UIImage(named: "Flag"))
            
        }else{
            cell.imageView?.image = UIImage(named: "Flag")
        }
        cell.accessoryType = .detailDisclosureButton
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parent?.showDetailof(restaurant: self.restaurants[indexPath.row])
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.loadMoreControl?.didScroll()
    }

}

extension ListRestaurantView: LoadMoreControlDelegate {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        self.parent?.showMoreData()
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        print("didStopAnimating")
    }
}
