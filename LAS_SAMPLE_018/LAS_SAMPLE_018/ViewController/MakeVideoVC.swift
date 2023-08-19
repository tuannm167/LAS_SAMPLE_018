//
//  MakeVideoVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit

class MakeVideoVC: UIViewController {
    //MARK: - properties
    
    fileprivate var videos:[String] = []
    
    //MARK: - outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var myFileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    private func setupUI() {
        topView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        topView.backgroundColor = UIColor(rgb: 0x5055D6)
        createView.layer.cornerRadius = 23
        
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        bottomView.backgroundColor = UIColor(rgb: 0xF3F8FF)
        
        myFileTableView.register(UINib(nibName: NoVideoCell.cellId, bundle: nil), forCellReuseIdentifier: NoVideoCell.cellId)
        myFileTableView.dataSource = self
        myFileTableView.delegate = self
        myFileTableView.separatorStyle = .none
        
    }


    @IBAction func createVideoClick(_ sender: Any) {
        guard let navi = UIWindow.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        
        let summaryVC = GenerateVideoVC()
        navi.pushViewController(summaryVC, animated: true)
    }
    
}

extension MakeVideoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videos.count == 0 {
            return 1
        } else {
            return videos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if videos.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoVideoCell.cellId) as! NoVideoCell
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

extension MakeVideoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if videos.count == 0 {
            return NoVideoCell.height
        }
        else {
            return 0
        }
    }
}
