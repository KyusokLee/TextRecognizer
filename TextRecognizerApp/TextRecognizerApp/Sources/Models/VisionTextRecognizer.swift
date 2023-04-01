//
//  VisionTextRecognizer.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/04/01.
//

import Foundation
import UIKit
import Vision

struct VisionTextRecognizer: VisionTextRecognizerProtocol {
//    let textRecognitionQueue: DispatchQueue
//
//    // 途中の段階
//    // Queueの導入のためのinitializer
//    init(textRecognitionQueue: DispatchQueue) {
//        self.textRecognitionQueue = textRecognitionQueue
//    }
    
   // MARK: - Vision Frameworkでテキスト認証
    func recognize(ciImage: CIImage, completion: @escaping (([String], Error?) -> Void)) {
        // テキスト認証結果を格納するString型配列
        var texts: [String] = []
        var request = setUpRecognizeTextRequest()
        
        request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("The observations you tried are of unexpected types.")
                completion([], error)
                return
            }
            
            let maximumCandidates = 5
            for observation in observations {
                // 最大のテキスト候補を5つまで
                guard let candidates = observation.topCandidates(maximumCandidates).first else {
                    continue
                }
                texts.append(candidates.string)
            }
            completion(texts, nil)
        }
        
        // ここで、imageの処理を進める感じ
        // 画像に対しての解析リクエストを処理するためのオブジェクト
        DispatchQueue.main.async {
            let requestHandler = VNImageRequestHandler(ciImage: ciImage)
            try? requestHandler.perform([request])
        }
    }
}

private extension VisionTextRecognizer {
    // Requestの詳細設定
    func setUpRecognizeTextRequest() -> VNRecognizeTextRequest {
        var request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["ja-JP"]
        
        return request
    }
}

protocol VisionTextRecognizerProtocol {
    func recognize(ciImage: CIImage, completion: @escaping(([String], Error?) -> Void))
}
