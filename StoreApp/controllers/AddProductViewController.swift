//
//  AddProductViewController.swift
//  StoreApp
//
//  Created by Avantika on 28/06/25.
//

import Foundation
import UIKit
import SwiftUI

class AddProductViewController: UIViewController {
    
    private var selectedCategory: GetAllCategoryRes?
    private var addProductFormState = AddProductFormState()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Title"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.tag = AddProductTextFieldType.title.rawValue
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Price"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.tag = AddProductTextFieldType.price.rawValue
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var imgUrlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Image URL"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.tag = AddProductTextFieldType.imgUrl.rawValue
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var descTextView: UITextView = {
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.backgroundColor = UIColor.lightGray
        textView.delegate = self
        return textView
    }()
    
    lazy var categoryPickerView: CategoryPickerView  = {
        let pickedView = CategoryPickerView(){[weak self] category in
            print(category)
            self?.selectedCategory = category
        }
        return pickedView
    }()
    
    lazy var cancelBarItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        return button
    }()
    
    lazy var saveBarItemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        button.isEnabled = false
        return button
    }()
    
    @objc private func cancelTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func saveTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        switch sender.tag {
            case AddProductTextFieldType.title.rawValue:
            addProductFormState.title = !text.isEmpty
            case AddProductTextFieldType.price.rawValue:
            addProductFormState.price = !text.isEmpty && text.isNumeric
            case AddProductTextFieldType.imgUrl.rawValue:
            addProductFormState.imgUrl = !text.isEmpty
        default:
            break
        }
        
        saveBarItemButton.isEnabled = addProductFormState.isValid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = cancelBarItemButton
        navigationItem.rightBarButtonItem = saveBarItemButton
        setUpUi()
    }
    
    private func setUpUi() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(imgUrlTextField)
        stackView.addArrangedSubview(descTextView)
        
        // picker view
        let hostingController = UIHostingController(rootView: categoryPickerView)
        stackView.addArrangedSubview(hostingController.view)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        view.addSubview(stackView)
        
        // add constraints
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}


struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: AddProductViewController())
        //AddProductViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context){}
}

struct AddProductViewController_Previews: PreviewProvider {
    static var previews: some View {
        AddProductViewControllerRepresentable()
    }
}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        addProductFormState.description = !textView.text.isEmpty
        saveBarItemButton.isEnabled = addProductFormState.isValid
    }
}
