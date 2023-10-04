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
        var list: [String] = []
        let albumItems: [MPMediaItemCollection] = query.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            for song in albumItems {
                list.append("\(String(describing: song.playbackDuration.timeFormat()))")
            }
        }
        if items.count >= 1 {
            let song = items[items.count - 1]
            let time = list[items.count - 1]
            songInfo = MusicModel(
                songId: song.persistentID as NSNumber,
                albumTitle: song.albumTitle,
                artistName: song.artist,
                songTitle: song.title,
                artWork: song.artwork,
                songURL: song.assetURL,
<<<<<<< HEAD
                mediaType: song.mediaType, time: time
=======
                mediaType: song.mediaType,
                duration: audioDuration(time: song.playbackDuration)
>>>>>>> main
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
    
    func getSongTime(songId: String ) -> String? {
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        let song: MPMediaItem?
        var url = ""
        if items.count >= 1 {
            song = items[items.count - 1]
            
            url = song?.bookmarkTime.timeFormat() ?? ""
        }
        return url
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
    
    func getTimeMusic() -> [String] {
        var musics: [String] = []
        let albumsQuery: MPMediaQuery
        albumsQuery = MPMediaQuery.songs()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            for song in albumItems {
                musics.append("\(String(describing: song.bookmarkTime.timeFormat()))")
            }
        }
        return musics
    }
    
    func getListTimeID(id: String ) -> String {
        
        var songIDs: String?
        
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains)
        
        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        
        for song in items {
            songIDs?.append("\(String(describing: song.bookmarkTime.timeFormat()))")
        }
        return songIDs ?? ""
        
    }
    
    func getTimeMusicAll() -> [String] {
        var musics: [String] = []
        let albumsQuery: MPMediaQuery
        albumsQuery = MPMediaQuery.songs()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            for song in albumItems {
                musics.append("\(String(describing: song.playbackDuration.timeFormat()))")
            }
        }
        return musics
    }
    
    
    func getAllArtist() -> [String] {
        var artists: [String] = []
        let albumsQuery: MPMediaQuery
        albumsQuery = MPMediaQuery.artists()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            // var song: MPMediaItem
            for song in albumItems {
                artists.append( song.persistentID.toString())
            }
        }
        return artists
    }
    
    func getAllPlaylist() -> [String] {
        
        var playlists: [String] = []
        let playlistQuery: MPMediaQuery
        playlistQuery = MPMediaQuery.playlists()
        let playlistItems: [MPMediaItemCollection] = playlistQuery.collections! as [MPMediaItemCollection]
        for playlist in playlistItems {
            playlists.append(String(playlist.count))
        }
        return playlists
    }
    
    func getTitlePlaylist() -> [String] {
        
        var playlists: [String] = []
        let playlistQuery: MPMediaQuery
        playlistQuery = MPMediaQuery.playlists()
        let playlistItems: [MPMediaItemCollection] = playlistQuery.collections! as [MPMediaItemCollection]
        for playlist in playlistItems {
            playlists.append(playlist.value(forProperty: MPMediaPlaylistPropertyName) as! String)
        }
        return playlists
    }
    
    func getAllAlbum() -> [String] {
        
        var albums: [String] = []
        let albumsQuery: MPMediaQuery
        albumsQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            for song in albumItems {
                albums.append( song.persistentID.toString())
            }
        }
        return albums
    }
    func audioDuration(time: Double) -> String {
        let s: Int = Int(time) % 60
        let m: Int = Int(time) / 60
        let formattedDuration = String(format: "%02d:%02d", m, s)
        return formattedDuration
    }
    
    
}
