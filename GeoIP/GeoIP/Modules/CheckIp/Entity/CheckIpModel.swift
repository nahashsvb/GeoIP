//
//  CheckIpModel.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation
import ObjectMapper

class CheckIpModel: Mappable {
    
    internal var status:         String?
    internal var country:        String?
    internal var countryCode:    String?
    internal var region:         String?
    internal var regionName:     String?
    internal var city:           String?
    internal var zip:            String?
    internal var lat:            Double?
    internal var lon:            Double?
    internal var timezone:       String?
    internal var isp:            String?
    internal var org:            String?
    internal var asString:       String?
    internal var query:          String?
    internal var errorMessage:   String?
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map:Map){
       status      <- map["status"]
       country     <- map["country"]
       countryCode <- map["countryCode"]
       region      <- map["region"]
       regionName  <- map["regionName"]
       city        <- map["city"]
       zip         <- map["zip"]
       lat         <- map["lat"]
       lon         <- map["lon"]
       timezone    <- map["timezone"]
       isp         <- map["isp"]
       org         <- map["org"]
       asString    <- map["as"]
       query       <- map["query"]
       errorMessage <- map["message"]
    }
    
    func arrayRepresentation() -> Array<Dictionary<String, String>> {
        var array: Array<Dictionary<String, String>> = Array()
        
        array.append(["Query:" : query ?? "N/A"])
        array.append(["Status:" : status ?? "N/A"])
        array.append(["Country:" : country ?? "N/A"])
        array.append(["Country Code:" : countryCode ?? "N/A"])
        array.append(["Region:" : region ?? "N/A"])
        array.append(["Region Name:" : regionName ?? "N/A"])
        array.append(["City:" : city ?? "N/A"])
        
        if let lattitude = lat {
            array.append(["Lat:" : String(lattitude)])
        }
        
        if let longitude = lon {
            array.append(["Lon:" : String(longitude)])
        }
        
        array.append(["Zip:" : zip ?? "N/A"])
        array.append(["Timezone:" : timezone ?? "N/A"])
        array.append(["ORG:" : org ?? "N/A"])
        array.append(["AS:" : asString ?? "N/A"])
        array.append(["ISP:" : isp ?? "N/A"])
     
        return array
    }
}
