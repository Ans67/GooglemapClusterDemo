//
//  MapModel.swift
//  MapDemo
//
//  Created by ANAS MANSURI on 05/12/21.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class POIItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var name: String!

  init(position: CLLocationCoordinate2D, name: String) {
    self.position = position
    self.name = name
  }
}
