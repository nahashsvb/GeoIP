//
//  ApiService.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation
import Alamofire
import ObjectMapper

protocol ApiServiceProtocol: class {
    var ipDetails: CheckIpModel? { get set }
    var error: ApiError? { get set }
    
    func fetchIpDetails(query: String)
}

protocol ApiServiceDelegate: class {
    func didFinishWithError(_ errorMessage: String)
    func didFinishWithInfo(_ info: CheckIpModel)
}

enum ApiError: Error {
    case apiError
    case invalidQuery
    case noInternet
    case unknownError
    
    func errorMessage(apiError: String? = nil) -> String {
        switch self {
            case .apiError:
                if let error = apiError {
                    return "API error: " + error
                }
                return "Unknown Error"
            case .noInternet:
                return "No Internet"
            case .invalidQuery:
                return "Invalid Search Query"
            case .unknownError:
                return "Unknown Error"
        }
    }
}

class ApiService {
    weak var delegate: ApiServiceDelegate?
    
    var ipDetails: CheckIpModel?
    var error: ApiError?
    
    private var dataTask: URLSessionDataTask?
    
    func fetchIpDetails(query: String)  {
        if !Reachability.isConnectedToNetwork() {
            self.handleError(errorType: .noInternet, errorMessage: nil);
            return
        }

        let fetchURL = String(format: "%@%@", API_CHECK_IP, query)
        guard let sourcesURL = URL(string: fetchURL) else {
            self.handleError(errorType: .invalidQuery, errorMessage: nil);
            return
        }
        
        AF.request(sourcesURL).responseJSON { [weak self] response in
            if(response.response?.statusCode == 200 ) {
                do {
                    let json = try response.result.get() as AnyObject?
                    
                    let ipDetails = Mapper<CheckIpModel>().map(JSON: json as! [String : Any])
                    self?.ipDetails = ipDetails
                    
                    if let status = ipDetails?.status, let details = ipDetails {
                        if status == "fail" {
                            self?.handleError(errorType: .apiError, errorMessage: details.errorMessage);
                        }
                        else {
                            DispatchQueue.main.async {  [weak self] in
                                self?.delegate?.didFinishWithInfo(details)
                            }
                        }
                    }
                }
                catch {
                    self?.handleError(errorType: .unknownError, errorMessage: nil);
                }
            }
            else {
                self?.handleError(errorType: .unknownError, errorMessage: nil);
            }
        }
    }
    
    private func handleError(errorType: ApiError, errorMessage: String?) {
        self.error = errorType
        DispatchQueue.main.async {  [weak self] in
            self?.delegate?.didFinishWithError(self?.error?.errorMessage(apiError: errorMessage) ?? "Unknown Error")
        }
    }
}
