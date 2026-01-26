//
//  ProductImageListView.swift
//  StoreApp
//
//  Created by Avantika on 23/11/25.
//

import Foundation
import SwiftUI


struct ProductImageListView : View{
    let images: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
       
    }
}


