//
//  RecordCell.swift
//  Records
//
//  Created by MACM72 on 26/06/25.
//

import UIKit

class RecordCell: UITableViewCell {

    @IBAction func onSelect(_ sender: UIButton) {
    }
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }
       
       // ✅ Configure method to populate fields
       func configure(with user: User) {
           userName.text = user.name
           userEmail.text = user.email
       }
   

}
