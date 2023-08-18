//
//  HomeLogoCell.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 18/07/2023.
//

import UIKit

class HomeSearchCell: UITableViewCell {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        viewSearch.clipsToBounds = true
        viewSearch.layer.cornerRadius = 25
        viewSearch.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        txtSearch.delegate = self
        txtSearch.returnKeyType = .search
        txtSearch.clearButtonMode = .whileEditing
    }
    
    func startSearch() {
        let term = txtSearch.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !term.isEmpty {
            let vc = SearchVC()
            vc.modalPresentationStyle = .fullScreen
            vc.textSearch = txtSearch.text ?? ""
            txtSearch.text = ""
            UIWindow.keyWindow?.navigationTopMost?.present(vc, animated: true)
        }
    }
}
extension HomeSearchCell {
    func tappedHideKeyboard(view: UIView) {
        let selector = #selector(dismissKeyboard)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        txtSearch.resignFirstResponder()
    }
}
extension HomeSearchCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch()
        return true
    }
}
