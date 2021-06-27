//
//  NoteTableViewCell.swift
//  KoinzTask
//
//  Created by no one on 25/06/2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var noteTItleLbl: UILabel!
    @IBOutlet weak var noteBodyLbl: UILabel!
    @IBOutlet weak var noteWithLocationImageView: UIImageView!
    @IBOutlet weak var noteWIthImageView: UIImageView!
    @IBOutlet weak var nearestLbl: UILabel!
    var noteListCellViewModel : NoteListCellViewModel? {
            didSet {
                noteTItleLbl.text = noteListCellViewModel?.noteTitle
                noteBodyLbl.text = noteListCellViewModel?.noteBody
                nearestLbl.text = noteListCellViewModel?.nearestNote
                if ((noteListCellViewModel?.hasGPS) != nil){
                    noteWithLocationImageView.image = UIImage(named: "note")
                }
                if ((noteListCellViewModel?.hasImage) != nil){
                    noteWIthImageView.image = UIImage(named: "note")

                }
                
            }
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
