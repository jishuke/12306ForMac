//
//  TrainCodeDetailViewController.swift
//  12306ForMac
//
//  Created by fancymax on 2016/06/12.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Cocoa


class MyHeaderCell : NSTableHeaderCell {
    
    override func drawWithFrame(cellFrame: NSRect, inView controlView: NSView) {
        let (borderRect, fillRect) = cellFrame.divide(1.0, fromEdge: .MaxYEdge)
        
        NSColor.grayColor().set()
        NSRectFill(borderRect)
        
        NSColor(calibratedRed:0.921569, green:0.921569, blue:0.921569, alpha:1.0).set()
        NSRectFill(fillRect)
        self.drawInteriorWithFrame(CGRectInset(fillRect, 0.0, 1.0), inView: controlView)
    }
}

class TrainCodeDetailViewController: NSViewController {
    var service = Service()
    var queryByTrainCodeParam: QueryByTrainCodeParam! {
        didSet{
            print("\(queryByTrainCodeParam.ToGetParams())")
            if oldValue != nil {
                if oldValue.ToGetParams() == queryByTrainCodeParam.ToGetParams() {
                    return
                }
            }
            
            let successHandler = { (trainDetails:TrainCodeDetails)->()  in
                self.trainCodeDetails = trainDetails
                self.trainCodeDetailTable.reloadData()
                self.trainCodeDetailTable.scrollRowToVisible(0)
//
//                self.stopLoadingTip()
            }
            
            let failureHandler = {(error:NSError)->() in
//                self.stopLoadingTip()
//                self.ticketQueryResult = [QueryLeftNewDTO]()
//                self.leftTicketTable.reloadData()
//                
//                self.tips.show(translate(error), forDuration: 1, withFlash: false)
            }
            
            service.queryTrainNoFlowWith(queryByTrainCodeParam, success: successHandler, failure: failureHandler)
        }
    }
    @IBOutlet weak var trainCodeDetailTable: NSTableView!
    
    var trainCodeDetails: TrainCodeDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        for col in trainCodeDetailTable.tableColumns {
            col.headerCell = MyHeaderCell(textCell: col.headerCell.stringValue)
            col.headerCell.alignment = .Center
        }
    }
    
}

// MARK: - NSTableViewDataSource 
extension TrainCodeDetailViewController: NSTableViewDataSource{
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if trainCodeDetails == nil {
            return 0
        }
        return trainCodeDetails!.trainNos.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if trainCodeDetails == nil {
            return nil
        }
        return trainCodeDetails!.trainNos[row]
    }
}