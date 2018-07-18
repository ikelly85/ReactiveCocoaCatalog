//
//  CheckoutViewController.swift
//  ReactiveCocoaCatalog
//
//  Created by kelly on 2018. 7. 18..
//  Copyright © 2018년 Yasuhiro Inami. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

class CheckoutViewController: UIViewController, StoryboardSceneProvider
{
    @IBOutlet var tableView: UITableView?
    static let storyboardScene = StoryboardScene<CheckoutViewController>(name: "Checkout")

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let xib = UINib(nibName: "CheckoutCell", bundle: nil)
        tableView?.register(xib, forCellReuseIdentifier: "CheckoutCell")
    }
}

extension CheckoutViewController: UITableViewDelegate {

}

extension CheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell") as? CheckoutCell {

            return cell
        }

        return UITableViewCell()
    }


}
