//
//  MapTileOverlay.swift
//  ToolkitChallenge
//
//  Created by Julio Reyes on 3/14/23.
//

import Foundation
import MapKit

class MapTileOverlay: MKTileOverlay {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(urlTemplate: nil)
    }
    
  override func url(forTilePath path: MKTileOverlayPath) -> URL {
    let tileUrl =
        "https://maps.aerisapi.com/\(NetworkData.clientID)_\(NetworkData.clientKey)/radar/\(path.z)/\(path.x)/\(path.y)/current.png"
    return URL(string: tileUrl)!
  }
}
