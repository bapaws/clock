//
//  HUD.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/11/3.
//

import MBProgressHUD

public class HUD: NSObject {
    private static let shared = HUD()

    public static func show(addedTo view: UIView? = nil, animated: Bool = true, timeout: TimeInterval? = 30) {
        guard let toView = view ?? UIApplication.shared.keyWindow else { return }
        let hudView = MBProgressHUD.showAdded(to: toView, animated: true)
        hudView.isSquare = true
        hudView.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)

        guard let timeout = timeout else { return }
        // 超时，直接隐藏
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            hudView.button.addTarget(shared, action: #selector(cancelAction), for: .touchUpInside)
            UIView.animate(withDuration: 0.25) {
                hudView.detailsLabel.text = " "
                let cancel = NSLocalizedString("Cancel", comment: "")
                hudView.button.setTitle(cancel, for: .normal)
            }
        }
    }

    public static func hide(for view: UIView? = nil, animated: Bool = true) {
        guard let forView = view ?? UIApplication.shared.keyWindow else { return }
        MBProgressHUD.hide(for: forView, animated: true)
    }

    @objc func cancelAction(sender: UIButton) {
        guard let hudView = sender.superview?.superview as? MBProgressHUD else { return }
        hudView.hide(animated: true)
    }
}

public class Toast {
    public static func show(_ message: String?) {
        guard let msg = message, let keyWindow = UIApplication.shared.keyWindow else { return }
        let hudView = MBProgressHUD.showAdded(to: keyWindow, animated: true)
        hudView.mode = .text
        hudView.label.text = msg
        hudView.margin = 16
        hudView.hide(animated: true, afterDelay: 3)
    }
}
