//
//  APOD.swift
//  URLSessions
//
//  Created by igor s on 03.09.2022.
//

import Foundation

enum nasaLink: String {
    case apodURL = "https://api.nasa.gov/planetary/apod?api_key=MR1H9Qy8R4s3D1DQhd6h5CvM8WDhfjebftt8CHlv&start_date=2022-08-28"
    case apodURLMain = "https://api.nasa.gov/planetary/apod"
    case apodURL1 = "https://api.nasa.gov/planetary/apod?api_key=MR1H9Qy8R4s3D1DQhd6h5CvM8WDhfjebftt8CHlv"
}

struct APOD: Codable {
    let date: String
    let explanation: String
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    let hdurl: String?
    
    init(apodData: [String: Any]) {
        date = apodData["date"] as? String ?? ""
        explanation = apodData["explanation"] as? String ?? ""
        mediaType = apodData["media_type"] as? String ?? ""
        serviceVersion = apodData["service_version"] as? String ?? ""
        title = apodData["title"] as? String ?? ""
        url = apodData["url"] as? String ?? ""
        hdurl = apodData["hdurl"] as? String
    }
    
    static func getApods(from value: Any) -> [APOD] {
        guard let apodData = value as? [[String: Any]] else { return [] }
//        var apods: [APOD] = []
//        for value in apodData {
//            let apod = APOD(apodData: value)
//            apods.append(apod)
//        }
//        return apods
        return apodData.compactMap { APOD(apodData: $0) }
    }
}

struct APOD2: Codable {
    let date: String
    let explanation: String
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    let hdurl: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case explanation = "explanation"
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title = "title"
        case url = "url"
        case hdurl = "hdurl"
    }
}

