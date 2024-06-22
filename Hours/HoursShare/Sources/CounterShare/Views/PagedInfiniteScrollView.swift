//
//  PagedInfiniteScrollView.swift
//
//
//  Created by 张敏超 on 2024/6/20.
//

import Foundation
import SwiftDate
import SwiftUI
import UIKit

// MARK: Steppable

public protocol Steppable {
    static var origin: Self { get }

    func forward() -> Self
    func backward() -> Self
}

extension Int: Steppable {
    public static var origin: Int {
        return 0
    }

    public func forward() -> Int {
        return self + 1
    }

    public func backward() -> Int {
        return self - 1
    }
}

extension Date: Steppable {
    public static var origin: Date {
        return .now
    }

    public func forward() -> Date {
        return addingTimeInterval(24 * 3600)
    }

    public func backward() -> Date {
        return addingTimeInterval(-24 * 3600)
    }
}

// MARK: PagedInfiniteScrollView

public struct PagedInfiniteScrollView<S: Steppable & Comparable, Content: View>: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIPageViewController

    @Binding var currentPage: S
    public let content: (S) -> Content

    public init(currentPage: Binding<S>, content: @escaping (S) -> Content) {
        self.content = content
        self._currentPage = currentPage
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        let initialViewController = UIHostingController(rootView: IdentifiableContent(index: currentPage, content: { content(currentPage) }))
        pageViewController.setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)

        return pageViewController
    }

    public func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        let currentViewController = uiViewController.viewControllers?.first as? UIHostingController<IdentifiableContent>
        let currentIndex = currentViewController?.rootView.index ?? .origin

        if currentPage != currentIndex {
            let direction: UIPageViewController.NavigationDirection = currentPage > currentIndex ? .forward : .reverse
            let newViewController = UIHostingController(rootView: IdentifiableContent(index: currentPage, content: { content(currentPage) }))
            uiViewController.setViewControllers([newViewController], direction: direction, animated: true, completion: nil)
        }
    }

    public class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PagedInfiniteScrollView

        init(_ parent: PagedInfiniteScrollView) {
            self.parent = parent
        }

        public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let currentView = viewController as? UIHostingController<IdentifiableContent>, let currentIndex = currentView.rootView.index as S? else {
                return nil
            }

            let previousIndex = currentIndex.backward()

            return UIHostingController(rootView: IdentifiableContent(index: previousIndex, content: { parent.content(previousIndex) }))
        }

        public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentView = viewController as? UIHostingController<IdentifiableContent>, let currentIndex = currentView.rootView.index as S? else {
                return nil
            }

            let nextIndex = currentIndex.forward()

            return UIHostingController(rootView: IdentifiableContent(index: nextIndex, content: { parent.content(nextIndex) }))
        }

        public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let currentView = pageViewController.viewControllers?.first as? UIHostingController<IdentifiableContent>,
               let currentIndex = currentView.rootView.index as S?
            {
                parent.currentPage = currentIndex
            }
        }
    }
}

extension PagedInfiniteScrollView {
    struct IdentifiableContent: View {
        let index: S
        let content: Content

        init(index: S, @ViewBuilder content: () -> Content) {
            self.index = index
            self.content = content()
        }

        var body: some View {
            content
        }
    }
}
