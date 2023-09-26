//
//  MakeVideoVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit
import AVKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadVideo()
    }
    
    
    private func setupUI() {
        topView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        topView.backgroundColor = UIColor(rgb: 0x5055D6)
        createView.layer.cornerRadius = 23
        
        bottomView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        bottomView.backgroundColor = UIColor(rgb: 0xF3F8FF)
        
        myFileTableView.register(UINib(nibName: NoVideoCell.cellId, bundle: nil), forCellReuseIdentifier: NoVideoCell.cellId)
        myFileTableView.register(UINib(nibName: MyFileItemCell.cellId, bundle: nil), forCellReuseIdentifier: MyFileItemCell.cellId)
        
        myFileTableView.dataSource = self
        myFileTableView.delegate = self
        myFileTableView.separatorStyle = .none
        
    }
    
    
    func loadVideo() {
        
        guard let imageURL = URL.videoEditorFolder() else { return }
        do {
            videos = try FileManager.default.contentsOfDirectory(atPath: imageURL.path)
            myFileTableView.reloadData()
        }
        catch  let error as NSError {
            print(error.localizedDescription)
            videos = []
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MyFileItemCell.cellId) as! MyFileItemCell
            cell.selectionStyle = .none
            cell.titleVideo = videos[indexPath.row]
            let videoUrl = URL.videoEditorFolder()!.appendingPathComponent(videos[indexPath.row])
            cell.onShare = {
                let textToShare = "Share \(self.videos[indexPath.row]) to"
                let objectsToShare: [Any] = [textToShare, videoUrl]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if videos.count != 0 {
            guard let pathURL = URL.videoEditorFolder()?.appendingPathComponent(videos[indexPath.row]) else {return}
            self.playVideo(url: pathURL)
        }
        
    }
}

extension MakeVideoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if videos.count == 0 {
            return NoVideoCell.height
        }
        else {
            return MyFileItemCell.height
        }
    }
}
