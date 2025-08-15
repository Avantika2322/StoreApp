//
//  CategoriesViewController.swift
//  StoreApp
//
//  Created by Avantika on 30/03/25.
//

import Foundation
import UIKit

class CategoriesTableViewController: UITableViewController {
    private var client = StoreHttpClient()
    private var categories: [GetAllCategoryRes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Categories"
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        
        Task {
            await self.fetchCategories()
            tableView.reloadData()
        }
    }
    
    private func fetchCategories() async {
        do{
            categories = try await client.getAllCategoriesApi()
            print(categories)
        }
        catch {
            print("Error fetching categories")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        print("Selected row at \(indexPath.row)")
        let category = categories[indexPath.row]
        let productsViewController = ProductsTableViewController(category: category)
        self.navigationController?.pushViewController(productsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let category = categories[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = category.name
        
        if let url = URL(string: category.image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        configuration.image = image
                        configuration.imageProperties.maximumSize = CGSize(width: 75, height: 75)
                        cell.contentConfiguration = configuration
                    }
                }
            }
        }
        
        return cell
    }
}
