//
//  CheckIpViewController.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import UIKit

class CheckIpViewController: UIViewController {
    
    var presentor:ViewToPresenterProtocol?
    var checkIpModel: CheckIpModel?
    
    private let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Check IP"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        
        let cellNib = UINib(nibName: CheckIpTableViewCell.nibName(), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: CheckIpTableViewCell.reuseIdentifier())
        
        self.setupSearchController()
        
        presentor?.startFetchingIpDetails(query: "8.8.8.8888")
    }
    
    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter IP"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension CheckIpViewController:PresenterToViewProtocol{
    
    func showIpDetails(model: CheckIpModel) {
        self.errorLabel.isHidden = true
        self.tableView.isHidden = false
        self.checkIpModel = model
        self.tableView.reloadData()
    }
    
    func showError(errorMessage: String) {
        self.errorLabel.isHidden = false
        self.tableView.isHidden = true
        self.errorLabel.text = errorMessage
    }
    
    func showLoadingIndicator() {
        self.errorLabel.isHidden = true
        self.tableView.isHidden = true
        self.activityIndicatorView.alpha = 1.0
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    func hideLoadingIndicator() {
        self.activityIndicatorView.stopAnimating()
    }
    
}

extension CheckIpViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkIpModel?.arrayRepresentation().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CheckIpTableViewCell.reuseIdentifier(), for: indexPath) as! CheckIpTableViewCell
        let data = checkIpModel?.arrayRepresentation()[indexPath.row]
       
        if let key = data?.keys.first {
            cell.id.text = key
        }
        
        if let value = data?.values.first {
            cell.title.text = value
        }
        
        return cell
    }
    
}

extension CheckIpViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }

        presentor?.startFetchingIpDetails(query: text)
    }
}

class CheckIpTableViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func prepareForReuse() {
        self.id.text = ""
        self.title.text = ""
    }
}

