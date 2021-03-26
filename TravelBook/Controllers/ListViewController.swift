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
    var addBtnClicked = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrPlaces = CoredataHelper.shared.fetchAllPlaces()
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    @objc func addButtonClicked(){
        addBtnClicked = true
        performSegue(withIdentifier: "GotoMap", sender: nil)
    }
    
    //MARK:- TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = arrPlaces[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addBtnClicked = false
        performSegue(withIdentifier: "GotoMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoMap" && addBtnClicked == false{
            let vc = segue.destination as! ViewController
            vc.selectedPlace = arrPlaces[listTableView.indexPathForSelectedRow!.row ]
        }
    }

}
