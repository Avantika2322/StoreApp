//
//  MessageView.swift
//  StoreApp
//
//  Created by Avantika on 26/01/26.
//

import SwiftUI

enum MessageType {
    case success, warning, error
}

struct MessageView: View {
    let message: String
    let type: MessageType
    let title: String
    
    private var backgroundColor: Color {
        switch type {
        case .success:
            return Color.green
        case .warning:
            return Color.orange
        case .error:
            return Color.red
        }
    }
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 15
        ){
            Text(title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(message)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(Color.white)
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 20)
    }
}

#Preview {
    MessageView(message: "Error occurred, please try again.", type: .warning, title: "Error")
}
