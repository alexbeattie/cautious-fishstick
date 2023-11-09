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
    //    @State private var destinationSearchView = false
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
                //                if destinationSearchView {
                //                    DestinationSearchView()
                //                } else {
                //
                //                }

                
                ScrollView {
                    SearchAndFilterBar()

                    ForEach(vm.results, id: \.ListingKey)  { listing  in
                        NavigationLink {
                            NavigationLazyView(
                                
                                PopDestDetailsView(value: listing, media: media))
                            .navigationBarBackButtonHidden()

//                                .navigationBarBackButtonHidden()
//                                  Text("details")
                        } label: {
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    AsyncImage(url: URL(string: listing.Media?.first?.MediaURL ?? "")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:400, height:200)
                                            .clipped()
                                            .ignoresSafeArea()
                                        
                                        
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                }
                                HStack (alignment: .bottom){
                                    
                                    VStack (alignment: .leading) {
                                        Text("$\(listing.ListPrice ?? 0)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .scaledToFit()

                                            .foregroundColor(Color(.label))
                //                            .frame(maxWidth: .infinity)
                                            .minimumScaleFactor(0.01)
                                            .lineLimit(1)
                //                            .background(Color(.red))
                                        Text("Price")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    
                                    VStack (alignment: .leading) {
                                        Text("\(listing.BedroomsTotal ?? 0)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(.label))
                                        Label("Beds", systemImage: "bed.double")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    
                                    VStack (alignment: .leading) {
                                        Text(String(listing.BathroomsTotalInteger ?? 0))
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(.label))
                                        Label("Baths", systemImage: "bathtub")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack (alignment: .leading) {
                                        Spacer()
                                        Text("\(listing.BuildingAreaTotal ?? 0)")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color(.label))
                                        
                                        Text("Sq Feet")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.gray)
                                        
                                    }
                                }.padding(.horizontal)

//                                VStack (alignment: .leading, spacing: 12) {
                                    
                                    HStack (alignment: .bottom) {
//                                        VStack{
//                                            Text(AttributedString(listing.UnparsedAddress ?? ""))
//                                                .font(.system(size: 14, weight: .semibold))
//                                                .foregroundColor(Color(.label))
//                                                .minimumScaleFactor(0.01)
//                                                .lineLimit(1)
//                                            Text("Price")
//                                                .font(.system(size: 14, weight: .regular))
//                                                .foregroundColor(.gray)
//                                        }
                                        VStack (alignment: .leading) {
//                                            
//                                            Text("\(listing.BedroomsTotal ?? 0)")
//                                                .font(.system(size: 14, weight: .semibold))
//                                                .foregroundColor(Color(.label))
//                                            Label("Beds", systemImage: "bed.double")
//                                                .font(.system(size: 14, weight: .regular))
//                                                .foregroundColor(.gray)

//                                            Text(listing.ListAgentFullName ?? "")
//                                                .font(.system(size: 16, weight: .regular))

                                        
                                        
                                            
                                            HStack {
                                                Text(listing.MlsStatus ?? "")
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(Color(.tertiaryLabel))
                                                Text("\(listing.BuyerOfficeAOR ?? "")")
                                                    .font(.system(size: 12, weight: .heavy))
                                            }
                                            Button("Showing Sheet") {
                                                showingSheet.toggle()
                                            }
                                            .sheet(isPresented: $showingSheet) {
                                                
                                                PopDestDetailsView(value: listing, media: media)
                                            }
                                            
//                                            HStack {
//                                                
//                                                
//                                                Text(listing.ListPrice ?? 0, format: .currency(code: "USD"))
//                                                    .font(.system(size: 14, weight: .regular))
//                                                Text(listing.formattedLaunchDate)
//                                                    .font(.system(size: 14, weight: .regular))
//                                                
//                                                
//                                            }
                                            .padding(.horizontal)
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                
                                
                            }
                        }
                        
                        .padding(.bottom)
                    }
                    //TODO
                    //Show next page of listings
                    //                                    ForEach(vm.listings, id: \.odataContext) { topListing in
                    //                                        Link ("next", destination: URL(string: topListing.odataNextLink!)!)
                    //                                    }
                }
                //                .navigationTitle("Listings")
                //                .navigationBarTitleDisplayMode(.automatic)
                .ignoresSafeArea()
//                .background(.darkBackground)
                .preferredColorScheme(.dark)
            }
        }
        .task {
            await vm.fetchProducts()
        }
    }
    
}
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
