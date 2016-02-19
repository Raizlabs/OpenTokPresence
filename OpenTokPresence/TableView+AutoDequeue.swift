//
//  TableView+AutoDequeue.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//
//  http://www.atelierclockwork.net/blog/2016/2/3/sanding-down-rough-edges
//

import Foundation

protocol AutomaticDequeue {
}

extension AutomaticDequeue where Self: AnyObject {

    static var reuseIdentifer: String {
        return NSStringFromClass(self) as String
    }

}


extension UITableView {

    func registerCellClass<CellClass: UITableViewCell where CellClass: AutomaticDequeue>(cellClass: CellClass.Type) {
        registerClass(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifer)
    }

    func registerHeaderFooterClass<HeaderFooterClass: UITableViewHeaderFooterView where HeaderFooterClass: AutomaticDequeue>(headerFooterClass: HeaderFooterClass.Type) {
        registerClass(headerFooterClass, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseIdentifer)
    }

    func cellForIndexPath<CellClass: UITableViewCell where CellClass: AutomaticDequeue>(indexPath: NSIndexPath) -> CellClass {
        guard let cell = dequeueReusableCellWithIdentifier(CellClass.reuseIdentifer, forIndexPath: indexPath) as? CellClass else {
            fatalError("Could not dequeue cell with identifier \(CellClass.reuseIdentifer)")
        }
        return cell
    }

    func headerForIndexPath<HeaderFooterClass: UITableViewHeaderFooterView where HeaderFooterClass: AutomaticDequeue>(indexPath: NSIndexPath) -> HeaderFooterClass {
        guard let header = dequeueReusableHeaderFooterViewWithIdentifier(HeaderFooterClass.reuseIdentifer) as? HeaderFooterClass else {
            fatalError("Could not dequeue header with identifier \(HeaderFooterClass.reuseIdentifer)")
        }
        return header
    }

    func footerForIndexPath<HeaderFooterClass: UITableViewHeaderFooterView where HeaderFooterClass: AutomaticDequeue>(indexPath: NSIndexPath) -> HeaderFooterClass {
        guard let footer = dequeueReusableHeaderFooterViewWithIdentifier(HeaderFooterClass.reuseIdentifer) as? HeaderFooterClass else {
            fatalError("Could not dequeue footer with identifier \(HeaderFooterClass.reuseIdentifer)")
        }
        return footer
    }
    
}
