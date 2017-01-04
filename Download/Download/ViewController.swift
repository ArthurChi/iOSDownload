//
//  ViewController.swift
//  Download
//
//  Created by cjfire on 2017/1/4.
//  Copyright © 2017年 cjfire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    private lazy var session: URLSession = {
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return session
    }()
    
    private var downloadTask: URLSessionDownloadTask!
    private var cancelData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
    }
    
    @IBAction func startBtnDidClicked(_ sender: UIButton) {
        
        if let cancelData = cancelData {
            downloadTask = session.downloadTask(withResumeData: cancelData)
        } else {
            let url = URL(string: "http://192.168.2.197/Unity_Games_by_Tutorials_v0.1.rar")
            downloadTask = session.downloadTask(with: url!)
        }
        
        downloadTask.resume()
    }
    
    @IBAction func stopBtnDidClicked(_ sender: UIButton) {
        downloadTask.cancel { (cancelData) in
            self.cancelData = cancelData
        }
    }
}

extension ViewController: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print(location)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        DispatchQueue.main.async {
            self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
        
//        print((bytesWritten + totalBytesWritten) / totalBytesExpectedToWrite * 100)
    }
}
