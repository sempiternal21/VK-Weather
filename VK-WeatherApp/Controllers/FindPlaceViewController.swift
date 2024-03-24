//
//  FindViewController.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import UIKit
import MapKit

class FindPlaceViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = Strings.typePlace
        
        return searchBar
    }()
    
    private var searchResultsTable: UITableView = {
        let searchResultsTable = UITableView()
        searchResultsTable.translatesAutoresizingMaskIntoConstraints = false
        
        return searchResultsTable
    }()
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchBar)
        view.addSubview(searchResultsTable)
        
        searchCompleter.delegate = self
        searchBar.delegate = self
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            searchResultsTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
}

extension FindPlaceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
}

extension FindPlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }

            let place: String = response!.mapItems[0].placemark.title ?? response!.mapItems[0].placemark.subtitle ?? name
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            let findModelObject = FindModel(lat: lat.description, lon: lon.description, place: place)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "closeChangeLocationVC"), object: findModelObject)
            
            self.dismiss(animated: true)
        }
    }
}
