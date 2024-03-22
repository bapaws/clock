//
//  Capture.swift
//
//
//  Created by 张敏超 on 2023/12/31.
//

import Foundation
import SwiftUI

public extension View {
    func capture(size: CGSize? = nil, scale: CGFloat = UIScreen.main.scale, ignoreSafeArea: Bool = false, delay: Double = 1.5, completion: @escaping (UIImage?) -> Void) -> some View {
        // 非全屏情况下，一般需要忽略安全区域Capture
        let controller = ignoreSafeArea ? UIHostingController(rootView: ignoresSafeArea()) : UIHostingController(rootView: self)
        let view = controller.view!
        let format = UIGraphicsImageRendererFormat()
        if let size = size {
            view.bounds = CGRect(origin: .zero, size: size)
        } else {
            view.bounds = UIScreen.main.bounds
        }
        format.scale = scale
        view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(bounds: view.bounds, format: format)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let image = renderer.image { _ in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            completion(image)
        }
        return self
    }
}
