//
//  RecognizeResultViewController.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/03/31.
//

import UIKit

final class RecognizeResultViewController: UIViewController {
    
    @IBOutlet weak var resultTextView: UITextView!
    
    static func instantiate(with imageData: Data) -> RecognizeResultViewController {
        guard let controller = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "RecognizeResultViewController") as? RecognizeResultViewController else {
            fatalError("RecognizeResultViewController could not be found")
        }
        
        controller.loadViewIfNeeded()
        controller.configure(with: imageData)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension RecognizeResultViewController {
    func configure(with imageData: Data) {
        setUpNavigationBar(from: imageData)
    }
    
    func setUpNavigationBar(from imageData: Data) {
        navigationItem.title = "簡易プロフィール画面"
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
