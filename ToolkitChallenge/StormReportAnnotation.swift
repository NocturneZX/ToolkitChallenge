//
//  StormReportAnnotation.swift
//  ToolkitChallenge
//
//  Created by Julio Reyes on 3/13/23.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - StormReportAnnotation
// StormReportAnnotation.swift

// MARK: - StormReportAnnotation
struct StormReportAnnotation: Codable {
    struct Geometry: Codable {
        let type: String?
        let coordinates: [Double]?
    }

    struct Detail: Codable {
        let text: String?
        let snowIN: Double?
        let snowCM: Double?
    }

    struct Report: Codable {
        let timestamp: Int?
        let dateTimeISO: String?
        let code: String?
        let type: String?
        let cat: String?
        let name: String?
        let detail: Detail?
        let reporter: String?
        let wfo: String?
        let comments: String?
        let datetime: String?
    }

    struct Place: Codable {
        let name: String?
        let state: String?
        let county: String?
        let country: String?
    }

    struct Profile: Codable {
        let tz: String?
    }

    struct RelativeTo: Codable {
        let lat: Double?
        let long: Double?
        let bearing: Int?
        let bearingENG: String?
        let distanceKM: Double?
        let distanceMI: Double?
    }

    let type: String?
    let features: [Feature]?

    struct Feature: Codable {
        let type: String?
        let id: String?
        let geometry: Geometry?
        let properties: Properties?

        struct Properties: Codable {
            let id: String?
            let loc: Geometry?
            let report: Report?
            let place: Place?
            let profile: Profile?
            let relativeTo: RelativeTo?

            private enum CodingKeys: String, CodingKey {
                case id
                case loc = "loc"
                case report = "report"
                case place = "place"
                case profile = "profile"
                case relativeTo = "relativeTo"
            }
        }
    }
}
