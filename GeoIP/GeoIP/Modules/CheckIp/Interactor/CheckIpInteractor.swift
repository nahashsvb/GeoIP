//
//  CheckIpInteractor.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation


class CheckIpInteractor: PresenterToInteractorProtocol {
    private let apiService: ApiService! = ApiService()

    var presenter: InteractorToPresenterProtocol?
    
    func fetchIpDetails(query: String) {
        let isValidQuery = InputValidator.isValid(value: query)
        
        if !isValidQuery {
            self.presenter?.ipDetailsFetchFailed(errorMessage: "Input query is not an IP address")
            return
        }
        
        self.apiService.delegate = self
        self.apiService.fetchIpDetails(query: query)
    }
    
}

extension CheckIpInteractor: ApiServiceDelegate {
    func didFinishWithError(_ errorMessage: String) {
        self.presenter?.ipDetailsFetchFailed(errorMessage: errorMessage)
    }
    
    func didFinishWithInfo(_ info: CheckIpModel) {
        self.presenter?.ipDetailsFetchedSuccess(model: info)
    }
}
