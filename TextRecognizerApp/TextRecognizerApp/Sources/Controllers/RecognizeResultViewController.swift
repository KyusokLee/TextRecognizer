//
//  RecognizeResultViewController.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/03/31.
//

import UIKit

// TODO: - テキストの認識まで時間がかかるので、ActivityIndicatorでLoading中であることをユーザー知らせる
// MARK: - Life Cycle & Variables
final class RecognizeResultViewController: UIViewController {
    
    @IBOutlet weak var resultTextView: UITextView!
    private(set) var presenter: RecognitionResultViewPresenter!
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLoading = true
        
        return view
    }()
    
    static func instantiate() -> RecognizeResultViewController {
        let storyboard = UIStoryboard(name: "RecognizeResultView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "RecognizeResultViewController") as? RecognizeResultViewController else {
            fatalError("RecognizeResultViewController could not be found")
        }
        
        controller.loadViewIfNeeded()
        controller.configure()
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loadingView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - function
private extension RecognizeResultViewController {
    func configure() {
        presenter = RecognitionResultViewPresenter(
            textRecognizer: VisionTextRecognizer(),
            view: self
        )
        setUpScreen()
        setUpNavigationBar()
    }
    
    func setUpScreen() {
        setUpResultTextView()
        setUpLoadingViewConstraints()
    }
    
    func setUpResultTextView() {
        // textViewへのテキスト入力を防ぐ
        resultTextView.layer.cornerRadius = 8
        resultTextView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        resultTextView.text = ""
        // キーボード入力による編集を防ぐ。ただし、選択は可能に
        resultTextView.isEditable = false
        resultTextView.isSelectable = true
    }
    
    func setUpLoadingViewConstraints() {
        NSLayoutConstraint.activate([
            self.loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
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
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.resultTextView.text = joinedString
        }
    }
    
    func shouldShowRecognitionFailFeedback() {
        let recognitionFailMessage = "テキスト認証に失敗しました"
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.resultTextView.text = recognitionFailMessage
        }
    }
    
}
