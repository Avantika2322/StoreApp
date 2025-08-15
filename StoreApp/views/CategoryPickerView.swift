//
//  CategoryPickerView.swift
//  StoreApp
//
//  Created by Avantika on 28/06/25.
//

import SwiftUI

struct CategoryPickerView: View {
    let client = StoreHttpClient()
    @State var categories: [GetAllCategoryRes] = []
    @State var selectedCategory: GetAllCategoryRes?
    let onCategorySelected: (GetAllCategoryRes) -> Void
    
    var body: some View {
        Picker("Categories", selection: $selectedCategory){
            ForEach(categories, id: \.id){category in
                Text(category.name).tag(Optional(category))
            }
        }
        .onChange(of: selectedCategory) { oldValue, newValue in
            onCategorySelected(newValue ?? categories.first!)
        }
            .pickerStyle(.wheel)
            .task {
            do {
                let categoriesData = try await client.getAllCategoriesApi()
                self.categories = categoriesData
                selectedCategory = categories.first
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    CategoryPickerView( onCategorySelected: { _ in })
}
