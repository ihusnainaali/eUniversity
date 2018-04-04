//
//  NewsViewController.swift
//  eUniversity
//
//  Created by Damir Ramic on 17/01/2018.
//  Copyright © 2018 Damir Ramich. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let refreshController = RefreshContol()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsController.sharedController.delegate = self
        NewsController.sharedController.getNews()
        SylabussesController.sharedController.getSyllabusses()
        self.tabBarItem.image = #imageLiteral(resourceName: "home")
        self.tabBarItem.title = "news".localized()
        self.tableView.addSubview(refreshController.refreshControl)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavItems()
        refreshController.refreshControl.addTarget(self, action:
            #selector(NewsViewController.handleRefresh(_:)),
                                                   for: UIControlEvents.valueChanged)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title  = "news".localized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideNavItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBanners(message:String) {
        let banner = NotificationBanner(title: "Greska", subtitle:message, style: .danger)
        banner.show()
       
    }
    
    func hideNavItems() {
        self.tabBarController?.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title = "StudentStatus".localized()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    
        NewsController.sharedController.getNews()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let countNum =  NewsController.sharedController.announcments?.Announcements.count {
            return countNum
         }
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "newsCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? NewsTableViewCell
        if let countNum =  NewsController.sharedController.announcments?.Announcements.count {
            if countNum > 0 {
                
                cell?.populateCell(news: (NewsController.sharedController.announcments?.Announcements[indexPath.row])!)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailsScreen(indexPath: indexPath.row)
    }
    
    func openDetailsScreen(indexPath:Int) {
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailView") as! NewsDetailViewController
        vc.news = NewsController.sharedController.announcments?.Announcements[indexPath]
        navigationController?.pushViewController(vc,animated: true)
    }
    
    func setUpNavItems() {
        // Additional bar button items
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(NewsViewController.showSyllabusActionSheets))

        self.tabBarController?.navigationItem.setRightBarButtonItems([button1], animated: true)
    }
    
    @objc func showSyllabusActionSheets() {
        createSyllabusActionSheetView()
    }
    
    func createSyllabusActionSheetView() {
        let myActionSheet =  UIAlertController(title: "Choose syllabus", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        myActionSheet.addAction(UIAlertAction(title: "All syllabusses", style: UIAlertActionStyle.default, handler: { (ACTION :UIAlertAction!)in
            NewsController.sharedController.getNews()
        }))
        
        for syllabus in (SylabussesController.sharedController.syllabussesData?.Syllabuses)! {
            
            myActionSheet.addAction(UIAlertAction(title:syllabus.CourseName, style: UIAlertActionStyle.default, handler: { (ACTION :UIAlertAction!)in
                NewsController.sharedController.getNewsBySyllabus(SyllabusID:syllabus.SyllabusID ?? 0)
            }))
        }
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}

extension NewsViewController : NewsControllerDelegate {
     func onSuccess(response: Announcements) {
        print(response)
        self.tableView .reloadData()
        refreshController.refreshControl.endRefreshing()
    }
    
    func onError() {
    }
}
