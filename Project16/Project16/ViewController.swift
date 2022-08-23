//
//  ViewController.swift
//  Project16
//
//  Created by Gökhan on 22.08.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        mapView.mapType = .satellite
        mapView.addAnnotations([london, oslo, paris, rome, washington])

    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose map type:", message: nil, preferredStyle: .actionSheet)
    
        ac.addAction(UIAlertAction(title: "standart", style: .default) { [weak ac, weak self] _ in
            self?.mapView.mapType = .standard
            self?.mapTypeButton.setTitle("standart", for: .normal)
        })
        ac.addAction(UIAlertAction(title: "satellite", style: .default) { [weak ac, weak self] _ in
            self?.mapView.mapType = .satellite
            self?.mapTypeButton.setTitle("satellite", for: .normal)
        })
        ac.addAction(UIAlertAction(title: "hybrid", style: .default) { [weak ac, weak self] _ in
            self?.mapView.mapType = .hybrid
            self?.mapTypeButton.setTitle("hybrid", for: .normal)
        })
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //any annotation other than ours (from apple services etc.) will return nill
        guard annotation is Capital else { return nil }
        //reuse identifier
        let identifier = "Capital"
        //dequeue annotation view from unused views
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.canShowCallout = true
        annotationView.pinTintColor = UIColor.yellow
        let btn = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = btn
       
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

