//
//  ContentView.swift
//  NewAPI
//
//  Created by Alex Beattie on 9/20/23.
//

import SwiftUI
import Combine
import AVKit

struct Listing: Codable {
    
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


struct Value: Codable {
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
    var ListingContractDate: String?
    var ListingId: String?
    var LivingArea: Int?
    
}
struct Media: Codable {
    var MediaCategory: String?
    var MediaURL: String?
}

func loadData() async {
//    async let (listingData, _) = URLSession.shared.data(from: URL(string: "http://lireadgroup.com/sparkData.json")!)
//
////    async let (messageData, _) = URLSession.shared.data(from: URL(string: "https://hws.dev/user-messages.json")!)
//
////    do {
////        let decoder = JSONDecoder()
//////        let user = try await decoder.decode(User.self, from: userData)
////        let listings = try await decoder.decode(Listing.self, from: listingData)
////        print("There are \(listings.value.count) listing(s).")
////    } catch {
////        print("Sorry, there was a network problem.")
////    }
}
//func fetchReadings() async {
//    let fetchTask = Task { () -> String in
//        let url = URL(string: "http://lireadgroup.com/sparkData.json")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let readings = try JSONDecoder().decode(Value.self, from: data)
//        print(readings)
//        return "Found \(readings.CoListAgentFirstName) readings"
//    }
//    let result = await fetchTask.result
//
//}
@MainActor
class ListingPublisherViewModel: ObservableObject {
    
    @Published var results = [Value]()
    @Published var listings = [Listing]()
    
    
    func fetchProducts() async {
        

        //create the new url
        let url = URL(string: "https://replication.sparkapi.com/Reso/OData/Property?$filter=(ListPrice ge 1000000) and (MlsStatus eq 'Active')&$orderby=ListPrice desc&$expand=Media&$skip=10&$count=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        //create a new urlRequest passing the url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(TOKEN)", forHTTPHeaderField: "Authorization")
        do {
            
            //run the request and retrieve both the data and the response of the call
            let (data, _) = try await URLSession.shared.data(for: request)
            
            //checks if there are errors regarding the HTTP status code and decodes using the passed struct
            if let fetchedData = try? JSONDecoder().decode(Listing.self, from: data) {
//                print(fetchedData)
                self.results = fetchedData.value ?? []
                self.listings = [fetchedData]
                print(listings)
            }
        } catch {
            print("invalid data")
        }
    }
}

//    init() {
//        //ALL MY LISTINGS Closed / Pending / Sold / Active
//        var request = URLRequest(url: URL(string: "https://replication.sparkapi.com/Reso/OData/Property?%24filter=(ListPrice%20ge%201000000)%20and%20(MlsStatus%20eq%20%27Active%27)&%24orderby=ListPrice%20desc&%24expand=Media&%24skip=10&%24count=true")!,timeoutInterval: Double.infinity)
//
//        request.addValue("Bearer 783gnjjn82x92n9lbvpr1r0c1", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { (data, url, error) in
//
//                guard let data = data else { return }
//                do  {
//                    let decodedResponse = try JSONDecoder().decode(Listing.self, from: data)
//                    print(decodedResponse)
//                    DispatchQueue.main.async {
//                        self.results = decodedResponse.value ?? []
//
//                    }
//
//                } catch {
//                    print("Failed to decode \(error)")
//
//                }
//
//        }.resume()
//
//    }

    
    
//    func loadData() async {
//        guard let url = URL(string: "http://lireadgroup.com/sparkDataTwo.json") else {
//            print("Invalid URL")
//            return
//        }
//
//
//
//
//
//
//
//
//        do {
//
//
//            let (data, _) = try await URLSession.shared.data(from: url)
//            print(data)
//            if let decodedResponse = try? JSONDecoder().decode(Listing.self, from: data) {
////                DispatchQueue.main.async {
//                self.results = decodedResponse.value
//
//            }
//            print(results)
//            // more code to come
//
//        } catch {
//            print("Invalid data")
//        }
//
//    }
//    init()  {
//        Task {
//            await loadData()
//
//
//            print("There are \(value.count) here TOO")
//            print("There are \(String(describing: value.first)) here listing TOO")
////            guard let url = URL(string: "http://lireadgroup.com/sparkData.json") else { return }
//
////            let url = URL(string: "http://lireadgroup.com/sparkData.json")!
////            let request = URLRequest(url: url)
////            let (data, _) = try await URLSession.shared.data(for: request)
//
//    //          let decoder = JSONDecoder()
//    //          let formatter = DateFormatter()
//    //          formatter.dateFormat = "y-MM-dd"
//    //          decoder.dateDecodingStrategy = .formatted(formatter)
//
////            do {
////                let (data, _) = try await URLSession.shared.data(from: url)
//////                print(data)
////                if let decodedResponse = try? JSONDecoder().decode(Listing.self, from: data) {
////                    value = decodedResponse.value
////                }
//////                print(value)
////                // more code to come
////            } catch {
////                print("Invalid data")
////            }
//
////            let listing = try JSONDecoder().decode(Listing.self, from: data)
////              print(listing)
////              return listing
//
//        }
//    }
   


struct ContentView: View {
    
