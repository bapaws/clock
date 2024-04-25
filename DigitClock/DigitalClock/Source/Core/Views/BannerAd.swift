//
//  BannerAd.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/25.
//

import ClockShare
import GoogleMobileAds
import SwiftUI

struct BannerAd: UIViewRepresentable {
    // GADAdSizeLargeBanner
    static let size = CGSize(width: 320, height: 100)

    let adView = GADBannerView(adSize: GADAdSizeLargeBanner)

    var unitID: String

    func makeCoordinator() -> Coordinator {
        // For Implementing Delegates..
        return Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        adView.adUnitID = unitID
        adView.delegate = context.coordinator
        adView.rootViewController = UIApplication.shared.connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }?.rootViewController
        adView.load(GADRequest())
        view.addSubview(adView)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("bannerViewDidReceiveAd")
            bannerView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                bannerView.alpha = 1
            })
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewDidDismissScreen")
        }
    }
}

#Preview {
    BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
}
