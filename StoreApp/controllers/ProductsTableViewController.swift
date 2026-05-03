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
        addProductViewController.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await pupulateProducts()
            tableView.reloadData()
        }
    }
    
    func pupulateProducts() async{
        do{
            //products = try await httpClient.getAllProductsApi(categoryId: category.id)
            products = try await httpClient.load(Resource(url: URL.productById(category.id)))
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
        cell.accessoryType = .disclosureIndicator
        
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
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController(product: products[indexPath.row])
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
       
}

extension ProductsTableViewController:AddProductViewControllerDelegate{
    func addProductViewControllerDidCancel(_ controller: AddProductViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addProductViewControllerDidSave(_ controller: AddProductViewController, didAddProduct product: GetProductsByIdRes) {
        let addProductRequest = AddProductReq(product: product)
        
        Task {
            do{
              //let newProduct = try await httpClient.addProductApi(product: addProductRequest)
                let data = try JSONEncoder().encode(addProductRequest)
                let newProduct: GetProductsByIdRes = try await httpClient.load(Resource(url: URL.addProductUrl, httpMethod: .post(data)))
                products.insert(newProduct, at: 0)
                tableView.reloadData()
                navigationController?.popViewController(animated: true)
            }catch {
                print(error)
            }
        }
       
    }
}
