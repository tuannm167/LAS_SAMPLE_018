//
//  MusicModel.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import Foundation
import MediaPlayer

enum MusicType: Int {
    case audio = 0
    case video = 1
}

struct MusicModel {
    let songId:  NSNumber
    let albumTitle: String?
    let artistName: String?
    let songTitle: String?
    let artWork: MPMediaItemArtwork?
    let songURL: URL?
    let mediaType: MPMediaType
    let duration: String?
    
    var getThumb: UIImage? {
        guard let artWork = artWork else {return UIImage(named: "ic_thumb")}
        
        return artWork.image(at: CGSize(width: 200,height: 200))
        
    }
    
    var songType: MusicType {
        
        if mediaType == .movie || mediaType == .tvShow || mediaType == .videoPodcast || mediaType == .musicVideo || mediaType == .videoITunesU || mediaType == .homeVideo   || mediaType == .anyVideo    {
            return .video
        } else {
            return .audio
        }
    }
}

struct AlbumModel {
    let albumTitle: String
    let artWork: MPMediaItemArtwork?
    let songIDs: [String]
    
    var getThumb: UIImage? {
        guard let artWork = artWork else {return UIImage(named: "ic_thumb")}
        
        return artWork.image(at: CGSize(width: 200,height: 200))
        
    }
    var songTotalStr: String {
        return songIDs.count > 1 ? "\(songIDs.count) songs" : "\(songIDs.count) song"
    }
}

