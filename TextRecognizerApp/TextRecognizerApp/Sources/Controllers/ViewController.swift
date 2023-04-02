//
//  ViewController.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/03/31.
//

import UIKit
import Vision

final class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
    }
}
    
private extension ViewController {
    @IBAction func didTapCameraButton(_ sender: Any) {
        presentCameraView()
    }
    
    func setUpScreen() {
        setUpNavigationController()
        setUpTitleLabel()
        setUpCameraButton()
    }
    
    func setUpNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            
        self.navigationItem.backButtonTitle = "Back"
//        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Home View"
    }
    
    func setUpCameraButton() {
        var config = UIButton.Configuration.filled()
        // containerでFontの設定を変えて、configのattributesに反映させる方式
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .medium)
        config.attributedTitle = AttributedString("カメラで撮影", attributes: container)
        config.image = UIImage(systemName: "camera.viewfinder")
        config.imagePlacement = NSDirectionalRectEdge.leading
        config.imagePadding = 10
        config.baseBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        config.baseForegroundColor = UIColor.white
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        cameraButton.configuration = config
    }
    
    func setUpTitleLabel() {
        titleLabel.adjustsFontSizeToFitWidth = true
        // font sizeの最小値を設定しないと、無限に縮小されてします。（defaultが0であるため）
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = .systemFont(ofSize: 23, weight: .bold)
        titleLabel.text = "カメラでテキスト\n認証を行いましょう！"
    }
    
    func presentCameraView() {
        let cameraViewController = CameraViewController.instantiate()
        let navigation = UINavigationController(rootViewController: cameraViewController)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
}

