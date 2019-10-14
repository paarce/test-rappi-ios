//
//  RestaurantDetailViewController.swift
//  Placed-Rest Rappi
//
//  Created by Augusto C.P. on 10/13/19.
//  Copyright © 2019 Augusto C.P. All rights reserved.
//

import UIKit
import Lightbox

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriotionLabel: UILabel!
    @IBOutlet weak var addressValueLabel: UILabel!
    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var countVoteLabel: UILabel!
    
    var data : RestaurantModel?
    var controllerImagesViewer : LightboxController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.configPhotosViwer()
    }
    

     @IBAction func onShowPhotos(_ sender: Any) {
        if let _ = controllerImagesViewer {
            present(controllerImagesViewer!, animated: true, completion: nil)
        }
     }
    
    func initUI() {
        
        if let data = self.data {
            let rest = data.restaurant
            
            self.nameLabel.text = rest.name
            self.descriotionLabel.text = rest.cuisines
            
            if let address = rest.location?.address, let city = rest.location?.city {
                self.addressValueLabel.text = "\(address ) \(rest.location!.zipcode ?? ""). \(city)."
            }else {
                self.addressValueLabel.text = "No address available"
            }
            
            if let user_rating = rest.user_rating {
                self.ratingNumberLabel.text = user_rating.aggregate_rating as? String
                self.ratingNumberLabel.backgroundColor = hexStringToUIColor(hex: "#\(user_rating.rating_color!)")
                self.countVoteLabel.text = "\(user_rating.votes ?? "0") votes counted"
            }
            
        }
    }
    
    private func configPhotosViwer(){
        
        if let _ = self.data {
            
            let images = self.data!.restaurant.photos?.compactMap { LightboxImage(imageURL: URL(string: $0.photo.url!)!, text : $0.photo.caption ?? "" ) }
            
            if let images = images {
                self.controllerImagesViewer = LightboxController(images: images)
                self.controllerImagesViewer!.pageDelegate = self
                self.controllerImagesViewer!.dismissalDelegate = self
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension RestaurantDetailViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        print()
    }
    
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}
