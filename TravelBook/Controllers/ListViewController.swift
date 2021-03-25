//
//  ListViewController.swift
//  TravelBook
//
//  Created by MD Tanvir Alam on 25/3/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    var arrPlaces = [Places]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        listTableView.delegate = self
        listTableView.dataSource = self
        arrPlaces = CoredataHelper.shared.fetchAllPlaces()
        
    }
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "GotoMap", sender: nil)
    }
    
    //MARK:- TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = arrPlaces[indexPath.row].title
        return cell
    }

}
