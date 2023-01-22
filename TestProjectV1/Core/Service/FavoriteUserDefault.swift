//
//  FavoriteUserDefault.swift
//  TestProjectV1
//
//  Created by Yeldos Marat on 05.01.2023.
//

import Foundation

protocol FavoriteUserDefaultProtocol {
    func isLiked(with id: String) -> Bool
    func markAsLiked(with photo: Photo)
    func unlike(with photo: Photo)
    var liked: [Photo] { get }
}

final class FavoriteUserDefault: FavoriteUserDefaultProtocol {
    
    static let shared = FavoriteUserDefault()
    static let key = "likedPhotos"
    static let notificationKey = NSNotification.Name("likedPhotosChanged")
    
    var liked: [Photo] {
        let likedPhotos: [Photo] = UserDefaults.standard.getObject(forKey: Self.key, castTo: [Photo].self) ?? []
        return likedPhotos
    }
    
    func isLiked(with id: String) -> Bool {
        var liked: [Photo] = []
        liked = UserDefaults.standard.getObject(forKey: Self.key, castTo: [Photo].self) ?? []
        
        for i in liked {
            if i.id == id {
                return true
            }
        }
        return false
    }
    
    func markAsLiked(with photo: Photo) {
        do {
            var liked: [Photo] = UserDefaults.standard.getObject(forKey: Self.key, castTo: [Photo].self) ?? []
            liked.append(photo)
            
            try UserDefaults.standard.setObject(liked, forKey: Self.key)
            NotificationCenter.default.post(name: Self.notificationKey, object: nil)
        } catch  {
            print("[DEBUG]: Cant mark as liked")
        }
    }
    
    func unlike(with photo: Photo) {
        do {
            var liked: [Photo] = UserDefaults.standard.getObject(forKey: Self.key, castTo: [Photo].self) ?? []
            liked.removeAll {
                $0.id == photo.id
            }
            
            try UserDefaults.standard.setObject(liked, forKey: Self.key)
            NotificationCenter.default.post(name: Self.notificationKey, object: nil)
        } catch {
            print("[DEBUG]: Cant mark as unlike")
        }
    }
}
