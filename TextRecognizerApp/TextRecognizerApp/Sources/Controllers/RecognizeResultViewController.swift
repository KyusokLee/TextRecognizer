//
//  RecognizeResultViewController.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/03/31.
//

import UIKit

final class RecognizeResultViewController: UIViewController {
    
    @IBOutlet weak var resultTextView: UITextView!
    private(set) var presenter: RecognitionResultViewPresenter!
    
    static func instantiate() -> RecognizeResultViewController {
        guard let controller = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "RecognizeResultViewController") as? RecognizeResultViewController else {
            fatalError("RecognizeResultViewController could not be found")
        }
        
        controller.loadViewIfNeeded()
        controller.configure()
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
    func configure() {
        presenter = RecognitionResultViewPresenter(
            textRecognizer: VisionTextRecognizer(),
            view: self
        )
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "テキスト認証の結果画面"
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}

// MARK: - TextRecognizeResultView
extension RecognizeResultViewController: TextRecognizeResultView {
    func shouldShowTextRecognizeResult(with results: [String]) {
        // textViewに反映させる
        let joinedString = results.joined(separator: "\n")
        resultTextView.text = joinedString
    }
    
    func shouldShowNetworkErrorFeedback() {
        let networkErrorMessage = "ネットワークエラー"
    }
    
    func shouldShowRecognitionFailFeedback() {
        let recognitionFailMessage = "テキスト認証に失敗しました"
    }
    
    
}
