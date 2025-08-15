//
//  String+Extension.swift
//  StoreApp
//
//  Created by Avantika on 29/06/25.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
}
