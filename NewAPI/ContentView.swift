//
//  ContentView.swift
//  NewAPI
//
//  Created by Alex Beattie on 9/20/23.
//

import SwiftUI
import Combine
import AVKit

struct ContentView: View {
    
    let listing: Value
    let topListing: Listing

    let media: [Value.Media]
    @StateObject var vm = ListingPublisherViewModel()
    @State private var showingSheet = false
  
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
                ScrollView {
                    
                    ForEach(vm.results, id: \.ListingKey)  { listing  in
                        NavigationLink {
                            PopDestDetailsView(value: listing, media: media)

                            Text("details")
                        } label: {
                            VStack(alignment: .leading) {
                                
                                
//                                ForEach($vm.media, id:\.MediaCategory) { items in
//                                    Text(media.MediaURL)
//                                }
                                
                                AsyncImage(url: URL(string: listing.Media?.first?.MediaURL ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:400, height:200)
                                        .clipped()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                ZStack {
                                    VStack (alignment: .leading, spacing: 12) {
                                        
                                        HStack {
                                            VStack{
                                                Text(listing.UnparsedAddress ?? "")
                                                    .font(.system(size: 16, weight: .regular))
//                                                    .foregroundColor(Color(.red))
                                                HStack {
                                                    //                                            Text("\(listing.Model ?? "Not Named")")
                                                    //                                                .font(.system(size: 14, weight: .regular))
                                                    //                                                .foregroundColor(Color(.gray))
                                                    Text(listing.MlsStatus ?? "")
                                                        .font(.system(size: 14, weight: .heavy))
//                                                        .foregroundColor(Color(.red))
                                                    Text("\(listing.BuyerOfficeAOR ?? "")")
                                                        .font(.system(size: 12, weight: .heavy))
                                                }
                                                Button("Showing Sheet") {
                                                    showingSheet.toggle()
                                                }
                                                .sheet(isPresented: $showingSheet) {

                                                    PopDestDetailsView(value: listing, media: media)
                                                }
                                                
                                                HStack {
                                                    
                                                    
                                                    Text(listing.ListPrice ?? 0, format: .currency(code: "USD"))
                                                        .font(.system(size: 14, weight: .regular))
//                                                        .foregroundColor(Color(.blue))
                                                    Text(listing.formattedLaunchDate)
                                                    
                                                    
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
                                    ForEach(vm.listings, id: \.odataContext) { topListing in
                                        Link ("next", destination: URL(string: topListing.odataNextLink!)!)
                                    }
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


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(listing: Value(CoListAgentFullName: "Alex", ListAgentFullName: "Beattie", MlsStatus: "Open", Media: [], ListingKey: "1221", UnparsedAddress: "123 Anywhere Usa", PostalCode: "91221", StateOrProvince: "CA", City: "Thousand Oaks", BathroomsTotalInteger: 0, BuilderName: "Sherwood",BuyerAgentMlsId: "123", BuyerOfficePhone: "1", CloseDate: "99", ListingContractDate: Date(),LivingArea: 123), topListing: Listing(odataContext: "alex", odataNextLink: "alex", odataCount: 0, value: [Value].init()), media: [] )

            .preferredColorScheme(.dark)
    }
}
 
extension String.StringInterpolation {
    mutating func appendInterpolation(json JSONData: Data) {
        guard
            let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted) else {
            appendInterpolation("Invalid JSON data")
            return
        }
        appendInterpolation("\n\(String(decoding: jsonData, as: UTF8.self))")
    }
}
