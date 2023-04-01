//
//  VisionTextRecognizer.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/04/01.
//

import Foundation
import Vision

struct VisionTextRecognizer: VisionTextRecognizerProtocol {
    // MARK: - Vision Frameworkでテキスト認証
    func recognize(cgImage: CGImage, completion: @escaping([String]) -> Void) {
        // テキスト認証結果を格納するString型配列
        var texts: [String] = []
//        let textRecognitionQueue: DispatchQueue
        var request = setUpRecognizeTextRequest()
        
        request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("The observations you tried are of unexpected types.")
                completion([])
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
            completion(texts)
        }

        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
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
    func recognize(cgImage: CGImage, completion: @escaping([String]) -> Void)
}