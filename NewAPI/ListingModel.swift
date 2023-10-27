//
//  ListingModel.swift
//  NewAPI
//
//  Created by Alex Beattie on 10/3/23.
//

import Foundation
//extension Listing: Equatable {
//    static func == (lhs: Listing, rhs: Listing) -> Bool {
//        return
//            lhs.odataCount == rhs.odataCount &&
//            lhs.odataNextLink == rhs.odataNextLink &&
//            lhs.odataContext == rhs.odataContext
//    }
//}
extension Listing: Equatable {}

struct Listing: Codable {
//    static func == (lhs: Listing, rhs: Listing) -> Bool {
//        return lhs.odataCount == rhs.odataCount
//    }
//    
//    var id = UUID()
    
//    var id: UUID()
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    static func == (lhs: Listing, rhs: Listing) -> Bool {
//        return lhs.odataCount == rhs.odataCount
//
//    }
//    
    
    let odataContext: String?
    let odataNextLink: String?
    let odataCount: Int?
    let value: [Value]?
    
    enum CodingKeys: String, CodingKey {
           case odataContext = "@odata.context"
           case odataNextLink = "@odata.nextLink"
           case odataCount = "@odata.count"
           case value = "value"
       }
}
extension Value: Equatable {}

struct Value: Codable {
    static func == (lhs: Value, rhs: Value) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String { return self.ListingKey ?? "" }
    var BuyerAgentEmail: String?
    var ClosePrice: Int?
    var CoListAgentFullName: String?
    var ListAgentFullName: String?
    var Latitude: Double?
    var Longitude: Double?
    var ListPrice: Int?
    var BedroomsTotal: Int?
    var LotSizeAcres: Double?
    var MlsStatus: String?
    var OffMarketDate: String?
    var OnMarketDate: String?
    var PendingTimestamp: String?
    var Media: [Media]?
    var ListingKey: String?
    var UnparsedAddress: String?
    var PostalCode: String?
    var StateOrProvince: String?
    var City: String?
    var BathroomsTotalInteger: Int?
    var Model: String?
    var BuyerOfficeAOR: String?
    var VirtualTourURLUnbranded: String?
    var PublicRemarks: String?
    var BuyerAgentURL: String?
    var ListAgentURL: String?
    var BuildingAreaTotal: Int?
    var BuilderName: String?
    var BuyerAgentMlsId: String?
    var BuyerOfficePhone: String?
    var CloseDate: String?
    var ListingContractDate: Date?
    var ListingId: String?
    var LivingArea: Int?
    var formattedLaunchDate: String {
        ListingContractDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
    struct Media: Codable {
//        var id = UUID()
//        var id: String { return self.MediaCategory ?? "" }

        var MediaCategory: String?
        var MediaURL: String?
        var MediaKey: String?
        
        enum CodingKeys: String, CodingKey {
            case MediaCategory = "MediaCategory"
//                case Permission = "Permission"
//                case LongDescription = "LongDescription"
//                case Order = "Order"
//                case PreferredPhotoYN = "PreferredPhotoYN"
//                case ShortDescription = "ShortDescription"
            case MediaURL = "MediaURL"
//                case MediaHTML = "MediaHTML"
//                case OriginatingSystemMediaKey = "OriginatingSystemMediaKey"
            case MediaKey = "MediaKey"
//                case ResourceRecordID = "ResourceRecordID"
//                case ResourceRecordKey = "ResourceRecordKey"
//                case odataId = "@odata.id"
            
            
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.MediaCategory = try? container.decode(String.self, forKey: .MediaCategory)
            self.MediaURL = try? container.decode(String.self, forKey: .MediaURL)
            self.MediaKey = try? container.decode(String.self, forKey: .MediaKey)
        }

    }
   
}


