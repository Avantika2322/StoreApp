//
//  ProductsTableViewController.swift
//  StoreApp
//
//  Created by Avantika on 22/06/25.
//

import Foundation
import UIKit
import SwiftUI

class ProductsTableViewController: UITableViewController {
    private var category: GetAllCategoryRes
    private var httpClient = StoreHttpClient()
    private var products: [GetProductsByIdRes] = []
    
    init(category: GetAllCategoryRes!) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var addProductBarItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductButtonPress))
        return button
    }()
    
    @objc private func addProductButtonPress(_ sender: UIBarButtonItem) {
        let addProductViewController = AddProductViewController()
        navigationController?.pushViewController(addProductViewController, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = addProductBarItemButton
        
        Task {
            await self.pupulateProducts()
        }
    }
    
    func pupulateProducts() async{
        do{
            products = try await httpClient.getAllProductsApi(categoryId: category.id)
            tableView.reloadData()
         }catch{
             print("Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = products[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration(content: {
            ProductCellView(product: product)
        })
        
//        var config = cell.defaultContentConfiguration()
//        config.text = product.title
//        config.secondaryText = product.description
//        cell.contentConfiguration = config
       return cell
    }
       
}
