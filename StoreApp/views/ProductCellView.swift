//
//  ProductCellView.swift
//  StoreApp
//
//  Created by Avantika on 22/06/25.
//

import SwiftUI

struct ProductCellView: View {
    let product: GetProductsByIdRes
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(product.title).bold()
                    .font(.headline)
                Text(product.description)
                    .font(.caption)
            }
            Spacer()
            Text(product.price, format: .currency(code: Locale.currencyCode)).padding(5).background(Color.yellow).foregroundColor(.black).cornerRadius(5)
        }
    }
}

#Preview {
    ProductCellView(product: GetProductsByIdRes(title: "Handmade Fresh Table", price: 12.00, description: "Andy shoes are designed to keeping in...", images: [URL(string: "https://placehold.co/600x400")!], category: GetAllCategoryRes(id: 1, name: "Clothes", image: "https://placehold.co/600x400")))
}
