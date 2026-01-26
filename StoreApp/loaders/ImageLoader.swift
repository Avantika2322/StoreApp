//
//  ImageLoader.swift
//  StoreApp
//
//  Created by Avantika on 22/11/25.
//

import Foundation
import UIKit


class ImageLoader {
    static func loadImage(url: URL) async -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                return nil
            }
            
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