    @StateObject var vm = ListingPublisherViewModel()

    let listing: Value
    let topListing: Listing

 
    var body: some View {


        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
            ScrollView {
          
                ForEach(vm.results, id: \.ListingKey)  { listing  in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: listing.Media?.first?.MediaURL ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width:400, height:200)
                                .clipped()
                            
                        } placeholder: {
                            ProgressView()
                        }
//                        Text(listing.ListingId ?? "")
                        ZStack {
                            VStack (alignment: .leading, spacing: 12) {
                                
                                HStack {
                                    VStack{
                                        Text(listing.UnparsedAddress ?? "")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color(.white))
                                        HStack {
//                                            Text("\(listing.Model ?? "Not Named")")
//                                                .font(.system(size: 14, weight: .regular))
//                                                .foregroundColor(Color(.gray))
                                            Text(listing.MlsStatus ?? "")
                                                .font(.system(size: 14, weight: .heavy))
                                                .foregroundColor(Color(.white))
                                            Text("\(listing.BuyerOfficeAOR ?? "")")
                                                .font(.system(size: 12, weight: .heavy))
                                        }
                                        
                                        HStack {

                                                      
                                            Text("$")
//                                            Text(String(listing.ListPrice)).formatted(.currency(code: "USD"))
//                                            Label(String(listing.ListPrice ?? 0), systemImage: "house")
                                            Text(Date.now.addingTimeInterval(600), style: .time)
                                            
                                            //.redacted(reason: .placeholder)
                                            
                                            Text(String(listing.ListPrice ?? 0))
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(Color(.gray))
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                }
                //TODO
                //Show next page of listings
                ForEach(vm.listings, id: \.odataContext) { topListing in
                    Link ("next", destination: URL(string: topListing.odataNextLink!)!)
                }
            }
        }

          
        }
        .task {
            await vm.fetchProducts()
        }
        .background(.darkBackground)
        .navigationTitle(topListing.odataNextLink ?? "")
        .navigationBarTitleDisplayMode(.inline)

    }

}



struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentView(listing: Value(CoListAgentFullName: "Alex", ListAgentFullName: "Beattie", MlsStatus: "Open", Media: [], ListingKey: "1221", UnparsedAddress: "123 Anywhere Usa", PostalCode: "91221", StateOrProvince: "CA", City: "Thousand Oaks", BathroomsTotalInteger: 0, BuilderName: "Sherwood", BuyerAgentMlsId: "123",BuyerOfficePhone: "1",CloseDate: "99", ListingContractDate: "22",LivingArea: 123), topListing: Listing(odataContext: "alex", odataNextLink: "alex", odataCount: 0, value: [Value].init()))

            .preferredColorScheme(.dark)
    }
}
