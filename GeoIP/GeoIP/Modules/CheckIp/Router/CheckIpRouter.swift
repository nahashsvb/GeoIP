//
//  CheckIpRouter.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation
import UIKit

class CheckIpRouter:PresenterToRouterProtocol{
    
    static func createModule() -> CheckIpViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "CheckIpViewController") as! CheckIpViewController
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = CheckIpPresenter()
        let interactor: PresenterToInteractorProtocol = CheckIpInteractor()
        let router:PresenterToRouterProtocol = CheckIpRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
