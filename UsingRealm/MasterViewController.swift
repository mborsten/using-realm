//
//  MasterViewController.swift
//  UsingRealm
//
//  Created by Marcel Borsten on 30-04-17.
//  Copyright © 2017 Impart IT. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    let api = RWSApi()
    let realm = try! Realm()

    var detailViewController: DetailViewController? = nil
    var objects: Results<Location>!

    var token: NotificationToken?


    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(MasterViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)

        objects = realm.objects(Location.self).sorted(byKeyPath: "name", ascending: false)

        token = objects.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in

            guard let tableView = self?.tableView else { return }

            switch changes {

            case .initial:
                tableView.reloadData()

            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()

                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)

                tableView.endUpdates()

            case .error(let error):
                print("\(error)")
            }
        }

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    func refresh() {
        api.syncWaves()
        refreshControl?.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LocationTableViewCell

        let object = objects[indexPath.row]

        let numberFormatter = LengthFormatter()
        numberFormatter.unitStyle = .medium

        var heightString = "-"

        if object.latestValue < 10000 {
            heightString = numberFormatter.string(fromValue: object.latestValue, unit: .centimeter)
        }

        cell.waveHeightLabel.text = heightString
        cell.locationNameLabel.text = object.name

        return cell
    }


}

