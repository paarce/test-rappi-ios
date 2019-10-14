//
//  HomeViewController.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/12/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var navigationTabBar: NavigationTabBar!{
        didSet{
            let color = UIColor.init(red: 146/255, green: 126/255, blue: 71/255, alpha: 1)
            let colorText = UIColor.gray
            navigationTabBar.setButtonTitles(buttonTitles: ["Maps","List"])
            navigationTabBar.backgroundColor     = .clear
            navigationTabBar.selectorViewColor   = color
            navigationTabBar.selectorTextColor   = colorText
        }
    }
    
    @IBOutlet weak var mapRestaurantView: MapRestaurantView!
    @IBOutlet weak var listRestaurantView: ListRestaurantView!
    
    var homeVM = HomeViewModel()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.configSearchBar()
        self.navigationTabBar.delegate = self
        self.mapRestaurantView.iniUI(location: self.homeVM.searchLocation, regionRadius: self.homeVM.regionRadius, parent: self)
        self.listRestaurantView.iniUI(parent: self)
        
        
        self.loadInitialData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapRestaurantView.checkLocationAuthorizationStatus()
    }
    
    
    // MARK: - Helper methods
    
    func loadInitialData() {
        homeVM.callSearchObservable{ result in
            switch result{
                case .success(let model):
                    if let restaurants = model.restaurants {
                        let pins = restaurants.compactMap { RestaurantPin(data: $0) }
                        self.mapRestaurantView.mapView?.addAnnotations(pins)
                        self.listRestaurantView.restaurants = restaurants
                    }
                break

                case .failure(let errorT):
                    print(errorT.get().message)
                break
            }
        }
    }
    
    func showDetailof( restaurant : RestaurantModel) {
        
        if let vc = R.storyboard.home.restaurantDetailViewController() {
            vc.data = restaurant
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeViewController: NavigationTabBarDelegate {

    func changeToIndex(index: Int) {
        switch index {
        case 0:
            self.view.bringSubviewToFront(self.mapRestaurantView)
        case 1:
            self.view.bringSubviewToFront(self.listRestaurantView)
        default:
            break
        }
    }
    
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func configSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restaurants"
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
