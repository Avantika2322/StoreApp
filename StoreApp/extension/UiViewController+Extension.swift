//
//  UiViewController+Extension.swift
//  StoreApp
//
//  Created by Avantika on 26/01/26.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showMessage(title: String, message: String, messageType: MessageType) {
        let hostingController = UIHostingController(rootView: MessageView(message: message, type: messageType, title: title))
        guard let messageView = hostingController.view else { return }
        
        view.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        messageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            messageView.removeFromSuperview()
        }
    }
}
