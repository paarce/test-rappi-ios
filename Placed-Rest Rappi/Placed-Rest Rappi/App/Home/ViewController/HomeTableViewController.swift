//
//  HomeTableViewController.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeTableViewController: UITableViewController {

    var homeVM = HomeViewModel()
    var restaurants : [RestaurantModel] = []
    var showMoreProgress = true {
        didSet{
            if !showMoreProgress {
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.configSearchBar()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
//        let items = Observable.just(restaurants)
//
//        items.bind(to: self.tableView.rx.items(cellIdentifier: "restCell")) { row, model, cell in
//
//            cell.textLabel?.text = model.restaurant.name ?? "No title"
//            cell.detailTextLabel?.text = model.restaurant.location.address ?? "No title"
//            cell.selectionStyle = .none
//            }.disposed(by: disposbag)
//
//        self.tableView.rx
//            .modelSelected(RestaurantModel.self)
//            .subscribe(onNext: { value in
//
//                let vc = R.storyboard.home.restaurantDetailViewController()
//                self.navigationController?.pushViewController(vc!, animated: true)
//            })
//            .disposed(by: disposbag)
        
    }
    
    @objc func refresh(){
        self.loadData(query: nil)
    }
    
    func loadData(query : String? = nil) {
        self.showMoreProgress = true
        self.restaurants.removeAll()
        
        homeVM.callSearchObservable(query : query){ result in
            switch result{
            case .success(let model):
                if let restaurants = model.restaurants {
                    self.restaurants = restaurants
                    self.tableView.reloadData()
                    self.showMoreProgress = false
                
                }
                break
                
            case .failure(let errorT):
                print(errorT.get().message)
                break
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.restaurants.count == 0 && !self.showMoreProgress {
            
            if !self.showMoreProgress {
                tableView.setEmptyView(title: "You don't have any contact.", message: "Your contacts will be in here.")
            }else{
                return 1
            }
        } else {
            tableView.restore()
        }

        return restaurants.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !self.showMoreProgress {
            let cell = tableView.dequeueReusableCell(withIdentifier: "restCell")

            cell?.textLabel?.text = self.restaurants[indexPath.row].restaurant.name ?? "No title"
            cell?.detailTextLabel?.text = self.restaurants[indexPath.row].restaurant.location.address ?? "No title"

            return cell!
        }else{
            
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell")!
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = R.storyboard.home.restaurantDetailViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension HomeTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func configSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        
        searchController.searchBar.scopeButtonTitles = ["All", "Single", "Married"]
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("UPDATE====")
//        let searchBar = searchController.searchBar
//        self.loadData(query: searchBar.text)
    }
    
}
