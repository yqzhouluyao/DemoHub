//
//  ViewController.swift
//  DemoHub
//
//  Created by zhouluyao on 3/16/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    let demoNames = ["Machine Learning Demo", "OpenGL Demo", "ARKit Demo"]
    
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo List"
        
        // Register the DemoTableViewCell class with the table view
        tableView.register(DemoTableViewCell.self, forCellReuseIdentifier: "DemoTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
        cell.demoNameLabel.text = demoNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
//           // Instantiate the MachineLearningViewController
//           let machineLearningVC = MachineLearningViewController()
//
//           // Push the view controller onto the navigation stack
//           navigationController?.pushViewController(machineLearningVC, animated: true)
//
        
        let arKitVC = ARKitVC()
        navigationController?.pushViewController(arKitVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


