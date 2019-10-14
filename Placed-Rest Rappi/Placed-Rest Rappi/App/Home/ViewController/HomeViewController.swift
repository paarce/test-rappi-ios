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
    
    private var homeVM = HomeViewModel()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.configSearchBar()
        self.navigationTabBar.delegate = self
        self.mapRestaurantView.iniUI(parent: self)
        self.listRestaurantView.iniUI(parent: self)
        
        
        //self.loadInitialData()
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
                    self.fillViews(searchModel: model, isInit: true)
                break

                case .failure(let errorT):
                    print(errorT.get().message)
                break
            }
        }
    }
    
    
    func showMoreData() {
        self.homeVM.callSearchNextPageObservable { result in
            switch result{
            case .success(let model):
                self.fillViews(searchModel: model, isInit: false)
                break
                
            case .failure(let errorT):
                print(errorT.get().message)
                break
            }
        }
    }
    
    func initUser( location: CLLocation ) {
        self.homeVM.searchLocation = location
    }
    
    func showDetailof( restaurant : RestaurantModel) {
        
        if let vc = R.storyboard.home.restaurantDetailViewController() {
           self.searchController.isActive = false
            vc.data = restaurant
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    private func fillViews(searchModel : SearchModel, isInit : Bool ){
        
        
        if let restaurants = searchModel.restaurants {
            let pins = restaurants.compactMap { RestaurantPin(data: $0) }
            
            if isInit {
                
                if let annotations = self.mapRestaurantView.mapView?.annotations {
                    self.mapRestaurantView.mapView?.removeAnnotations(annotations)
                }
                self.listRestaurantView.restaurants = restaurants
                
                if restaurants.count > 0 {
                    
                    let loc = restaurants[0].restaurant.location
                    if let lat = loc?.latitude, let log = loc?.longitude, let dLat = CLLocationDegrees(lat), let dLog = CLLocationDegrees(log) {
                        self.mapRestaurantView.centerMapOnLocation(location: CLLocation(latitude: dLat, longitude: dLog ) )
                    }
                }
                
            }else{
                self.listRestaurantView.restaurants += restaurants
                
            }
            
            self.mapRestaurantView.mapView?.addAnnotations(pins)
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
        
        searchController.searchBar.scopeButtonTitles = ["None filter","Cost", "Rating", "Distance"]
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print(selectedScope)
        
        var sortValue = ""
        
        switch selectedScope {
        case 1:
            sortValue = "cost"
        case 2:
            sortValue = "rating"
        case 3:
            sortValue = "real_distance"
        default:
             break
        }
        
        
        self.homeVM.callSearchObservable(sort: sortValue) { result in
            switch result{
            case .success(let model):
                self.fillViews(searchModel: model, isInit: true)
                break
                
            case .failure(let errorT):
                print(errorT.get().message)
                break
            }
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searcBar = searchController.searchBar
        self.homeVM.callSearchObservable(query: searcBar.text) { result in
            switch result{
            case .success(let model):
                self.fillViews(searchModel: model, isInit: true)
                break
                
            case .failure(let errorT):
                print(errorT.get().message)
                break
            }
        }
    }
    
}
