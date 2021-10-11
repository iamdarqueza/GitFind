//
//  SearchListViewModel.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/12/21.
//

import Foundation

// MARK: - Protocol for SearchListViewModel
protocol SearchListViewModelProtocol {
  var search: String { get set }
  var repositoryResponse: RepositoryResponse? { get set }
    
  func requestRepositoryList(
    onSuccess: @escaping SingleResult<Bool>,
    onError: @escaping SingleResult<String>
  )
}

final class SearchListViewModel: SearchListViewModelProtocol {
    
    var repositoryResponse: RepositoryResponse?
    
    var search: String = ""
    
    private var service: SearchListServiceProtocol

    private var queue = OperationQueue()

    init(task: SearchListServiceProtocol) {
      service = task
    }
    
    
    func requestRepositoryList(onSuccess: @escaping SingleResult<Bool>, onError: @escaping SingleResult<String>) {
        queue.cancelAllOperations()
        queue.qualityOfService = .background

        let block = BlockOperation { [weak self] in
          guard let s = self else { return }
          s.service.getSearchList(
            search: self?.search ?? "", onHandleCompletion: { [weak self] result, status, message in
              guard let s = self else { return }
                if status {
                  s.repositoryResponse = result
                  onSuccess(status)
                } else {
                  onError(message ?? "")
                }
            }
          )
        }
        
        queue.addOperation(block)
    }
    
    




  
}
