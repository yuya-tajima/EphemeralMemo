//
//  ViewController.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/06/30.
//

import UIKit

class ListViewController: UIViewController {

    let fruits = ["apple", "orange", "melon", "banana", "pineapple"]

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let doubleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.doubleTapped(_:))
        )
        doubleTapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGesture)

        tableView.dataSource = self
        tableView.delegate   = self
        tableView.fillerRowHeight = UITableView.automaticDimension
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appear")
        tableView.reloadData()
    }

    @objc func doubleTapped(_ sender: UISwipeGestureRecognizer) {
        let firstViewController  = storyboard!.instantiateViewController(withIdentifier: "FirstInput")
        self.navigationController?.pushViewController(firstViewController, animated: true)
    }
}

extension ListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = fruits[indexPath.row]

        return cell
    }
}
