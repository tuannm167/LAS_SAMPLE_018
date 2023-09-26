//
//  AudioVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 31/07/2023.
//

import UIKit
import MediaPlayer

class AudioVC: BaseVC {
    //MARK: - properties
    var musicService: MusicService = MusicService()
    var musics:[String] = []
    var selectedMusics: [String] = []
    var selectedURL:[URL] = []
    
    
    var onSelectedAudio:((_ audios: [String], _ audioUrl: [URL])->Void)?
    
    //MARK: - outlets
    @IBOutlet weak var addAudioButton: UIButton!
    @IBOutlet weak var audioTBView: UITableView!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //setup UI
        audioTBView.register(UINib(nibName: AudioItemCell.cellId, bundle: nil), forCellReuseIdentifier: AudioItemCell.cellId)
        audioTBView.separatorStyle = .none
        
        audioTBView.delegate = self
        audioTBView.dataSource = self
        
        addAudioButton.setTitleColor(UIColor(rgb: 0xF128EA), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //MARK: - private
    private func loadData() {
        //load music local
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.musics = self.musicService.getAllMusic()
                DispatchQueue.main.async {

                    self.audioTBView.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
    }
    
    func displayMediaLibraryError() {
        
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //MARK: - action
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAudioClick(_ sender: Any) {
        if selectedMusics.count > 0 {
            onSelectedAudio?(selectedMusics, selectedURL)
            self.navigationController?.popViewController(animated: true)
        } else {
            let ac = UIAlertController(title: "Please choose audio!!!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                // don't nothing

            }))
            self.present(ac, animated: true)
        }
    }
}
extension AudioVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioItemCell.cellId) as! AudioItemCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.musicId = musics[indexPath.row]
        cell.isEdit = true
        return cell
    }
}

extension AudioVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension AudioVC: AudioItemCellDelegate {
    func addOrRemove(_ audio: String) {
        if let index = selectedMusics.firstIndex(where: { $0.lowercased() == audio.lowercased() }) {
            selectedMusics.remove(at: index)
            selectedURL.remove(at: index)
        }
        else {
            selectedMusics.append(audio)
            guard let url = musicService.getSongURL(songId: audio) else { return }
            selectedURL.append(url)
        }
    }
    
    func isExists(_ audio: String) -> Bool {
        return selectedMusics.first(where: { $0.lowercased() == audio.lowercased() }) != nil
    }
}
