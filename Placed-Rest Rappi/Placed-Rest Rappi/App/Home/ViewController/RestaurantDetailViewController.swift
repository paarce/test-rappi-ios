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

    var data : RestaurantModel?
    var controllerImagesViewer : LightboxController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configPhotosViwer()
    }
    

     @IBAction func onShowPhotos(_ sender: Any) {
        if let _ = controllerImagesViewer {
            present(controllerImagesViewer!, animated: true, completion: nil)
        }
     }
    
    private func configPhotosViwer(){
        
        if let _ = self.data {
            
            let images = self.data!.restaurant.photos.compactMap { LightboxImage(imageURL: URL(string: $0.photo.url!)!, text : $0.photo.caption ?? "" ) }
            
            self.controllerImagesViewer = LightboxController(images: images)
            self.controllerImagesViewer!.pageDelegate = self
            self.controllerImagesViewer!.dismissalDelegate = self
        }
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
