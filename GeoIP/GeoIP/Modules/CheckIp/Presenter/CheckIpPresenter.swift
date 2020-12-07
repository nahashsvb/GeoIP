//
//  CheckIpPresenter.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation
import UIKit

class CheckIpPresenter:ViewToPresenterProtocol {
    
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func startFetchingIpDetails(query: String) {
        _ = interactor?.fetchIpDetails(query: query)
    }
}

extension CheckIpPresenter: InteractorToPresenterProtocol {
    
    func ipDetailsFetchedSuccess(model: CheckIpModel) {
        view?.showIpDetails(model: model)
    }
    func ipDetailsFetchFailed(errorMessage: String) {
        view?.showError(errorMessage: errorMessage)
    }
    
    func showLoadingIndicator() {
        view?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        view?.hideLoadingIndicator()
    }
}

