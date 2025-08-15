//
//  AddProductTextFieldType.swift
//  StoreApp
//
//  Created by Avantika on 29/06/25.
//

enum AddProductTextFieldType : Int{
    case title
    case price
    case imgUrl
}

struct AddProductFormState {
    var title: Bool = false
    var price: Bool = false
    var imgUrl: Bool = false
    var description: Bool = false
    
    var isValid: Bool {
        return title && price && imgUrl && description
    }
}
