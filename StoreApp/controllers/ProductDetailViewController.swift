//
//  ProductDetailViewController.swift
//  StoreApp
//
//  Created by Avantika on 28/09/25.
//

import Foundation
import UIKit
import SwiftUI

class ProductDetailViewController: UIViewController {
    
    let product : GetProductsByIdRes
    let client = StoreHttpClient()
    
    lazy var descriptionLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    lazy var deleteProductButton : UIButton = {
        var button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        //button.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
        return button
    }()
    
    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        var indicatorView = UIActivityIndicatorView(style: .large)
        return indicatorView
    }()
    
    init(product: GetProductsByIdRes) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = product.title
        
        setUpUi()
    }
    
    @objc private func deleteProductButtonPressed(_ sender: UIButton) {
        Task {
            do{
                guard let productId = product.id else { return }
               // let isDeleted = try await client.deleteProductApi(productId: productId)
                
                let isDeleted: Bool = try await client.load(Resource(url: URL.deleteProductUrl(productId), httpMethod: .delete))
                
                if isDeleted {
                    navigationController?.popViewController(animated: true)
                }
            }
            catch {
                //showAlert(title: "Error", message: "Error deleting product. Please try again.")
                showMessage(title: "Error", message: "Error deleting product. Please try again.", messageType: .error)
                print("Error deleting product")
            }
            
        }
    }
    
    private func setUpUi() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = product.description
        priceLabel.text = product.price.formatCurrency()
        
        // fetch image
        Task{
            loadingIndicatorView.startAnimating()
            var images: [UIImage] = []
            for imageURL in (product.images ?? []){
                guard let downloadedImg = await ImageLoader.loadImage(url: imageURL) else { return }
                images.append(downloadedImg)
            }
            
            let productImageListVC = UIHostingController(rootView: ProductImageListView(images: images))
            guard let productImageListView = productImageListVC.view else { return }
            stackView.insertArrangedSubview(productImageListView, at: 0)
            addChild(productImageListVC)
            productImageListVC.didMove(toParent: self)
            loadingIndicatorView.stopAnimating()
        }
        
        deleteProductButton.addTarget(self, action: #selector(deleteProductButtonPressed), for: .touchUpInside)
        
        stackView.addArrangedSubview(loadingIndicatorView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(deleteProductButton)
        
       
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
}
