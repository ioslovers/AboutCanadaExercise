//
//  Network.swift
//  AboutCanadaExercise
//
//  Created by Ashish Tripathi on 15/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import Foundation
/// Result enum is a generic for any type of value
/// with success and failure case
public enum Result<T> {
    case success(T)
    case failure(Error)
}

final class Networking: NSObject {
    
    // MARK: - Private functions
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - Public functions
    
    /// fetchFactsAboutCanada function will fetch the facts about Canada and returns
    /// Result<Facts> as completion handler
    public static func fetchFactsAboutCanada(shouldFail: Bool = false, completion: @escaping (Result<Facts>) -> Void) {
        var urlString: String?
        if shouldFail {
            urlString = SessionEndPoints.test.rawValue
        } else {
            urlString = SessionEndPoints.prod.rawValue
        }
        
        guard let mainUrlString = urlString,  let url = URL(string: mainUrlString) else { return }
        
        Networking.getData(url: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8),
                error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(Facts.self, from: utf8Data)
                completion(.success(json))
            } catch let error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    public static func downloadImage(url: URL,
                                     completion: @escaping (Result<Data>) -> Void) {
        Networking.getData(url: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }
    }
}

