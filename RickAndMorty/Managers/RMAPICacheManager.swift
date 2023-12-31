//
//  RMAPIChaceManager.swift
//  RickAndMorty
//
//  Created by Ricky Silitonga on 31/12/23.
//

import Foundation

/// Manages in memory session scope API cache
final class RMAPICacheManager {
    
    // Cache map
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    // MARK: - init
    init() {
        setupCache()
    }
    
    // MARK: - Public
    /// get cached api response
    /// - Parameters:
    ///   - endpoint: endpoint of cache data
    ///   - url: url string
    /// - Returns: nulable data in cache
    public func cacheResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint],
              let url = url else {
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    /// set api response cache
    /// - Parameters:
    ///   - endpoint: RMEndpont to cache for
    ///   - url: url string
    ///   - data: data to  set in cache
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint],
              let url = url else {
            return
        }
        
        let key = url.absoluteString as NSString
        let dataToCache = data as NSData
        targetCache.setObject(dataToCache as NSData, forKey: key)
    }
    
    
    // MARK: - Private
    
    /// setup cache dictionary
    private func setupCache() {
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
