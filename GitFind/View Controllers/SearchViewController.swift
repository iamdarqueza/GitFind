//
//  SearchViewController.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/11/21.
//

import UIKit
import Combine


class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchText: String?
    
    private var cancellable: AnyCancellable?
    private var fromOffline = false
    private var isOffline = false
    private var viewModel = SearchListViewModel(task: SearchListService())
    private var queue = OperationQueue()
    private var isSearching = false
    private var searchIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        getSearchList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func bindVM(search: String) {
        viewModel.search = search
    }
    
    
    // MARK: - Configure table view
    private func configureTableView() {
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(cell: SearchTableViewCell.self)
      tableView.tableFooterView = UIView()
      tableView.rowHeight = 120
    }
    
    
    // MARK: - Configure search bar
    private func configureSearchBar() {
        searchBar.text = viewModel.search
        searchBar.delegate = self
    }

    
    // MARK: - Get search list
    private func getSearchList() {
      viewModel.requestRepositoryList(
        onSuccess: onHandleSuccess(),
        onError: onHandleError()
      )
    }

    
    
    // MARK: - Success Get search list
    private func onHandleSuccess() -> SingleResult<Bool> {
      return { [weak self] status in
        guard let s = self, status else { return }
        DispatchQueue.main.async {
          s.tableView.reloadData()
        }
      }
    }

    // MARK: - Display error encountered after fetch
    private func onHandleError() -> SingleResult<String> {
      return { [weak self] message in
        guard let s = self else { return }
          s.presentDismissableAlertController(title: "Oops!", message: message)
      }
    }


}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositoryResponse?.items?.count == 0 ? 10 : viewModel.repositoryResponse?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchTableViewCell.rawValue, for: indexPath) as! SearchTableViewCell

        if viewModel.repositoryResponse?.items?.count != 0 {
          cell.hideSkeletonView()
            let search = viewModel.repositoryResponse?.items?[indexPath.row]
            cell.configure(withSearch: search!, index: indexPath.row)
        } else {
          cell.showAnimatedGradientSkeleton()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchIndex = indexPath.row
        guard let index = searchIndex, let url = viewModel.repositoryResponse?.items?[index].html_url else { return }
        
        if let url = URL(string: "\(url)") {
            UIApplication.shared.open(url)
        }
    }

}

extension SearchViewController: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                if let text = searchBar.text, !text.isEmpty {
                  isSearching = true
                    viewModel.search = text
                    getSearchList()
                } else {
                  isSearching = false
                }
                tableView.reloadData()
    }
    

}
