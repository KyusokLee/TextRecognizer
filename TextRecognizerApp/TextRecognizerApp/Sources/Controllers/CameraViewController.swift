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
    }
    
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
        let image = UIImage(systemName: "multiply")?.withRenderingMode(.alwaysOriginal)
        dismissButton.tintColor = UIColor.systemGray5
        //Buttonの設定したconstraintsより、imageが小さくなった場合、Buttonをsizeの大きさに合わせる方法
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.contentHorizontalAlignment = .fill
    }
    
    func setUpShootButton() {
        let image = UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysOriginal)
        shootButton.setImage(image, for: .normal)
        shootButton.contentVerticalAlignment = .fill
        shootButton.contentHorizontalAlignment = .fill
        shootButton.tintColor = UIColor.systemBlue.withAlphaComponent(0.8)
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
        guard let videoDevice = AVCaptureDevice.default(for: .video),
            let deviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(photoOutput) else {
                fatalError("カメラのセットアップに失敗しました")
        }

        captureSession.sessionPreset = .hd1920x1080
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }

        let resultViewController = RecognizeResultViewController.instantiate(with: imageData)
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(resultViewController, animated: true)
    }
}
