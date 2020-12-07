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
    
    func fetchIpDetails(query: String) -> Bool {
        let isValidQuery = InputIpValidator.isValid(value: query)
        
        if !isValidQuery {
            self.presenter?.ipDetailsFetchFailed(errorMessage: "Input query is not an IP address")
            return false
        }
        
        self.apiService.delegate = self
        self.apiService.fetchIpDetails(query: query)
        self.presenter?.showLoadingIndicator()
        return true
    }
    
}

extension CheckIpInteractor: ApiServiceDelegate {
    func didFinishWithError(_ errorMessage: String) {
        self.presenter?.hideLoadingIndicator()
        self.presenter?.ipDetailsFetchFailed(errorMessage: errorMessage)
    }
    
    func didFinishWithInfo(_ info: CheckIpModel) {
        self.presenter?.hideLoadingIndicator()
        self.presenter?.ipDetailsFetchedSuccess(model: info)
    }
}
