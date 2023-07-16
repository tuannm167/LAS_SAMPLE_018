//
//  MusicService.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import Foundation
import MediaPlayer

enum MusicCategory: Int {
    case album = 0
    case artist = 1
    case playlist
    
}

class MusicService {
    
    func getAlbum(songCategory: MusicCategory) -> [AlbumModel] {
        
        var albums: [AlbumModel] = []
        let albumsQuery: MPMediaQuery
        
        switch songCategory {
        case .album:
            albumsQuery = MPMediaQuery.albums()
        case .artist:
            albumsQuery = MPMediaQuery.artists()
        case .playlist:
            albumsQuery = MPMediaQuery.playlists()
        }
        
        // let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        //  var album: MPMediaItemCollection
        
        for album in albumItems {
            
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            var songIDs: [String] = []
            var albumTitle: String = ""
            var artWork: MPMediaItemArtwork?
            
            
            for song in albumItems {
                switch songCategory {
                    
                case .album:
                    albumTitle = song.albumTitle ?? ""
                    artWork = song.artwork
                case .artist:
                    albumTitle = song.artist ?? ""
                    artWork = song.artwork
                case .playlist:
                    albumTitle = album.value(forProperty: MPMediaPlaylistPropertyName) as! String
                    artWork = song.artwork
                }
                songIDs.append(song.persistentID.toString())
            }
            let albumInfo: AlbumModel = AlbumModel(
                
                albumTitle: albumTitle,
                artWork: artWork,
                songIDs: songIDs
            )
            
            albums.append( albumInfo )
        }
        
        return albums
        
    }
    
    
    func getItem( songId: String ) -> MusicModel? {
        
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        var songInfo: MusicModel?
        
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        if items.count >= 1 {
            let song = items[items.count - 1]
            songInfo = MusicModel(
                songId: song.persistentID as NSNumber,
                albumTitle: song.albumTitle,
                artistName: song.artist,
                songTitle: song.title,
                artWork: song.artwork,
                songURL: song.assetURL,
                mediaType: song.mediaType
            )
        }
        return songInfo
    }
    
    func getListSongID( songName: String ) -> [String] {
        
        var songIDs: [String] = []
        
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: songName, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains)
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        
        for song in items {
            songIDs.append(song.persistentID.toString())
        }
        return songIDs
        
    }
    
    func getSongURL( songId: String ) -> URL? {
        //NumberFormatter().number(from: currentItem)!
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        let song: MPMediaItem?
        var url: NSURL = NSURL()
        if items.count >= 1 {
            song = items[items.count - 1]
            
            url = song?.value( forProperty: MPMediaItemPropertyAssetURL ) as? NSURL ?? NSURL()
        }
        return url as URL
    }
    
    func getAllMusic() -> [String] {
        
        var musics: [String] = []
        let albumsQuery: MPMediaQuery
        albumsQuery = MPMediaQuery.songs()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            for song in albumItems {
                musics.append( song.persistentID.toString())
            }
        }
        return musics
        
    }
    
}
