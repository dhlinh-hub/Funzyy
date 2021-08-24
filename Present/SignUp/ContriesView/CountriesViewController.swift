//
//  CountriesViewController.swift
//  Funzy
//
//  Created by Ishipo on 23/08/2021.
//

import UIKit

class CountriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data = [Country]()
    var backData : ((Country) -> Void)? = nil
    var seachData = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CountriesTableViewCell")
        
        setupUI()
        loadJson()
        seachData = data

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        let seachbar = UISearchBar()
        seachbar.sizeToFit()
        seachbar.placeholder = "Search Countries"
        seachbar.delegate = self
        navigationItem.titleView = seachbar
    }
    
    private func loadJson()  {
        if let url = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Country].self, from: data)
                self.data = jsonData
            } catch {
                print("error:\(error)")
            }
        }
    }
    
}
extension CountriesViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            seachData = data
            
        }else {
            seachData = data.filter( { mainData -> Bool in
                guard let text = searchBar.text else { return false}
                
                return mainData.name.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
    
    
}
extension CountriesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seachData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableViewCell", for: indexPath) as! CountriesTableViewCell
        cell.data = seachData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        backData?(seachData[indexPath.row])
    }
    
}
