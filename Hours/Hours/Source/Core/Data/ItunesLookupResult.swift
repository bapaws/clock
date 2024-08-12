//
//  ItunesLookupResult.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/7.
//

import Foundation

// MARK: - Result
struct ItunesLookupResult: Codable {
    let isGameCenterEnabled: Bool?
    let screenshotUrls, ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl512: String?
    let supportedDevices, advisories: [String]?
    let artistViewURL: String?
    let artworkUrl60, artworkUrl100: String?
    let features: [String]?
    let kind: String?
    let releaseDate, currentVersionReleaseDate: Date?
    let languageCodesISO2A: [String]?
    let averageUserRatingForCurrentVersion: Double?
    let fileSizeBytes, formattedPrice: String?
    let userRatingCountForCurrentVersion: Int?
    let trackContentRating: String?
    let averageUserRating: Double?
    let artistID: Int?
    let artistName: String?
    let genres: [String]?
    let price: Int?
    let description, bundleID, sellerName: String?
    let trackID: Int?
    let trackName: String?
    let genreIDS: [String]?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let primaryGenreName: String?
    let primaryGenreID: Int?
    let trackCensoredName: String?
    let trackViewURL: String?
    let contentAdvisoryRating, minimumOSVersion, releaseNotes, currency: String?
    let version, wrapperType: String?
    let userRatingCount: Int?

    enum CodingKeys: String, CodingKey {
        case isGameCenterEnabled, screenshotUrls, ipadScreenshotUrls, appletvScreenshotUrls, artworkUrl512, supportedDevices, advisories
        case artistViewURL = "artistViewUrl"
        case artworkUrl60, artworkUrl100, features, kind, releaseDate, currentVersionReleaseDate, languageCodesISO2A, averageUserRatingForCurrentVersion, fileSizeBytes, formattedPrice, userRatingCountForCurrentVersion, trackContentRating, averageUserRating
        case artistID = "artistId"
        case artistName, genres, price, description
        case bundleID = "bundleId"
        case sellerName
        case trackID = "trackId"
        case trackName
        case genreIDS = "genreIds"
        case isVppDeviceBasedLicensingEnabled, primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case trackCensoredName
        case trackViewURL = "trackViewUrl"
        case contentAdvisoryRating
        case minimumOSVersion = "minimumOsVersion"
        case releaseNotes, currency, version, wrapperType, userRatingCount
    }
}
