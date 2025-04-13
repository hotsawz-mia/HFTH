import SwiftUI
import WebKit

// SwiftUI wrapper to display a full-screen background GIF (darkened) and a centered foreground GIF
struct CelebrationView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIView {
        // Create the root container view
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = true // Let SwiftUI size this

        // BACKGROUND GIF (fullscreen)
        let backgroundWebView = WKWebView()
        backgroundWebView.scrollView.isScrollEnabled = false
        backgroundWebView.isOpaque = true
        backgroundWebView.backgroundColor = .black
        backgroundWebView.translatesAutoresizingMaskIntoConstraints = false

        // DARK OVERLAY
        let darkOverlay = UIView()
        darkOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        darkOverlay.translatesAutoresizingMaskIntoConstraints = false

        // FOREGROUND GIF (natural aspect ratio)
        let foregroundWebView = WKWebView()
        foregroundWebView.scrollView.isScrollEnabled = false
        foregroundWebView.isOpaque = false
        foregroundWebView.backgroundColor = .clear
        foregroundWebView.translatesAutoresizingMaskIntoConstraints = false

        // Add views to container
        container.addSubview(backgroundWebView)
        container.addSubview(darkOverlay)
        container.addSubview(foregroundWebView)

        // Constrain background to fill the container
        NSLayoutConstraint.activate([
            backgroundWebView.topAnchor.constraint(equalTo: container.topAnchor),
            backgroundWebView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            backgroundWebView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backgroundWebView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        // Constrain overlay to same size
        NSLayoutConstraint.activate([
            darkOverlay.topAnchor.constraint(equalTo: container.topAnchor),
            darkOverlay.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            darkOverlay.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            darkOverlay.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        // Center foreground GIF with max size, preserving aspect ratio
        NSLayoutConstraint.activate([
            foregroundWebView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            foregroundWebView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            foregroundWebView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            foregroundWebView.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
        ])

        // Load the same GIF into both web views
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            
            let base64 = data.base64EncodedString()

            // Background HTML: fullscreen fill with object-fit: cover
            let backgroundHTML = """
                <html>
                <body style="margin:0;padding:0;background:transparent;">
                <img src="data:image/gif;base64,\(base64)" style="width:100vw;height:100vh;object-fit:cover;" />
                </body>
                </html>
                """

            // Foreground HTML: natural size, centered
            let foregroundHTML = """
                <html>
                <body style="margin:0;padding:0;background:transparent;display:flex;justify-content:center;align-items:center;width:100vw;">
                <img src="data:image/gif;base64,\(base64)" style="object-fit:contain; width:100vw;" />
                </body>
                </html>
                """

            backgroundWebView.loadHTMLString(backgroundHTML, baseURL: nil)
            foregroundWebView.loadHTMLString(foregroundHTML, baseURL: nil)
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No dynamic updates needed
    }
}
