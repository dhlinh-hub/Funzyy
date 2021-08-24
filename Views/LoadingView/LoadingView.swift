////
////  File.swift
////
////
////  Created by Edric D. on 28/07/2021.
////
//
//import Foundation
//
//open class LoadingView: NSObject {
//
//    public static let shared = LoadingView()
//
//    public override init() {
//        super.init()
//        customProgressHUD()
//    }
//
//    private func customProgressHUD() {
//        IHProgressHUD.set(defaultMaskType: .custom)
//        IHProgressHUD.set(defaultAnimationType: .native)
//        IHProgressHUD.set(defaultStyle: .dark)
//        IHProgressHUD.set(maximumDismissTimeInterval: 2.0)
//    }
//
//    public func showProgressOnMainThread() {
//        DispatchQueue.main.async {
//            IHProgressHUD.show()
//        }
//    }
//
//    public func dismissProgressOnMainThread() {
//        DispatchQueue.main.async {
//            IHProgressHUD.dismiss()
//        }
//    }
//}
