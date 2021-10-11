//
//  HomeViewController.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/11/21.
//

import UIKit
import Connectivity
import Loaf
import Combine

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var searchButton: DesignableButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let connectivity = Connectivity()
    private var fromOffline = false
    private var isOffline = false
    private var cancellable: AnyCancellable?
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.showSearchResult.rawValue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConnectivity()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureConnectivityNotifier()
        searchTextField.text = ""
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showSearchResult.rawValue {
              let destination = segue.destination as! SearchViewController
            guard let searchText = searchTextField.text, !searchText.isEmpty else {
                presentDismissableAlertController(title: "Oops!", message: "Textfield is empty")
                return }
            destination.bindVM(search: searchText)
        }
    }
    
    // MARK: - Configure internet connection checker
    private func configureConnectivity() {
        connectivity.checkConnectivity { [weak self] connectivity in
          guard let s = self else { return }

          switch connectivity.status {
          case .connected, .connectedViaWiFi, .connectedViaCellular:
            break
          case .connectedViaWiFiWithoutInternet, .notConnected, .connectedViaCellularWithoutInternet:
            Loaf("You have no internet connection", state: .error, location: .top, sender: s).show()
          case .determining:
            break
          }
        }
    }
    
    // MARK: - Configure internet connection notifier
    private func configureConnectivityNotifier() {
      let publisher = Connectivity.Publisher()
      cancellable = publisher.receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        .sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] connectivity in
          guard let s = self else {
            return
          }
          s.updateConnectionStatus(connectivity.status)
        })
    }
    
    // MARK: - Check connection and display online or offline
    private func updateConnectionStatus(_ status: Connectivity.Status) {
      switch status {
      case .connectedViaWiFi, .connectedViaCellular, .connected:
        isOffline = false
        if fromOffline {
            fromOffline = false
            Loaf("You have an active internet connection", state: .success, location: .top, sender: self).show()
        }
      case .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet, .notConnected:
        isOffline = true
        fromOffline = true
        Loaf("You have no internet connection", state: .error, location: .top, sender: self).show()
      case .determining:
        break
      }
    }
    

}
