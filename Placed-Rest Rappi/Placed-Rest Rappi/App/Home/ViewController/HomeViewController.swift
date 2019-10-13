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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuTabBarView: NavigationTabBar!{
        didSet{
            let color = UIColor.init(red: 146/255, green: 126/255, blue: 71/255, alpha: 1)
            let colorText = UIColor.gray
            menuTabBarView.setButtonTitles(buttonTitles: ["Maps","List"])
            menuTabBarView.backgroundColor     = .clear
            menuTabBarView.selectorViewColor   = color
            menuTabBarView.selectorTextColor   = colorText
        }
    }
    
    var homeVM = HomeViewModel()
    
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.configSearchBar()
        
        centerMapOnLocation(location: self.homeVM.searchLocation)
        
        mapView.delegate = self
        mapView.register(RestaurantPinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.loadInitialData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // MARK: - CLLocationManager
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
            
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: - Helper methods
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: homeVM.regionRadius, longitudinalMeters: homeVM.regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialData() {
        homeVM.callSearchObservable{ result in
            switch result{
                case .success(let model):
                    if let restaurants = model.restaurants {
                        let pins = restaurants.compactMap { RestaurantPin(data: $0) }
                        self.mapView.addAnnotations(pins)
                    }
                break

                case .failure(let errorT):
                    print(errorT.get().message)
                break
            }
        }
    }
    
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let pin = view.annotation as! RestaurantPin
        
        let vc = R.storyboard.home.restaurantDetailViewController()
        vc!.data = pin.data
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"")
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .infoDark)
            annotationView.leftCalloutAccessoryView = btn
            return annotationView
        }
    }
    
}


extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
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
