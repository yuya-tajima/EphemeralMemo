//
//  ListViewController.swift
//  EphemeralMemo
//
//  Created by 優也田島 on 2022/06/30.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    let realm = try! Realm()
    
    var memoArray = try! Realm().objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    
    var firstViewController: UIViewController!

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstViewController = storyboard!.instantiateViewController(withIdentifier: "FirstInput")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(addMemo(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.fillerRowHeight = UITableView.automaticDimension
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func addMemo(_ sender: UIRefreshControl) {
        tableView.refreshControl!.endRefreshing()
        
        let transition:CATransition = CATransition()
        transition.duration = 0.1
        transition.type = .push
        transition.subtype = .fromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController!.pushViewController(firstViewController, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editViewController:EditViewController = segue.destination as! EditViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            editViewController.memo = self.memoArray[indexPath!.row]
            editViewController.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        print("apper")
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            try! realm.write {
                self.realm.delete(self.memoArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let memo = memoArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = memo.contents
        cell.textLabel?.numberOfLines = 0

        return cell
    }
}

extension ListViewController: DismissActionProtocol {
    func viewWillDismiss() {
        tableView.reloadData()
    }
}
