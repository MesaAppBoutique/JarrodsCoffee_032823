//
//  OrderConfirmationViewController.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    @IBOutlet weak var orderConfirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // message to the user confirming order placed
        orderConfirmationLabel.text = "Thank you for your order!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


