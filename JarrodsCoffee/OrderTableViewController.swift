//
//  OrderTableViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {

    // list of ordered items
    var menuItems = [MenuItem]()
    
    // alert with order total for user confirmation
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        // calculate the total order cost
        let orderTotal = menuItems.reduce(0.00) { (result, menuItem) -> Double in
            return result + (menuItem.price[0])
        }
    
        // format the order total price
        let formattedOrder = String(format: "$%.2f", orderTotal)
        
        // prepare an alert for the user
        let alert = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedOrder)",
            preferredStyle: .alert
        )
        
        // add upload order action on submit
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
            self.uploadOrder()
        })
        
        // add cancel on dismiss
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // present the alert for the user about order submission
        present(alert, animated: true, completion: nil)
    }
    
    // go back to order list once dismiss button presed
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        // check that we indeed dismissing the confirmation screen
        if segue.identifier == "DismissConfirmation" {
            // clear order menu items
            menuItems.removeAll()
            
            // reload the table to show empty list
            tableView.reloadData()
            
            // update the number of items in the order list
            updateBadgeNumber()
        }
    }
    
    //call submitOrder() from MenuController
    func uploadOrder() {
        // create an array menu IDs selected for the order
        let menuIds = menuItems.map { $0.id }
        
        MenuController.shared.submitOrder(menuIds: menuIds) {_ in
            DispatchQueue.main.async {
            // perform the segue to confirmation screen
            self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fit the price labels
        fitDetailLabels()
    }
    
    override func viewWillLayoutSubviews() {
        // fit the price labels
        fitDetailLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // reuse the order list prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        
        // configure the cell with menu list data
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // configure the cell with order list data
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        // get the needed menu item for corresponding table row
        let menuItem = menuItems[indexPath.row]
        
        // name of the item
        cell.textLabel?.text = menuItem.name
        
        // price along with currency symbol
        cell.detailTextLabel?.text = String(format: "%.2f", menuItem.price[indexPath.item])

        // fetch the image from json data
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            // check that the image was fetched successfully
            guard let image = image else { return }
            
            // return to main thread after the network request in background
            DispatchQueue.main.async {
                // get the current index path
                guard let currentIndexPath = self.tableView.indexPath(for: cell) else { return }
                
                // check if the cell was not yet recycled
                guard currentIndexPath == indexPath else { return }
                
                // set the thumbnail image
                cell.imageView?.image = image
                
                // fit the image to the cell
                self.fitImage(in: cell)
            }
        }
    }
    
    // adjust the cell height to improve presentation
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // enable editing/deleting menu items on the order table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // add support for editing the order table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the item from the order list
            menuItems.remove(at: indexPath.row)
            
            // Remove the row from the table
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Update the number of items on the badge
            updateBadgeNumber()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fit the price detail label in cell
        fitDetailLabel(in: cell)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // called to add menu item
    func added(menuItem: MenuItem) {
        // append the menu item to the menuItems array
        menuItems.append(menuItem)
        
        // get the total number of menu items
        let count = menuItems.count
        
        // calculate index path for the last row
        let indexPath = IndexPath(row: count - 1, section: 0)
        
        // insert the menu item row to the end of the order table
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // update the badge with the number of items in the order
        updateBadgeNumber()
    }
    
    // update badge in tab for items ordered number
    func updateBadgeNumber() {
        // get the number of items in the order
        let badgeValue = 0 < menuItems.count ? "\(menuItems.count)" : nil
        
        // assign the badge value to the order tab
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
}
   
