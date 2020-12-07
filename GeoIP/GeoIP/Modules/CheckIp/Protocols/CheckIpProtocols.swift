//
//  CheckIpProtocols.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: class {
    
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func startFetchingIpDetails(query: String)
}

protocol PresenterToViewProtocol: class {
    func showIpDetails(model: CheckIpModel)
    func showError(errorMessage: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

protocol PresenterToRouterProtocol: class {
    static func createModule()-> CheckIpViewController
}

protocol PresenterToInteractorProtocol: class {
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchIpDetails(query: String) -> Bool
}

protocol InteractorToPresenterProtocol: class {
    func ipDetailsFetchedSuccess(model: CheckIpModel)
    func ipDetailsFetchFailed(errorMessage: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
