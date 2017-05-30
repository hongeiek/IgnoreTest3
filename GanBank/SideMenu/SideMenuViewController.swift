//
//  SideMenuViewController.swift
//  GanBank
//
//  Created by ho-lee on 2017/05/23.
//  Copyright © 2017年 GMO Click HD. All rights reserved.
//

import Foundation
import InteractiveSideMenu

class SideMenuViewController: MenuViewController {
    
    var openSection: NSMutableSet?
    var numOfRows: Int?
    let rowItems = ["     row content 0", "     row content 1", "     row content 2"]
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openSection = NSMutableSet()
        openSection?.add(0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
        
    }
    
    // MARK: - Controll Touch Section
    
    func sectionButtonTouchUpInside(_ sender: UIButton)
    {
        let btn: UIButton = sender
        
        tableView?.beginUpdates()
        
        let section: Int = sender.tag
        let shouldOpen: Bool = (openSection?.contains(section))!
        
        for i in 0 ..< 10
        {
            if i == section
            {
                // 開いているSectionをTouchしてSectionをすべて閉じる際
                if shouldOpen
                {
                    numOfRows = tableView?.numberOfRows(inSection: section)
                    let indexPaths: NSArray = indexPathsForSection(section, numberOfRows: numOfRows!)
                    tableView?.deleteRows(at: indexPaths as! [IndexPath], with: UITableViewRowAnimation.top)
                    openSection?.remove(section)
                }
                else
                {
                    numOfRows = rowItems.count
                    
                    let indexPaths: NSArray = indexPathsForSection(section, numberOfRows: numOfRows!)
                    tableView?.insertRows(at: indexPaths as! [IndexPath], with: UITableViewRowAnimation.top)
                    openSection?.add(section)
                }
            }
            else
            {
                // Sectionが開いてる状態で他のSectionを選択する際
                let shouldOpen: Bool = (openSection?.contains(i))!
                
                if shouldOpen
                {
                    numOfRows = tableView?.numberOfRows(inSection: i)
                    let indexPaths: NSArray = indexPathsForSection(i, numberOfRows: numOfRows!)
                    tableView?.deleteRows(at: indexPaths as! [IndexPath], with: UITableViewRowAnimation.top)
                    openSection?.remove(i)
                }
            }
        }
        
        tableView?.endUpdates()
        
        
        
        // 押したボタン以外の状態を変更
        for button: UIView in (btn.superview?.subviews)!
        {
            if button.isKind(of: UIButton.self)
            {
                if button.tag == btn.tag
                {
                    // すべてのSectionを閉じる際、最後のSection色を変更
                    let shouldOpen: Bool = (openSection?.contains(btn.tag))!
                    
                    if shouldOpen == true
                    {
                        btn.backgroundColor = UIColor(red: 184.0/255, green: 184.0/255, blue: 184.0/255, alpha: 1.0)
                        btn.setTitleColor(UIColor.red, for: UIControlState())
                        
                        btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
                        
                    }
                    else
                    {
                        let btn: UIButton = button as! UIButton
                        
                        btn.backgroundColor = UIColor(red: 184.0/255, green: 184.0/255, blue: 184.0/255, alpha: 1.0)
                        btn.setTitleColor(UIColor(red: 97.16/255.0, green: 97.21/255.0, blue: 97.13/255.0, alpha: 1.0), for: UIControlState())
                        
                        btn.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
                    }
                }
                else
                {
                    let btn: UIButton = button as! UIButton
                    
                    btn.backgroundColor = UIColor(red: 184.0/255, green: 184.0/255, blue: 184.0/255, alpha: 1.0)
                    btn.setTitleColor(UIColor(red: 97.16/255.0, green: 97.21/255.0, blue: 97.13/255.0, alpha: 1.0), for: UIControlState())
                    
                    btn.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
                }
                
                
                // 押したボタン以外の状態を変更
                let btn: UIButton = button as! UIButton
                for label: UIView in btn.subviews
                {
                    if label.isKind(of: UILabel.self)
                    {
                        if label.tag == btn.tag
                        {
                            let shouldOpen: Bool? = openSection?.contains(btn.tag)
                            
                            if shouldOpen == true
                            {
                                let selectLabel: UILabel = label as! UILabel
                                selectLabel.textColor = UIColor.red
                            }
                            else
                            {
                                let selectLabel: UILabel = label as! UILabel
                                selectLabel.textColor = UIColor(red: 97.16/255.0, green: 97.21/255.0, blue: 97.13/255.0, alpha: 1.0)
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
    
    func indexPathsForSection(_ section: Int, numberOfRows: Int) -> NSArray
    {
        let indexPaths: NSMutableArray? = []
        
        for i in 0 ..< numberOfRows
        {
            let indexPath: IndexPath = IndexPath(row: i, section: section)
            indexPaths?.add(indexPath)
        }
        
        return indexPaths!
    }
}

// MARK: - TableViewDelegate
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if openSection?.contains(section) == true
        {
            return rowItems.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
        cell.textLabel?.text = rowItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async {
            
            guard let menuContainerViewController = self.menuContainerViewController else { return }
            //          menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
            menuContainerViewController.hideMenu()
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionBtn: UIButton?
        var sectionTitle: UILabel?
        
        sectionBtn = UIButton(type: UIButtonType.custom)
        sectionBtn?.addTarget(self, action: #selector(SideMenuViewController.sectionButtonTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
        
        sectionTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width / 2, height: 40))
        sectionTitle?.textAlignment = NSTextAlignment.left
        sectionTitle?.font = UIFont(name: "Helvetica-Bold", size: 17)
        sectionTitle?.text = "Section \(section)"
        
        let shouldOpen: Bool? = openSection?.contains(section)
        if shouldOpen == true
        {
            sectionBtn?.backgroundColor = UIColor(red: 184.0/255, green: 184.0/255, blue: 184.0/255, alpha: 1.0)
            sectionBtn?.setTitleColor(UIColor.white, for: UIControlState())
            
            sectionTitle?.textColor = UIColor.red
            
        }
        else
        {
            sectionBtn?.backgroundColor = UIColor(red: 184.0/255, green: 184.0/255, blue: 184.0/255, alpha: 1.0)
            sectionBtn?.setTitleColor(UIColor(red: 97.16/255, green: 97.21/255, blue: 97.13/255, alpha: 1.0), for: UIControlState())
            
            sectionTitle?.textColor = UIColor(red: 97.16/255.0, green: 97.21/255.0, blue: 97.13/255.0, alpha: 1.0)
        }
        
        sectionBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        sectionBtn?.tag = section
        sectionTitle?.tag = section
        
        sectionBtn?.addSubview(sectionTitle!)
        
        return sectionBtn
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
}
