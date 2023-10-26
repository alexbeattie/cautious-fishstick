//
//  ListingImageCarouselView.swift
//  NewAPI
//
//  Created by Alex Beattie on 10/24/23.
//

import SwiftUI
import Kingfisher
struct ListingImageCarouselView: View {
//    let vm:ListingPublisherViewModel
//    var image = [Media]()
    var images = ["https://cdn.photos.sparkplatform.com/vc/20210901050900400130000000-o.jpg", "https://cdn.photos.sparkplatform.com/vc/20210901054953957066000000-o.jpg", "https://cdn.photos.sparkplatform.com/vc/20210901050926435414000000-o.jpg", "https://cdn.photos.sparkplatform.com/vc/20211007000043973526000000-o.jpg"]
    var body: some View {
        TabView {
//            ForEach(vm.media, id: \.MediaCategory) { photos in
//                KFImage(URL(string: image.first?.MediaURL ?? "alex"))
//            }
            ForEach(images, id: \.self) { image in
                KFImage(URL(string: image))
                    .resizable()
                    .scaledToFit()
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ListingImageCarouselView()
}
