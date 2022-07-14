//
//  ListMemoViewController.swift
//  SwipeMemo
//
//  Created by 優也田島 on 2022/06/30.
//

import UIKit

class ListMemoViewController: UIViewController {
    
    private var firstViewController: CreateMemoViewController!
    
    private var presenter: ListMemoPresenterInput!

    @IBOutlet weak var tableView: UITableView!
    
    func inject(presenter: ListMemoPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    private func setup () {
        firstViewController = storyboard!.instantiateViewController(withIdentifier: "FirstInput") as? CreateMemoViewController
        let model = CreateMemoModel()
        let helper = InputMemoHelper()
        firstViewController.inject(
            presenter: CreateMemoPresenter(
                view: firstViewController,
                model: model,
                helper: helper
            )
        )
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(createMemo(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.fillerRowHeight = 40
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func createMemo(_ sender: UIRefreshControl) {
        tableView.refreshControl!.endRefreshing()
        presenter.pullDown()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSegue" {
            let editViewController: EditMemoViewController = segue.destination as! EditMemoViewController
            let model = EditMemoModel()
            let helper = InputMemoHelper()
            let indexPath = self.tableView.indexPathForSelectedRow
            let sender = EditDataSender(
                prevScene: self,
                memo: presenter.memo(forRow: indexPath!.row)!
            )
            editViewController.inject(
                presenter: EditMemoPresenter(
                    view:editViewController,
                    model: model,
                    helper: helper,
                    sender: sender
                )
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if MemoError.exists() {
            let dialog = UIAlertController(title: "Error", message: MemoError.popErrorMessage(), preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
}

extension ListMemoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didTapDeleteButton(forRow: indexPath.row, indexPath: indexPath)
        }
    }
}

extension ListMemoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfMemos
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let memo = presenter.memo(forRow: indexPath.row) {
            cell.textLabel?.text = memo.text
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
}

extension ListMemoViewController: ListMemoPresenterOutput {
    
    func reloadMemo () {
        tableView.reloadData()
    }
    
    func deleteMemo(indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func transitionToCreate() {
        let transition:CATransition = CATransition()
        transition.duration = 0.1
        transition.type = .push
        transition.subtype = .fromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController!.setViewControllers([firstViewController], animated: false)
    }
}

extension ListMemoViewController: EditMemoDismissActionProtocol {
    func viewWillAppear() {
        presenter.viewWillAppear()
    }
    
    func viewDidAppear() {
        if MemoError.exists() {
            let dialog = UIAlertController(title: "Error", message: MemoError.popErrorMessage(), preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
}
