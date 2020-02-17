//
//  AboutCanadaViewModel.swift
//  AboutCanada
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import Foundation

// MARK: - AboutCanadaViewModelDelegate Protocol

protocol AboutCanadaViewModelDelegate: class {
    func isLoading()
    func didFinishLoading()
    func shouldDisplayErrorDialog(title: String, message: String)
}

final class AboutCanadaViewModel {
    
    // MARK: - Public Protocol
    public weak var delegate: AboutCanadaViewModelDelegate?
    public var facts: Facts? = nil
    
    // MARK: - Internal functions
    internal func viewDidLoad() {
        fetchAboutCanadaFacts()
    }
    
    /// Calling a network request to get the Facts about Canada
    internal func fetchAboutCanadaFacts() {
        /// Showing activity loader
        delegate?.isLoading()
        Networking.fetchFactsAboutCanada { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let factsData):
                self.facts = factsData
            case .failure(let error):
                switch error {
                case .dataReturnedNil:
                    self.handleError(title: "Json data is nil", message: "please try again")
                case .errorParsingJSON:
                    self.handleError(title: "Json parsing error", message: "please try again..")
                    
                default:
                    self.handleError(title: "Connection Error", message: "please try again..")
                }
                self.facts = nil
            }
            DispatchQueue.main.async {
                self.delegate?.didFinishLoading()
            }
        }
    }
    
    /// showing error message if service failed
    private func handleError(title: String, message: String) {
        DispatchQueue.main.async {
            self.delegate?.shouldDisplayErrorDialog(title: title, message: message)
        }
    }
}
