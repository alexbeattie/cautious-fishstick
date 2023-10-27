//
//  PopDetailsView.swift
//  NewAPI
//
//  Created by Alex Beattie on 9/28/23.
//

import SwiftUI
import MapKit
import Kingfisher

struct PopDestDetailsView: View {
//    let images: Image!
    let value:[Value]
    let media: [Value.Media]
//    let media:[Media]
//    @StateObject var vm: ListingPublisherViewModel
//    @EnvironmentObject private var model: ListingPublisherViewModel
    @State var region:MKCoordinateRegion
//    func addListing() {
//        let listing = Media(MediaCategory: listings.first?.value?.first?.Media?.first?.MediaCategory, MediaURL: listings.first?.value?.first?.Media?.first?.MediaURL)
//    func print(_: listing)
//    }
    init(value: Value, media: [Value.Media]) {
        
//        self.vm = ListingPublisherViewModel
        self.value = [value]
//        self.media = [media]
        self.media = value.Media.map { $0 }!
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: value.Latitude ?? 0, longitude: value.Longitude ?? 0), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
//            VStack {
//                ForEach(vm.media, id:\.MediaCategory) { image in
//                    Text(image.MediaURL?.lowercased() ?? "")
//                }
//            }
//            List(vm.media) { photo in
//                Text(photo.MediaURL ?? "")
//            }
            
            VStack {
//                ListingImageCarouselView(images: images)
                TabView {
//                    List(media) {
//                        images in
//                        KFImage(URL(string: (images.MediaURL ?? "")))
//                    }
                    
//                    ForEach(Array(media.enumerated()), id: \.id) { _ in
////                        print(media)
//                    }

                    ForEach(media, id: \.MediaKey) { media in
                        
                        KFImage(URL(string: (media.MediaURL ?? "")))
                            .resizable()
                            .scaledToFill()
                    }
                    
//                   
            }

            }

            .frame(height:320)
            .tabViewStyle(.page)
       
            Divider()
            VStack {
                Text("aex")
                    .font(.headline)
                  .foregroundColor(Color(.green))
                Text(value.first?.MlsStatus ?? "")
                    .font(.system(size: 14, weight: .heavy))

            }
            Text(value.first?.PublicRemarks ?? "")
                .lineLimit(nil)
                .padding(.horizontal)
            
            Divider()
            
            VStack {
                Text("$\(value.first?.ListPrice ?? 0)")
            }.font(.body)
            
            VStack {
                Text(value.first?.Media?.first?.MediaURL ?? "nothing")
            }.padding()
                //  Spacer()
            VStack {
                // Spacer()
            }
            MapView(value: value)
                .frame(height:200)
                .edgesIgnoringSafeArea(.bottom)
        }
        .ignoresSafeArea()
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MapView: UIViewRepresentable {
    
    
    let value:[Value]

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

//           Add a LEFT IMAGE VIEW
//            var leftIconView = UIImageView()
//            leftIconView.contentMode = .scaleAspectFill
//            leftIconView.contentMode = .scaleAspectFill
//            let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
//            leftIconView.bounds = newBounds
//            leftIconView.clipsToBounds = true

//            let thumbnailImageUrl =    KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))

//            leftIconView = KFImage(URL(string:listing.StandardFields.Photos?.first?.Uri300 ?? ""))

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
            latitude: value.first?.Latitude ?? 0, longitude: value.first?.Longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let lat = value.first?.Latitude ?? 0
        let lng = value.first?.Longitude ?? 0
            
        let pinDrop = CLLocationCoordinate2DMake(lat, lng)
        let pin = MKPointAnnotation()
        pin.coordinate = pinDrop
                       
//            let coordinateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: 27500.0,
//                  longitudinalMeters: 27500.0)
//            mapView.setRegion(coordinateRegion, animated: true)
//
//            let pin = MKPointAnnotation()
//            pin.coordinate = location
            pin.title = value.first?.UnparsedAddress
//
            let listPrice = value.first?.ListPrice
            let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

        let subtitle = "$\(numberFormatter.string(from: NSNumber(value:(UInt64(listPrice ?? 0) )))!)"
//
            pin.subtitle = subtitle
//            pin.coordinate = pin
//            view.addAnnotation(lat as! MKAnnotation)
            view.selectAnnotation(pin, animated: true)
            view.addAnnotation(pin)
//            view.addAnnotations(landmarks)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
}

struct PopDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PopDestDetailsView(value: Value(CoListAgentFullName: "Alex", 
                                        ListAgentFullName: "Beattie",
                                        MlsStatus: "Open",
                                        Media: [],
                                        ListingKey: "1221",
                                        UnparsedAddress: "123 Anywhere Usa",
                                        PostalCode: "91221",
                                        StateOrProvince: "CA",
                                        City: "Thousand Oaks",
                                        BathroomsTotalInteger: 0,
                                        BuilderName: "Sherwood",
                                        BuyerAgentMlsId: "123",
                                        BuyerOfficePhone: "1",
                                        LivingArea: 123), media: [])
    }
}
