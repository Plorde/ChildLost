//
//  delegate.swift
//  ChildLost2
//
//  Created by 龙锐 on 2020/2/16.
//  Copyright © 2020 龙锐. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
  // 1
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // 2
    guard let annotation = annotation as? Children else { return nil }
    // 3
    let identifier = "marker"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
      let location = view.annotation as! Children
      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}


extension MKMapView{
    func updateLocation(inlat:Double,inlong:Double){
       
        if let old = self.annotations.first{
            let newAno = Children(title: old.title!!, locationName: old.subtitle!!, discipline: old.description, coordinate: CLLocationCoordinate2D(latitude: inlat, longitude: inlong))
            self.removeAnnotations(self.annotations)
            self.addAnnotation(newAno)
        }
       
    }
}




extension Date{
    var datestring : String{
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: self)
        return date
    }
    
}
