//
//  CameraViewController.swift
//  TextRecognizerApp
//
//  Created by Kyus'lee on 2023/03/31.
//

import UIKit
import AVFoundation

// Vision FrameWorkを用いたテキスト認証
final class CameraViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    static func instantiate() -> CameraViewController {
        guard let controller = UIStoryboard(name: "CameraView", bundle: nil).instantiateViewController(
            withIdentifier: "CameraViewController"
        ) as? CameraViewController else {
            fatalError("CameraViewController could not be found")
        }
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setUpScreen()
        setUpPreviewLayer()
        setUpSession()
        addPinchGesture()
    }
    
    // 今回は、viewDidLayoutSubViewsを導入してみた
    // SubViewのlayoutが変更された後に呼び出されるメソッドである
    // このメソッドの呼び出される順番は、SubViewのlayoutを変更した後、追加のタスクを実行するのに最適な時点となる
    // そのため、previewLayerのframeをpreviewViewのboundsに合わせるのにいい時点だと判断
    // Viewがloadされた後、layoutを確立させる
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        startCapture()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCapture()
        resetZoomScale()
    }
}

private extension CameraViewController {
    
    @IBAction func didTapDismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShootButton(_ sender: Any) {
        // このタイミングでカメラのシャッターを切る
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
        photoOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func setUpScreen() {
        setUpDismissButton()
        setUpShootButton()
    }
    
    func setUpDismissButton() {
        let color = UIColor.systemGray.withAlphaComponent(0.7)
        let image = UIImage(systemName: "multiply")?.withTintColor(color, renderingMode: .alwaysOriginal)
        guard let image = image else { return }
        dismissButton.setImage(image, for: .normal)
        //Buttonの設定したconstraintsより、imageが小さくなった場合、Buttonをsizeの大きさに合わせる方法
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.contentHorizontalAlignment = .fill
    }
    
    func setUpShootButton() {
        let color = UIColor.systemBlue.withAlphaComponent(0.8)
        let image = UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysOriginal)
        guard let image = image else { return }
        shootButton.setImage(image, for: .normal)
        shootButton.contentVerticalAlignment = .fill
        shootButton.contentHorizontalAlignment = .fill
        shootButton.tintColor = color
    }
    
    // camera Preview viewに拡大、縮小の機能を追加
    private func addPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchToCameraZoom))
        previewView.addGestureRecognizer(pinch)
    }
        
    @objc func pinchToCameraZoom(_ sender: UIPinchGestureRecognizer) {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("There is no available capture device.")
        }
        
        var initialScale = captureDevice.videoZoomFactor
        let minAvailableZoomScale = 1.0
        let maxAvailableZoomScale = captureDevice.maxAvailableVideoZoomFactor
        
        do {
            try captureDevice.lockForConfiguration()
            if (sender.state == UIPinchGestureRecognizer.State.began) {
                initialScale = captureDevice.videoZoomFactor
            } else {
                if (initialScale * (sender.scale) < minAvailableZoomScale) {
                    captureDevice.videoZoomFactor = minAvailableZoomScale
                } else if (initialScale * (sender.scale) > maxAvailableZoomScale) {
                    captureDevice.videoZoomFactor = maxAvailableZoomScale
                } else {
                    captureDevice.videoZoomFactor = initialScale * (sender.scale)
                }
            }
            sender.scale = 1.0
            captureDevice.unlockForConfiguration()
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
    
    // ViewがDisppearされるとき、Zoom ScaleをDefaultに戻す間数
    private func resetZoomScale() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("There is no available capture device.")
        }
        
        do {
            try captureDevice.lockForConfiguration()
            // videoZoomFactorを1.0にresetする
            captureDevice.videoZoomFactor = 1.0
            captureDevice.unlockForConfiguration()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func startCapture() {
        // セッションをスタート
        guard !captureSession.isRunning else {
            return
        }
        // startRunningは設定処理に時間がかかるのでバックグラウンドスレッドで実行させる
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func stopCapture() {
        // セッションをストップ
        guard captureSession.isRunning else {
            return
        }
        captureSession.stopRunning()
    }
    
    // previewLayerの確立
    func setUpPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        previewView.layer.addSublayer(previewLayer)
    }
    
    // セッションの確立
    func setUpSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(photoOutput) else {
                fatalError("カメラのセットアップに失敗しました")
        }

        captureSession.sessionPreset = .hd1920x1080
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        // TODO: - Vision Frameworkでは、CIImageやCGImageを用いるので、ここで、写真のデータ形式の変換をしておく
        // しかし、CGImageのメソッドにはデータ形式を画像データに変換するものがないので、CIImageを採択
        let ciImage = CIImage(data: imageData)
        // ViewControllerでimageを表示したり、加工するロジックがないので、instantiateには他のパラメータは与えない
        let resultViewController = RecognizeResultViewController.instantiate()
        // resultViewControllerのpresenterで撮影したimageを元に、テキスト認証結果を表示するので、責務を行うpresenterのメソッドにCIImageを与える
        resultViewController.presenter.loadTextResult(from: ciImage ?? CIImage())
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.pushViewController(resultViewController, animated: true)
    }
}
