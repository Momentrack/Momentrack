//
//  PostingMomentViewController.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit

class PostingMomentViewController: UIViewController {
    private let postingMomentView = PostingMomentView()
    
    override func loadView() {
        view = postingMomentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

}

