//
//  ViewController.swift
//  SwipeStories
//
//  Created by Mayur Susare on 02/06/21.
//

import UIKit

var ViewControllerVC = ViewController()

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    
    //MARK:- Variable Declarations
    var pageViewController : UIPageViewController?
    var currentIndex : Int = 0
    var pages: [StoryDetails] = []
    
    //MARK:- IBOUTLET
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerVC = self
        
        //initialise the UIPageViewController
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        
        let startingViewController: PreviousViewController = viewControllerAtIndex(index: currentIndex)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = view.bounds
        
        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)
        view.sendSubviewToBack(pageViewController!.view)
        pageViewController!.didMove(toParent: self)
    }
    
    //MARK:- Page View Controller Methods
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PreviousViewController).pageIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    //2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PreviousViewController).pageIndex
        if index == NSNotFound {
            return nil
        }
        index += 1
        if (index == pages.count) {
            return nil
        }
        return viewControllerAtIndex(index: index)
    }
    
    //Get The current View Controller
    func viewControllerAtIndex(index: Int) -> PreviousViewController? {
        if pages.count == 0 || index >= pages.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviousViewController") as! PreviousViewController
        vc.pageIndex = index
        vc.items = pages
        currentIndex = index
        
        vc.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        return vc
    }
    
    // Navigate to next page
    func goNextPage(fowardTo position: Int) {
        
        guard let position = viewControllerAtIndex(index: position) else {
            return
        }
        let startingViewController: PreviousViewController = position
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - Button Actions
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
 
