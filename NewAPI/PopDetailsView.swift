//
//  PopDetailsView.swift
//  NewAPI
//
//  Created by Alex Beattie on 9/28/23.
//

import SwiftUI
import MapKit

struct PopDestDetailsView: View {
    
    let listing:Value
    
    @State var region:MKCoordinateRegion
    init(listing: Value) {
        self.listing = listing
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: listing.Latitude ?? 0, longitude: listing.Longitude ?? 0), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {

     
//            padding(.vertical)

            ScrollView(showsIndicators: false) {
                
                AsyncImage(url: URL(string: listing.Media?.first?.MediaURL ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width:400, height:200)
                    
                } placeholder: {
                    ProgressView()
                }

                    
                    .frame(width: 400,
                        height:200)
                    .clipped()
                Divider()
                    Text(listing.PublicRemarks ?? "")
                        .lineLimit(nil)
                        .padding(.horizontal)
                    Divider()
                
                    VStack {
                        
                        Text("$\(listing.ListPrice ?? 0)")
                           
                        
//                        Spacer()
                    }.font(.body)
                
                VStack {
                    Text("Location")
                }.padding()
//                    .padding()
//                Spacer()
                    VStack {
//
//                        Spacer()

                    }
                MapView(listing: listing)
                    .frame(height:200)
                    .edgesIgnoringSafeArea(.bottom)

                    
            }

//        .navigationBarTitle(listing.StandardFields.Photos?.first?.Name ?? "", displayMode: .inline)
            .edgesIgnoringSafeArea(.bottom)

//            .edgesIgnoringSafeArea([.bottom, .top])
//            .navigationBarTitle("Editor", displayMode: .inline)

    }

}

struct MapView: UIViewRepresentable {
    
    
    let listing: Value

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
                init(_ parent: MapView) {
                    self.parent = parent
                }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            guard !(annotation is MKUserLocation) else {
//                return nil
//            }
            
            let annotationIdentifier = "AnnotationIdentifier"
            
            let annoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annoView.pinTintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
//            annoView.animatesDrop = true
            annoView.canShowCallout = true
        
            // Add a RIGHT CALLOUT Accessory
            let rightButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
            rightButton.frame = CGRect(x:0, y:0, width:32, height:32)
            rightButton.clipsToBounds = true
            rightButton.setImage(UIImage(named: "small-pin-map-7"), for: UIControl.State())
            annoView.rightCalloutAccessoryView = rightButton
            
            let leftView = UIView()
            
            leftView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            leftView.backgroundColor = .blue
            annoView.leftCalloutAccessoryView = leftView
            //Add a LEFT IMAGE VIEW
//            var leftIconView = UIImageView()
////            leftIconView.contentMode = .scaleAspectFill
////            leftIconView.contentMode = .scaleAspectFill
//            let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
//            leftIconView.bounds = newBounds
//            leftIconView.clipsToBounds = true
//
////            let thumbnailImageUrl =    KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
//
//            leftIconView = KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))
//
//
//            annoView.leftCalloutAccessoryView = leftIconView
            
            return annoView
            
            }
        
        }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = .hybrid
        view.delegate = context.coordinator

        let coordinate = CLLocationCoordinate2D(
            latitude: listing.Latitude ?? 0, longitude: listing.Longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let lat = listing.Latitude ?? 0
        let lng = listing.Longitude ?? 0
            
        let pinDrop = CLLocationCoordinate2DMake(lat, lng)
        let pin = MKPointAnnotation()
        pin.coordinate = pinDrop
        
       

        
//            let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: 27500.0, longitudinalMeters: 27500.0)
//            mapView.setRegion(coordinateRegion, animated: true)
//
//            let pin = MKPointAnnotation()
//            pin.coordinate = location
            pin.title = listing.UnparsedAddress
//
            let listPrice = listing.ListPrice
            let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

        let subtitle = "$\(numberFormatter.string(from: NSNumber(value:(UInt64(listPrice ?? 0) )))!)"
//
            pin.subtitle = subtitle
//            pin.coordinate = pin
//            view.addAnnotation(lat as! MKAnnotation)
//        view.selectAnnotation(pin, animated: true)
        view.addAnnotation(pin)
//        view.addAnnotations(landmarks)

    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
        
        
    }
}

struct PopDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PopDestDetailsView(listing: Value(CoListAgentFullName: "Alex", ListAgentFullName: "Beattie", MlsStatus: "Open", Media: [], ListingKey: "1221", UnparsedAddress: "123 Anywhere Usa", PostalCode: "91221", StateOrProvince: "CA", City: "Thousand Oaks", BathroomsTotalInteger: 0, BuilderName: "Sherwood", BuyerAgentMlsId: "123",BuyerOfficePhone: "1",CloseDate: "99", ListingContractDate: "22",LivingArea: 123))

    }
}
