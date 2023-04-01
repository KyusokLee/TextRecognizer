//
//  RecognitionResultViewPresenter.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/04/01.
//

import Foundation
import UIKit

// インタフェースの定義
protocol TextRecognizeResultView: AnyObject {
    func shouldShowTextRecognizeResult()
    func shouldShowNetworkErrorFeedback()
    func shouldShowRecognitionFailFeedback()
}

final class RecognitionResultViewPresenter {
    private let textRecognizer: VisionTextRecognizerProtocol
    private weak var view: TextRecognizeResultView?
    
    init(textRecognizer: VisionTextRecognizerProtocol, view: TextRecognizeResultView) {
        self.textRecognizer = textRecognizer
        // イニシャライザでViewを受け取る
        self.view = view
    }
    
    func loadTextResult(from image: CGImage) {
        textRecognizer.recognize(cgImage: image, completion: { <#[String]#> in
            <#code#>
        })
    }
}
