//
//  MapViewViewModel.swift
//  ToolkitChallenge
//
//  Created by Julio Reyes on 3/12/23.
// carthage update --use-xcframeworks

import Foundation
import Combine
import UIKit
import MapKit

class MapViewViewModel: ObservableObject {
    
    @Published var annotations: [MKPointAnnotation] = []
    @Published var mapTile: UIImage?
    private var cancellables = Set<AnyCancellable>()

    func fetchMapData(latitude: Double, longitude: Double, zoom: Double, type: String) {
        let publisher = NetworkData.fetchMapData(latitude: latitude, longitude: longitude, zoom: zoom, type: type)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error downloading image: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }  receiveValue: { [weak self] image in
                self?.mapTile = image
            }
            .store(in: &cancellables)
    }
    
    func fetchStormReports(latitude: Double, longitude: Double) {
        let publisher = NetworkData.fetchStormReports(latitude: latitude, longitude: longitude)
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching storm reports: \(error.localizedDescription)")
                case .finished:
                    print("Completed fetching storm reports")
                }
            }, receiveValue: { stormReportAnnotation in
                //print("Received storm report annotation: \(stormReportAnnotation)")
                // Do something with the received data
                if let features = stormReportAnnotation.features {
                    for feature in features {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: (feature.geometry?.coordinates![1])!, longitude:  (feature.geometry?.coordinates![0])!)
                        annotation.title = feature.properties?.report?.name
                        annotation.subtitle = feature.properties?.report?.comments
                        self.annotations.append(annotation)
                    }
                } else {
                    print("Error fetching storm reports: Max daily access is reached.")
                }
            })
            .store(in: &cancellables)
        
        print(annotations.count)
    }
}
