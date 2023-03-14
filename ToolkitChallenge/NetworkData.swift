//
//  NetworkData.swift
//  ToolkitChallenge
//
//  Created by Julio Reyes on 3/12/23.
//

import Foundation
import Combine
import MapKit

fileprivate func newJSONDecoder() -> JSONDecoder {
   let decoder = JSONDecoder()
   if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
      decoder.dateDecodingStrategy = .iso8601
   }
   return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
   let encoder = JSONEncoder()
   if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
      encoder.dateEncodingStrategy = .iso8601
   }
   return encoder
}

class NetworkData: NSObject, ObservableObject, CLLocationManagerDelegate {

   @Published var annotations: [MKPointAnnotation] = []

   override init() {
      super.init()
   }
   
   static func fetchMapData(latitude: Double, longitude: Double, zoom: Double, type: String) -> AnyPublisher<UIImage?, Error> {

      // Create a URL object from the URLComponents object
      let url = URL(string: "https://maps.aerisapi.com/\(Constants.clientID)_\(Constants.clientKey)/\(type)/\(String(zoom))/\(String(latitude))/\(String(longitude))/current.png")
      //let url = URL(string: "https://maps2.aerisapi.com/DAbiMTarY8wNNoKMNfaz8_w0ss3eaeLRRkeVrd2H067P2DV3H7aG4kQLR1gUm7/radar/12/41/23/current.png")
      
      // Create a URLSession object
      let session = URLSession.shared
      
      //print(url!.absoluteString)
      // Create a publisher that retrieves the data from the URL
      return session.dataTaskPublisher(for: url!)
         .tryMap { data, response in
            guard let image = UIImage(data: data) else {
               throw URLError(.badServerResponse)
            }
            return image
         }
         .mapError { error in
            return error
         }
         .eraseToAnyPublisher() // Erase the publisher's type to AnyPublisher, so it can be used in a more general context
   }
   
   static func fetchStormReports(latitude: Double, longitude: Double) -> AnyPublisher<StormReportAnnotation, Error>  {

      guard let url = URL(string: "https://api.aerisapi.com/stormreports/\(latitude),\(longitude)?format=geojson&from=2022/05/01&limit=10&client_id=\(Constants.clientID)&client_secret=\(Constants.clientKey)") else {
          fatalError("Invalid URL")
      }

//      guard let url = URL(string: "https://api.aerisapi.com/stormreports/minneapolis,mn?format=geojson&from=2022/08/01&limit=20&filter=&fields=&client_id=DAbiMTarY8wNNoKMNfaz8&client_secret=w0ss3eaeLRRkeVrd2H067P2DV3H7aG4kQLR1gUm7") else {
//          fatalError("Invalid URL")
//      }
      
      // Create a URLSession object
      let session = URLSession.shared
      
      return session.dataTaskPublisher(for: url)
         .map { $0.data }
         .decode(type: StormReportAnnotation.self, decoder: JSONDecoder())
         .eraseToAnyPublisher()
   }
}



struct Annotation: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let title: String
    let subtitle: String
}

extension Annotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
   
    var mkAnnotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        return annotation
    }
}
