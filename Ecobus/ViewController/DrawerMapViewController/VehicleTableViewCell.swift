//
//  VehicleTableViewCell.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/21/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataForCell(data: Vehicle) {
        lblTitle.text = data.name
        lblDes.text = data.address
        lblStatus.text = data.status
        lblCode.text = findCodeVehicle(str: data.name)
    }
    
    func findCodeVehicle(str: String) -> String {
        do {
            let regex = try NSRegularExpression.init(pattern: "[1-9][A-B]", options: [])
            let matches = regex.matches(in: str, options: [], range: NSRange.init(location: 0, length: str.count))
            if let range = matches.last?.range, let rangeStr = Range.init(range, in: str) {
                return String(str[rangeStr])
            }
            return ""
        } catch {
            print(error)
            return ""
        }
    }
    
}
