//
//  AboutCanadaViewModel.swift
//  AboutCanada
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import Foundation

protocol AboutCanadaViewModelDelegate: class {
    func isLoading()
    func didFinishLoading()
    func shouldDisplayErrorDialog(title: String, message: String)
}

final class AboutCanadaViewModel {
    
    public weak var delegate: AboutCanadaViewModelDelegate?
    public var facts: Facts? = nil
    
    internal func viewDidLoad() {
        fetchAboutCanadaFacts()
    }
    
    internal func fetchAboutCanadaFacts() {
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
    
    private func handleError(title: String, message: String) {
        DispatchQueue.main.async {
            self.delegate?.shouldDisplayErrorDialog(title: title, message: message)
        }
    }
}
