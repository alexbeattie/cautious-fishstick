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
    var ListingContractDate: Date?
    var ListingId: String?
    var LivingArea: Int?
    var formattedLaunchDate: String {
        ListingContractDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
//    static func dateFromString(_ string: String) -> Date {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = .current
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            return dateFormatter.date(from: string) ?? Date()
//        }
//    
//    func formatStringDate(date: String) -> String {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let newDate = dateFormatter.date(from: ListingContractDate ?? "")
//            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
//            return dateFormatter.string(from: newDate!)
//    }
    
}
struct Media: Codable {
    var MediaCategory: String?
    var MediaURL: String?
}



@MainActor
class ListingPublisherViewModel: ObservableObject {
    
    @Published var results = [Value]()
    @Published var listings = [Listing]()

    
    func fetchProducts() async {
        

        //create the new url
//        let url = URL(string: "https://replication.sparkapi.com/Reso/OData/Property?$filter=(ListPrice ge 1000000) and (MlsStatus eq 'Active')&$orderby=ListPrice desc&$expand=Media&$skip=10&$count=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        let url = URL(string:"https://replication.sparkapi.com/Reso/OData/Property?orderby=ListPrice asc&$expand=Media&$top=50&$count=true&$filter=ListAgentKey eq '20160917171119703445000000'".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
//    https://replication.sparkapi.com/Reso/OData/Property?orderby=ListPrice asc&$expand=Media&$top=50&$count=true&$filter=ListAgentKey eq '20160917171119703445000000'
        //create a new urlRequest passing the url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(TOKEN)", forHTTPHeaderField: "Authorization")
        do {
            
            //run the request and retrieve both the data and the response of the call
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "y-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)

            //checks if there are errors regarding the HTTP status code and decodes using the passed struct
            if let fetchedData = try? decoder.decode(Listing.self, from: data) {
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

   


struct ContentView: View {
    
    @StateObject var vm = ListingPublisherViewModel()

    let listing: Value
    let topListing: Listing

        
    @State private var showingSheet = false

    var body: some View {


        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
            ScrollView {
          
                ForEach(vm.results, id: \.ListingKey)  { listing  in
                    NavigationLink {
                        Text("details")
                    } label: {
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
                                                .foregroundColor(Color(.red))
                                            HStack {
    //                                            Text("\(listing.Model ?? "Not Named")")
    //                                                .font(.system(size: 14, weight: .regular))
    //                                                .foregroundColor(Color(.gray))
                                                Text(listing.MlsStatus ?? "")
                                                    .font(.system(size: 14, weight: .heavy))
                                                    .foregroundColor(Color(.red))
                                                Text("\(listing.BuyerOfficeAOR ?? "")")
                                                    .font(.system(size: 12, weight: .heavy))
                                            }
                                            Button("Showing Sheet") {
                                                showingSheet.toggle()
                                            }
                                            .sheet(isPresented: $showingSheet) {
                                                PopDestDetailsView(value: listing)
                                            }
                                            
                                            HStack {

                                                          
                                                Text("$")
    //                                            Text(String(listing.ListPrice)).formatted(.currency(code: "USD"))
    //                                            Label(String(listing.ListPrice ?? 0), systemImage: "house")
//                                                Text(Date.now.addingTimeInterval(600), style: .time)
                                                
                                                //.redacted(reason: .placeholder)
                                                
    //                                            Text(String(listing.ListPrice ?? 0))
    //                                                .font(.system(size: 14, weight: .regular))
    //                                                .foregroundColor(Color(.white))
                                                Text(listing.ListPrice ?? 0, format: .currency(code: "USD"))
                                                    .font(.system(size: 14, weight: .regular))
                                                    .foregroundColor(Color(.blue))
                                                Text(listing.formattedLaunchDate ?? "")

//                                                Text(Date.distantFuture)
//                                                Text(date, formatter: .dateFormatter)
//                                                    .taskDateFormat
    //                                            Text(listing.ListingContractDate, format: Date.FormatStyle(date: .numeric, time: .omitted))
                                                ///             Text(myDate, format: Date.FormatStyle(date: .complete, time: .complete))
                                                ///             Text(myDate, format: Date.FormatStyle().hour(.defaultDigitsNoAMPM).minute())
//                                                Text(listing.ListingContractDate ?? "")
                                            
                                            }
                                            .padding(.horizontal)
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    .padding(.bottom)

                    
                }
                //TODO
                //Show next page of listings
//                ForEach(vm.listings, id: \.odataContext) { topListing in
//                    Link ("next", destination: URL(string: topListing.odataNextLink!)!)
//                }
            }
            .navigationTitle("Listings")
            .navigationBarTitleDisplayMode(.inline)

            .background(.darkBackground)
            .preferredColorScheme(.dark)

        }

          
        }
        .task {
            await vm.fetchProducts()
        }
    }

}
extension Date {
        func formatDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("y-MM-dd")
            return dateFormatter.string(from: self)
        }
}


struct ContentView_Previews: PreviewProvider {
    
//    let date = Date()
    static var previews: some View {
        ContentView(listing: Value(CoListAgentFullName: "Alex", ListAgentFullName: "Beattie", MlsStatus: "Open", Media: [], ListingKey: "1221", UnparsedAddress: "123 Anywhere Usa", PostalCode: "91221", StateOrProvince: "CA", City: "Thousand Oaks", BathroomsTotalInteger: 0, BuilderName: "Sherwood",BuyerAgentMlsId: "123", BuyerOfficePhone: "1", CloseDate: "99", ListingContractDate: Date(),LivingArea: 123), topListing: Listing(odataContext: "alex", odataNextLink: "alex", odataCount: 0, value: [Value].init()))

            .preferredColorScheme(.dark)
    }
}
