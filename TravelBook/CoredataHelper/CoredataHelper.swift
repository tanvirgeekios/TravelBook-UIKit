//
//  CoredataHelper.swift
//  TravelBook
//
//  Created by MD Tanvir Alam on 25/3/21.
//

import Foundation
import UIKit
import CoreData

class CoredataHelper{
    static let shared = CoredataHelper()
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveNewPlace(place:PlacesCoreDataModel){
        let newPlace = Places(context: context)
        newPlace.title = place.title
        newPlace.subtitle = place.subtitle
        newPlace.lattitude = place.latitude
        newPlace.longitude = place.longitude
        
        do{
            try context.save()
            print("Succes Saving Place")
        }catch{
            print("Error Saving Place: \(error)")
        }
    }
    
    func fetchAllPlaces()->[Places]{
        var arrPlaces = [Places]()
        let request = NSFetchRequest<NSManagedObject>(entityName: "Places")
        do{
            arrPlaces = try context.fetch(request) as! [Places]
            print("Fetching Data success")
        }catch{
            print("Error fetching Data")
        }
        return arrPlaces
    }
}
