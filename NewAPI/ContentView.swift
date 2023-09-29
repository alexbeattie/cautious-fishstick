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

//extension Listing {
//    enum CodingKeys: String, CodingKey {
//        case OdataNextLink = "@odata.nextLink"
//    }
//}
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
//    @MainActor
    @Published var results = [Value]()
    @Published var listings = [Listing]()
    init() {
//        var request = URLRequest(url: URL(string:"https://replication.sparkapi.com/Reso/OData/Property?$filter=ListPrice gt 10000000&$orderby=ListPrice desc&$expand=Media&$skip=10&$top=10&$count=true")!,timeoutInterval: Double.infinity)
        //ALL MY LISTINGS Closed / Pending / Sold / Active
        var request = URLRequest(url: URL(string: "https://replication.sparkapi.com/Reso/OData/Property?%24filter=(ListPrice%20ge%201000000)%20and%20(MlsStatus%20eq%20%27Active%27)&%24orderby=ListPrice%20desc&%24expand=Media&%24skip=10&%24count=true")!,timeoutInterval: Double.infinity)

//        var request = URLRequest(url: URL(string: "https://replication.sparkapi.com/Reso/OData/Property")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer 783gnjjn82x92n9lbvpr1r0c1", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, url, error) in
            
                guard let data = data else { return }
                do  {
                    let decodedResponse = try JSONDecoder().decode(Listing.self, from: data)
                    print(decodedResponse)
                    DispatchQueue.main.async {
                        self.results = decodedResponse.value ?? []
                    }
                    
                } catch {
                    print("Failed to decode \(error)")

                }
            
        }.resume()

    }

    
    
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
   
}

struct ContentView: View {
//    @State var listing: Listing

    @StateObject var vm = ListingPublisherViewModel()
//    var listing = Value
//    @State private var sortOrder = [KeyPathComparator(\(vm.listing.MlsStatus)]
//    @State private var selection: vm.listing.ListingKey
                                                       
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.results, id: \.ListingKey) { listing in

//                    LazyVStack {
//                            VStack {
                                
                                /*      Use Layout Priority of maxHeight: .infinitey
                                 Text(listing.MlsStatus).layoutPriority(1)
                                 */
                    
                                NavigationLink {
                                    PopDestDetailsView(listing: listing)
//                                    AsyncImage(url: URL(string: listing.Media.first?.MediaURL ?? "")) { image in
//                                        image
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width:400, height:200)
//
//                                    } placeholder: {
//                                        ProgressView()
//                                    }
//                                    .frame(width: 400, height: 250)
//                                    Text(listing.PublicRemarks ?? "")
//
//                                    Text(listing.City)
                                    Spacer()
                                } label: {
                                    HomeRow(listing: listing)
                                }
                              
                            }

            }
        }
      
//        .task {
//            await vm.loadData()
//        }
        
        
    }
}

   
struct HomeRow: View {
    let listing:Value
    var body: some View {
        VStack () {
//            AsyncImage(url: URL(string: listing.Media?.first?.MediaURL ?? "")) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width:400, height:200)
//                
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(width: 400, height: 250)

//            KFImage(URL(string:listing.Media.first?.MediaURL ?? ""))
//                .resizable()
//                .scaledToFill()
//                .cornerRadius(6)
//                .frame(width:400, height:200)
//                .clipped()

            RowData(listing: listing)
                

        }
//        .edgesIgnoringSafeArea(.top)

        .padding(.bottom)
        .listStyle(PlainListStyle())
        }
    }
//        ScrollView {
//
//            VStack {
//                Text("alex")
//                Text(viewModel.listings[0])
////                List(viewModel.listings, id: \.value.first?.ListingKey) { item in
//////                    Text($0).font(.headline)
////                    Text("alex")
//////                    Text(item.value.first?.BuyerAgentEmail! ?? "")
//////                        .font(.headline)
////                }
//            }
//        }
//        List(listings, id: \.ListingKey) { item in
//            VStack(alignment: .leading) {
//                Text(item.BuyerAgentEmail ?? "Alex")
//                    .font(.headline)
//            }
//        }
//        .onAppear {
//            Task {
//                try await loadData()
//            }
//        }
        
//    }
      
    

//    func loadData() async throws -> Listing {
//        let url = URL(string: "http://lireadgroup.com/sparkData.json")!
//        let request = URLRequest(url: url)
//        let (data, _) = try await URLSession.shared.data(for: request)
//
////          let decoder = JSONDecoder()
////          let formatter = DateFormatter()
////          formatter.dateFormat = "y-MM-dd"
////          decoder.dateDecodingStrategy = .formatted(formatter)
//
//        let listing = try JSONDecoder().decode(Listing.self, from: data)
//          print(listing)
//          return listing
//
//}
struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
