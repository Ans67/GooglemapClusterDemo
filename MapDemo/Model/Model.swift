//
//  Model.swift
//  MapDemo
//
//  Created by ANAS MANSURI on 27/06/2021.
//

import Foundation

struct DataModel : Codable , Equatable{
    let error : Bool?
    let status : String?
    let locationData : [LocationData]?

    enum CodingKeys: String, CodingKey {

        case error = "error"
        case status = "status"
        case locationData = "locationData"
    }
}

struct LocationData : Codable , Equatable{
    let image : String?
    let id : String?
    let name : String?
    let latitude : String?
    let longitude : String?
    let addressOne : String?
    let addressTwo : String?
    let state : String?
    let avgRating : String?
    let rattingValues : [RattingValues]?
    let totalReview : String?
    let totalRatingCount : String?
    let country : String?
    let userLocation : String?
    let companyType : String?
    let category : String?
    let newJoined : Bool?

    enum CodingKeys: String, CodingKey {

        case image = "image"
        case id = "id"
        case name = "name"
        case latitude = "latitude"
        case longitude = "longitude"
        case addressOne = "addressOne"
        case addressTwo = "addressTwo"
        case state = "state"
        case avgRating = "avgRating"
        case rattingValues = "rattingValues"
        case totalReview = "totalReview"
        case totalRatingCount = "totalRatingCount"
        case country = "country"
        case userLocation = "userLocation"
        case companyType = "companyType"
        case category = "category"
        case newJoined = "newJoined"
    }


}

struct RattingValues : Codable, Equatable {
    let rattingLable : String?
    let rattingValue : String?
    let ratingPercentage : String?

    enum CodingKeys: String, CodingKey {

        case rattingLable = "rattingLable"
        case rattingValue = "rattingValue"
        case ratingPercentage = "ratingPercentage"
    }

}
