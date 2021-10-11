//
//  SearchListService.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/12/21.
//

import Foundation

// MARK: - Protocol for SearchListService
protocol SearchListServiceProtocol {
  func getSearchList(search: String, onHandleCompletion: @escaping ResultClosure<RepositoryResponse>)
}

// MARK: - SearchListService API request
final class SearchListService: BaseService, SearchListServiceProtocol {
  func getSearchList(search: String, onHandleCompletion: @escaping ResultClosure<RepositoryResponse>) {
    let url: URL! = URL(string: "https://api.github.com/search/repositories?q=\(search)")
    var uriRequest = URLRequest(url: url)
    uriRequest.httpMethod = RestVerbs.GET.rawValue
    
    consumeAPI(RepositoryResponse.self, request: uriRequest, completion: { result, err in
        guard err == nil else {
          return onHandleCompletion(nil, false, err?.localizedDescription)
        }
        onHandleCompletion(result, true, err?.localizedDescription)
      }
    )
  }
}
