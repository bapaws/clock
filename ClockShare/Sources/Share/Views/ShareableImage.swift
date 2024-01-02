//
//  ShareableImage.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/13.
//

import UIKit
import LinkPresentation

public final class ShareableImage: NSObject, UIActivityItemSource {
    private let image: UIImage
    private let title: String
    private let subtitle: String?

    public init(image: UIImage, title: String, subtitle: String? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle

        super.init()
    }

    public func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        return title
    }

    public func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return image
    }

    public func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()

        metadata.iconProvider = NSItemProvider(object: image)
        metadata.title = title
        if let subtitle = subtitle, subtitle.starts(with: "http") {
            metadata.originalURL = URL(fileURLWithPath: subtitle)
        }

        return metadata
    }
}
