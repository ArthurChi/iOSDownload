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
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var debugSwitch: UISwitch!
    
    private lazy var session: URLSession = {
        
        let id = "com.download.bgsession"
        let configuration = URLSessionConfiguration.background(withIdentifier: id)
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    private var downloadTask: URLSessionDownloadTask!
    private var cancelData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
    }
    
    @IBAction func startBtnDidClicked(_ sender: UIButton) {
        
        if !debugSwitch.isOn {
            session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
                
                print("dataTasks is \(dataTasks)")
                print("uploadTasks is \(uploadTasks)")
                print("downloadTasks is \(downloadTasks)")
                
                downloadTasks.forEach({ (task) in
                    task.cancel()
                })
            }
        }
        
        if let cancelData = cancelData {
            downloadTask = session.downloadTask(withResumeData: cancelData)
            self.cancelData = nil
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
        
        DispatchQueue.main.async {
            self.progressLabel.text = "下载完毕"
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        DispatchQueue.main.async {
            
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            self.progressLabel.text = "\(Int(progress * 100))%"
            self.progressView.progress = progress
        }
    }
}
