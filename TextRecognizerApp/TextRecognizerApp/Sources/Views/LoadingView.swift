//
//  LoadingView.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/04/05.
//

import UIKit
// MARK: - テキスト認証でLoading中であることを知らせるためのLoading View
final class LoadingView: UIView {
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = UIColor.systemGray.withAlphaComponent(0.7)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.systemGray.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "テキスト認証中"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isLoading = false {
        didSet {
            self.isHidden = !self.isLoading
            self.isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
      }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.activityIndicatorView)
        self.addSubview(self.titleLabel)
        setUpActivityIndicatorViewConstraints()
        setUpTitleLabelConstraints()
    }
    
    // activityIndicatorViewのconstraints設定
    private func setUpActivityIndicatorViewConstraints() {
        NSLayoutConstraint.activate([
            self.activityIndicatorView.heightAnchor.constraint(equalToConstant: 100),
            self.activityIndicatorView.widthAnchor.constraint(equalToConstant: 100),
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // titleLabelのconstraints設定
    private func setUpTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.heightAnchor.constraint(equalToConstant: 300),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 300),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.activityIndicatorView.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.activityIndicatorView.topAnchor, constant: 90)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("LoadingView doesn't use NibFile.")
    }
}
