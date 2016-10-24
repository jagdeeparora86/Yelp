//
//  FilterViewController.swift
//  Yelp
//
//  Created by Singh, Jagdeep on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filterViewController(filterViewController: FilterViewController, applyFilter filters: YelpSearch)
}

class FilterViewController: UIViewController, SwitchCellDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searcButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var filterModel: Filters = Filters()
    struct sectionObject{
        var sectionName: String!
        var filterObject: [[String : String]]!
        var isExpanded: Bool!
        var identifier:  String!
        var numberOfRows: Int!
    }
    
    var sectionArray = [sectionObject]()
    var categories : [[String : String]]!
    var switchState = [Int : Bool]()
    var selectedDistance : Int!
    var selectedSort : Int = 0;
    var dealOn : Bool!
    var delegate:FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 43
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        categories =  filterModel.getCategories()
        setUpSections()
        tableView.reloadData()
    }
    
    func setUpSections(){
        
        sectionArray = [ sectionObject(sectionName: "Deals", filterObject: [["name" : "Offers Deals", "code": "deals_filter"]], isExpanded: false, identifier : "switchCell", numberOfRows: 1 ),
                         sectionObject(sectionName: "Distance", filterObject: [["name" : "Auto", "code": ""],
                                                                               ["name" : ".3 miles", "code": "482"],
                                                                               ["name" : "1 mile", "code": "1609"],
                                                                               ["name" : "5 miles", "code": "8047"],
                                                                               ["name" : "25 miles", "code": "40000"]], isExpanded: false, identifier : "distanceCell", numberOfRows: 1),
                         sectionObject(sectionName: "SortBy", filterObject: [["name" : "Best Match", "code": "0"],
                                                                             ["name" : "Distance", "code": "1"],
                                                                             ["name" : "Highest Rated", "code": "2"]], isExpanded: false, identifier: "sortCell", numberOfRows: 1),
                         sectionObject(sectionName: "Categories", filterObject: categories, isExpanded: false, identifier: "switchCell", numberOfRows: 3)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        YelpSearch.sharedInstance.deals = dealOn
        YelpSearch.sharedInstance.distance = selectedDistance
        YelpSearch.sharedInstance.sort = YelpSortMode(rawValue: selectedSort)
    
        var categoriesSelected = [String]()
        for(raw, isOn) in switchState {
            if isOn {
                categoriesSelected.append(categories[raw]["code"]!)
            }
        }
        if(categoriesSelected.count > 0){
            YelpSearch.sharedInstance.categories = categoriesSelected
        }
        dismiss(animated: true, completion: nil)
        
        delegate?.filterViewController(filterViewController: self, applyFilter: YelpSearch.sharedInstance)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = sectionArray[section]
        let filterObject = sectionArray[section].filterObject
        if(sectionData.isExpanded!){
            return filterObject!.count
        }
        else
        {
            return sectionData.numberOfRows
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let sectionData = sectionArray[indexPath.section]
        let sectionDataFilterObject = sectionData.filterObject
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionData.identifier, for: indexPath) as! SwitchCell
            let categoryName = sectionDataFilterObject?[indexPath.row]["name"]
            cell.categoryLabel.text = categoryName!
            cell.delegate = self
            cell.categorySwitch.isOn =  dealOn ?? false
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionData.identifier, for: indexPath)
            if (sectionArray[indexPath.section].isExpanded!) {
                cell.textLabel?.text = sectionDataFilterObject?[indexPath.row]["name"]
                
                if(indexPath.row == selectedDistanceRow){
                    cell.accessoryType = .checkmark
                }
                else{
                    cell.accessoryType = .none
                }
            }
            else{
                cell.textLabel?.text = sectionDataFilterObject![selectedDistanceRow]["name"]
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionData.identifier, for: indexPath)
            if (sectionArray[indexPath.section].isExpanded!) {
                cell.textLabel?.text = sectionDataFilterObject?[indexPath.row]["name"]
            
                if(indexPath.row == selectedSort){
                    cell.accessoryType = .checkmark
                }
                else{
                    cell.accessoryType = .none
                }
            }
            else{
                cell.textLabel?.text = sectionDataFilterObject![selectedSortRow]["name"]
                cell.accessoryType = .disclosureIndicator
                
            }
            return cell
            
        default:
            if (sectionArray[indexPath.section].isExpanded!){
                let cell = tableView.dequeueReusableCell(withIdentifier: sectionData.identifier, for: indexPath) as! SwitchCell
                let categoryName = sectionDataFilterObject?[indexPath.row]["name"]
                cell.categoryLabel.text = categoryName!
                cell.delegate = self
                cell.categorySwitch.isOn =  switchState[indexPath.row]  ?? false
                return cell
            }
            else {
                if(indexPath.row == sectionData.numberOfRows - 1){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "seeAllCell", for: indexPath)
                    cell.textLabel?.text = "See all"
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: sectionData.identifier, for: indexPath) as! SwitchCell
                    let categoryName = sectionDataFilterObject?[indexPath.row]["name"]
                    cell.categoryLabel.text = categoryName!
                    cell.delegate = self
                    cell.categorySwitch.isOn =  switchState[indexPath.row]  ?? false
                    return cell
                }
            }
        }
    }
    
    var selectedDistanceRow : Int = 0
    var selectedSortRow: Int = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionData = sectionArray[indexPath.section]
        let sectionDataFilterObject = sectionData.filterObject
        
        switch indexPath.section {
        case 0:
            return
        case 1:
            if(sectionArray[indexPath.section].isExpanded!) {
                selectedDistanceRow = indexPath.row
                selectedDistance = Int((sectionDataFilterObject![indexPath.row]["code"]!))
            }
            sectionArray[indexPath.section].isExpanded = !sectionArray[indexPath.section].isExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        case 2:
            if(sectionArray[indexPath.section].isExpanded!) {
                selectedSortRow = indexPath.row
                selectedSort = Int((sectionDataFilterObject![indexPath.row]["code"]!))!
            }
            sectionArray[indexPath.section].isExpanded = !sectionArray[indexPath.section].isExpanded
            tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
        case 3:
            if(!sectionArray[indexPath.section].isExpanded! && indexPath.row == sectionData.numberOfRows - 1) {
                sectionArray[indexPath.section].isExpanded = true;
                tableView.reloadSections(IndexSet(indexPath), with: UITableViewRowAnimation.fade)
            }
            return
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = UIColor.red
        let headerlabel = UILabel(frame: CGRect(x: 2, y: 2, width: 200, height: 40))
        headerlabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerlabel.textColor = UIColor.white
        headerlabel.text = sectionArray[section].sectionName
        headerView.addSubview(headerlabel)
        return headerView
    }
    
    func switchCell(switchCell: SwitchCell, didChanged value: Bool) {
        let indexpath = tableView.indexPath(for: switchCell)!
        switch indexpath.section {
        case 0:
            dealOn = value
        default:
            switchState[indexpath.row] = value
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
