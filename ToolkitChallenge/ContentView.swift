//
//  ContentView.swift
//  ToolkitChallenge
//
//  Created by Julio Reyes on 3/9/23.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

import SwiftLocation
import UTMConversion

struct ContentView: View {
    @ObservedObject var viewModel = MapViewViewModel()
    @StateObject var networkData = NetworkData()
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3320, longitude: -122.0312), span: MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0))
    @StateObject var locationManager = LocationManager()
    @State var mapTileType = MapTileType.radar
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $region.center, location: $locationManager.location, mapTile: viewModel.mapTile, annotations: viewModel.annotations, span: region.span)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Picker("Tile Type", selection: $mapTileType) {
                    Text("Radar").tag(MapTileType.radar)
                    Text("Alerts").tag(MapTileType.alerts)
                }
                .onChange(of: mapTileType, perform: { value in // The map tiles will change and fetch data again
                    let mapPoint = MKMapPoint(locationManager.location!.coordinate)
                    viewModel.fetchMapData(latitude: mapPoint.x, longitude: mapPoint.y, zoom: 5, type: mapTileType.rawValue)
                    viewModel.fetchStormReports(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
            .onAppear {
                locationManager.start() // Starts to check user location
            }
            .onReceive(locationManager.$location) { location in
                guard let location = location else { return }
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0))

                // Fetch the map times and storm reports once the location is defined
                viewModel.fetchMapData(latitude: 41, longitude: 23, zoom: 8, type: mapTileType.rawValue)
                viewModel.fetchStormReports(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
        .padding()
    }
}
