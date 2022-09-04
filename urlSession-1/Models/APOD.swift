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
}

struct APOD: Decodable {
    let date: String
    let explanation: String
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    let hdurl: String?
}

