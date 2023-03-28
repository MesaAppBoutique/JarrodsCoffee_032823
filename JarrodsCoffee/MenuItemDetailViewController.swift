//
//  MenuItemDetailViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit

class DropdownCell: UITableViewCell {
    
}
    
    class MenuItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
        // MenuItem selected from MenuTableViewController
        var menuItem: MenuItem!
        
        // delegate to add item to order
        var delegate: AddToOrderDelegate?
                
        let transparentView = UIView()
        
        let tableView = UITableView()
        
        var selectedButton = UIButton()
        
        var dataSource = [String]()
        
        @IBOutlet weak var titleLabel: UILabel!
        
        @IBOutlet weak var imageView: UIImageView!
        
        @IBOutlet weak var optionButton: UIButton!
        
        @IBOutlet weak var addToOrderButton: UIButton!
        
        // bounce animation after addToOrder buttons pressed
        @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
            UIView.animate(withDuration: 0.3) {
                self.addToOrderButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            delegate?.added(menuItem: menuItem)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(DropdownCell.self, forCellReuseIdentifier: "Cell")
            // update the screen with menuItem values
            updateUI()
            populateOptionModelArray()
            // setup the delegate
            setupDelegate()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return self.optionModelArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text =  self.dataSource[indexPath.row]
            
            return cell
        }
        
        var optionModelArray: [OptionModel] = [OptionModel]()
        
        // update the screen with menuItem values
        func updateUI() {
            titleLabel.text = menuItem.name
            
            optionButton.layer.cornerRadius = 5
            
            addToOrderButton.layer.cornerRadius = 5
            
            // get the image for the menu item
            MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        func populateOptionModelArray(){
            let optionModel = OptionModel(sizeOption: menuItem.size, priceOption: menuItem.price)
            self.optionModelArray.append(optionModel)
        }
        
        func addTransparentView(frames: CGRect) {
            let window = UIApplication.shared.keyWindow
            transparentView.frame = window?.frame ?? self.view.frame
            self.view.addSubview(transparentView)
            
            tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.view.addSubview(tableView)
            tableView.layer.cornerRadius = 5
            
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            tableView.reloadData()
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
            transparentView.addGestureRecognizer(tapgesture)
            transparentView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0.5
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
            }, completion: nil)
        }
        
        @objc func removeTransparentView() {
            let frames = selectedButton.frame
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0
                self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            }, completion: nil)
        }
        
        @IBAction func optionButton(_ sender: Any) {
            dataSource = menuItem.size
            populateOptionModelArray()
            selectedButton = optionButton
            addTransparentView(frames: optionButton.frame)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedButton.setTitle(String(format: "%.2f", menuItem.price[indexPath.row]), for: .normal)
            removeTransparentView()
        }
        
        // find order table view controller
        func setupDelegate() {
            if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
               let orderTableViewController = navController.viewControllers.first as? OrderTableViewController {
                delegate = orderTableViewController
            }
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






