//
//  ViewController.swift
//  GanBank
//
//  Created by ho-lee on 2017/05/23.
//  Copyright © 2017年 GMO Click HD. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class RootViewController: MenuContainerViewController {

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController") as! MenuViewController
        
        contentViewControllers = contentControllers()
        
        selectContentViewController(contentViewControllers.first!)
    }
    
    // MARK: - Set SideMenu
    override func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
        return TransitionOptionsBuilder() { builder in
            builder.duration = 0.5
            builder.contentScale = 0.9
        }
    }
    
    private func contentControllers() -> [MenuItemContentViewController] {
        
        var contentList = [MenuItemContentViewController]()
        
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "TabbarContainer") as! MenuItemContentViewController)
        
        return contentList
    }
    
    @IBAction func touchOpenSideMenu(_ sender: UIButton) {
        showMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

