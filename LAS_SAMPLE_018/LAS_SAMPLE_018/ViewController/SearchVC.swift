//
//  SearchVC.swift
//  LAS_SAMPLE_018
//
//  Created by Macbook on 09/08/2023.
//

import UIKit

class SearchVC: UIViewController {
    //MARK: - properties
    var textSearch = ""
    var searchResult: [String] = []
    var songService: MusicService = MusicService()
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    //MAKR: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.text = textSearch
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    //MARK: - action
    @IBAction func btnCancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - private
    private func setupUI() {
        tableView.register(UINib(nibName: MusicCell.cellId, bundle: nil), forCellReuseIdentifier: MusicCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        txtSearch.delegate = self
        txtSearch.returnKeyType = .search
        txtSearch.clearButtonMode = .whileEditing
        
        viewSearch.backgroundColor = UIColor(rgb: 0xE1E3E5)
        viewSearch.clipsToBounds = true
        viewSearch.layer.cornerRadius = 25
        viewSearch.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        let text = txtSearch.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        searchResult = songService.getListSongID(songName: text)
        hideKeyboardWhenTappedAround()
    }
    
    private  func startSearch() {
        let term = txtSearch.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if term.isEmpty {
            searchResult = []
        }
        else {
            searchResult = songService.getListSongID(songName: term)
        }
        self.tableView.reloadData()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch()
        return true
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicCell.cellId) as! MusicCell
        cell.selectionStyle = .none
        cell.songID = searchResult[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared.mainPlayer.setPlaylist(searchResult, currentItem: searchResult[indexPath.row])
        self.present(AppDelegate.shared.mainPlayer, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
