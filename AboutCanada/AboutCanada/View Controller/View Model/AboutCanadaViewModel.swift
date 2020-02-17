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
    
    // MARK: - Public variables
    public weak var delegate: AboutCanadaViewModelDelegate?
    public var facts: Facts? = nil
    public var filteredRows: [Row]?
    
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
                
                /// Filtering non nill object based on the title value
                if let rows = self.facts?.rows {
                    self.filteredRows = rows.filter { $0.title != nil }
                }
            case .failure(let error):
                switch error {
                case .dataReturnedNil:
                    self.handleError(title: NSLocalizedString("jsonDataNil",
                                                              comment: "json Data Nil"),
                                     message: NSLocalizedString("pleaseTryAgain",
                                                                comment: "please Try Again"))
                case .errorParsingJSON:
                    self.handleError(title: NSLocalizedString("jsonParsingError",
                                                              comment: "json Parsing Error"),
                                     message: NSLocalizedString("pleaseTryAgain",
                                                                comment: "please Try Again"))
                    
                default:
                    self.handleError(title: NSLocalizedString("connectionError",
                                                              comment: "connection Error"),
                                     message: NSLocalizedString("pleaseTryAgain",
                                                                comment: "please Try Again"))
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
