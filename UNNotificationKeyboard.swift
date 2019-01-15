//
//  UNNotificationKeyboard.swift
//  
//
//  Created by Luciano Pezzin on 07/12/2018.
//

import UIKit

class Container: NSObject {
    
    
    //  - Variáveis do layout da tabbottonbar
    var bottomConstraint: NSLayoutConstraint?
    var bottomTableView: NSLayoutConstraint?
    
    //NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    //NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    //bottomTableView = NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0)
    
    //        view.addConstraints([bottomTableView!])
    
    //  - Notifica quando o teclado irá abrir
    //  - pra que a lista e a tabbar subam junto com o teclado
//    @objc func handleKeyBoardNotification(_ notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
//
//
//            bottomTableView?.constant = isKeyBoardShowing ? -(keyboardFrame.height + 48) : -48
//            bottomConstraint?.constant = isKeyBoardShowing ? -(keyboardFrame.height) : 0
//            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//            }) { (_) in
//
//                if isKeyBoardShowing {
//                    let lastSection =  self.tableView.numberOfSections - 1
//                    let lastItem = self.tableView.numberOfRows(inSection: lastSection) - 1
//                    let indexPath = IndexPath(item: lastItem, section: lastSection)
//                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                }
//            }
//        }
//    }
//
}
