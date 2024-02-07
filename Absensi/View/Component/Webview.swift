//
//  Webview.swift
//  Absensi
//
//  Created by I putu Rama anadya on 21/11/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView  {
        var wkwebView = WKWebView()
        return wkwebView
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}
