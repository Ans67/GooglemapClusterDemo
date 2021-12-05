//
//  ViewController.swift
//  MapDemo
//
//  Created by ANAS MANSURI on 27/06/2021.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils


class ViewController: UIViewController , GMUClusterManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var clusterManager: GMUClusterManager!
    
    // main varible for all location
    var locationdata = [LocationData]()
    
    // filter location as here it is Dubai needed
    var filetrdata = [LocationData]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGoogleMap()
        
        callApi()
    }
    
    func setupGoogleMap(){
        //mapView.camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 8)
        mapView.delegate = self
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    }

    // MARK: - HTTP HEADER
    func headerforwebservice() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        return headers
    }
    
    
    //MARK:- API Call
    func callApi(){
        let url = "https://myscrap.com/api/msDiscoverPage"
        
        let data : Data = "searchText=\("")&apiKey=501edc9e".data(using: .utf8, allowLossyConversion: false)!

        NetworkManger.sharedInstance.sendRequest(for: DataModel.self, url: url, method: .post, headers: headerforwebservice(), body: data) { (response) in
            
            switch response{
            
            case .success(let responsedata):
                self.locationdata.removeAll()
                self.locationdata = responsedata.locationData ?? []
                
                //filter data for dubai only
                self.filetrdata = self.locationdata.filter{$0.state == "Dubai"}
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if self.locationdata.count > 0{
                        self.setupGoogleMap(locationArray: self.filetrdata)
                    }
                }
                
            case .failure(let error):
                
                print(error)
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
        }
        
    }
    
    func setupGoogleMap(locationArray:[LocationData]){
        for index in 1...filetrdata.count - 1{
            
            let locationObject = filetrdata[index]
            if let lattitude = Double(locationObject.latitude ?? ""), let longitude = Double(locationObject.longitude ?? ""){
                
                initilizeGoogleMaps(latitude: lattitude, longitude: longitude)
                
                // Generate and add random items to the cluster manager.
                generateClusterItems()

                // Call cluster() after items have been added to perform the clustering and rendering on map.
                clusterManager.cluster()
        
                // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
                clusterManager.setDelegate(self, mapDelegate: self)
                
                mapView.delegate = self

            }
            
        }
    }
    
    
    func initilizeGoogleMaps(latitude: Double, longitude: Double) {
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: 3)
        self.mapView.delegate = self
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        let city = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: 3)
        self.mapView.animate(to: city)
        self.mapView.setMinZoom(0, maxZoom: 30)
        CATransaction.commit()
    }
    
    private func generateClusterItems() {
      let extent = 0.2
  
      if filetrdata.count > 0{
        for index in 1...filetrdata.count - 1{
              let locationObject = filetrdata[index]
              
              if let lattitude = Double(locationObject.latitude ?? ""), let longitude = Double(locationObject.longitude ?? ""){
                  let lat = lattitude + extent * randomScale()
                  let lng = longitude + extent * randomScale()
                  let name = "Item \(index)"
                  let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
                    clusterManager.add(item)
                  
              }
          }
      }

    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
      return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    
    // MARK: - GMUClusterManagerDelegate
    private func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) {
          let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
        zoom: mapView.camera.zoom + 1)
      let update = GMSCameraUpdate.setCamera(newCamera)
      mapView.moveCamera(update)
    }

    private func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) {
          
          let item = clusterItem.position
          print(item)
          
      }
    
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped at location: (%lf, %lf) \(coordinate.latitude) \(coordinate.longitude)")
    }
    

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      
        if let poiItem = marker.userData as? POIItem {
            
            for index in 1...filetrdata.count - 1 {
                let locationObject = locationdata[index]
                
                let marker = GMSMarker(position: marker.position)
                marker.title = locationObject.name
                marker.map = mapView
                marker.map?.backgroundColor = .red
                NSLog("Did tap marker for cluster item \(String(describing: poiItem.name))")
            }
        
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
        
    }
    
    
}
