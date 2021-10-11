//
//  SearchTableViewCell.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/11/21.
//

import UIKit
import Combine
import SkeletonView

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectStarLabel: UILabel!
    @IBOutlet weak var projectLanguageLabel: UILabel!
    
    private var imageRequester: AnyCancellable?
    
    public override func prepareForReuse() {
      super.prepareForReuse()
      profileImageView.image = nil
      imageRequester?.cancel()
    }
    
    // MARK: - Populate developer detail on table view cell
    func configure(withSearch search: Items, index: Int) {
        hideSkeletonView()
        profileNameLabel.text = search.owner?.login
        projectNameLabel.text = search.name
        projectStarLabel.text = "\(search.stargazers_count ?? 0)"
        projectLanguageLabel.text = search.language
       

        if let url = URL(string: search.owner?.avatar_url ?? "") {
          imageRequester = ImageLoader.shared.loadImage(from: url).sink { [weak self] image in
            guard let s = self else { return }
            s.profileImageView.image = image
          }
        }
        
      }
    
    
    // MARK: - Show skeleton loading
    func showSkeletonView() {
        profileNameLabel.showAnimatedGradientSkeleton()
        projectNameLabel.showAnimatedGradientSkeleton()
        projectStarLabel.showAnimatedGradientSkeleton()
        projectLanguageLabel.showAnimatedGradientSkeleton()
        profileImageView.showAnimatedGradientSkeleton()
    }

    // MARK: - Hide skeleton loading
    func hideSkeletonView() {
        profileNameLabel.hideSkeleton()
        projectNameLabel.hideSkeleton()
        projectStarLabel.hideSkeleton()
        projectLanguageLabel.hideSkeleton()
        profileImageView.hideSkeleton()
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
