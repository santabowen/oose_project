//
//  Place.swift
//  LetsGo
//
//  Created by lv huizhan on 11/8/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation
import JSONJoy
import GoogleMaps

public class Place : NSObject {
    public var name: String?
    public var placeID: String?
    public var coordinate: CLLocationCoordinate2D?
    public var formattedAddress: String?
    /**
     * Five-star rating for this place based on user reviews.
     *
     * Ratings range from 1.0 to 5.0.  0.0 means we have no rating for this place (e.g. because not
     * enough users have reviewed this place).
     */
     
     // Parsing single place.
    class func parsePlace(decoder: JSONDecoder) -> Place?{
        let place = Place()
        if let formatted_address = decoder["formatted_address"].string{
            place.formattedAddress = formatted_address
        }
        if let lat = decoder["geometry"]["location"]["lat"].double{
            if let lng = decoder["geometry"]["location"]["lng"].double{
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                place.coordinate = coordinate
            }
        }
        if let name = decoder["name"].string{
            place.name = name
        }
        if let placeID = decoder["place_id"].string{
            place.placeID = placeID
        }
        return place
    }
    
    /// Get place list from JSONDecoder
    class func parsePlaceList(decoder: JSONDecoder) -> [Place]{
        var placeArray = [Place]()
        if let allPlaces = decoder["results"].array {
            for onePlace in allPlaces{
                if let p = Place.parsePlace(onePlace){
                    placeArray.append(p)
                }
            }
        }
        return placeArray
    }
    
    func setFromGMSPlace(place: GMSPlace){
        self.name = place.name
        self.placeID = place.placeID
        self.coordinate = place.coordinate
        self.formattedAddress = place.formattedAddress
    }
}
