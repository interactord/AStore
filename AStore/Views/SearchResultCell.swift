//
// Created by SANGBONG MOON on 2019-04-20.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
	
	let appIconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .red
		imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
		imageView.layer.cornerRadius = 12
		return imageView
	}()
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "APP NAME"
		return label
	}()
	
	let categoryLabel: UILabel = {
		let label = UILabel()
		label.text = "Photo & Video"
		return label
	}()
	
	let ratingsLabel: UILabel = {
		let label = UILabel()
		label.text = "611K"
		return label
	}()
	
	let getButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitleColor(.blue, for: .normal)
		button.setTitle("GET", for: .normal)
		button.backgroundColor = UIColor(white: 0.95, alpha: 1)
		button.titleLabel?.font = .boldSystemFont(ofSize: 14)
		button.widthAnchor.constraint(equalToConstant: 80).isActive = true
		button.heightAnchor.constraint(equalToConstant: 32).isActive = true
		button.layer.cornerRadius = 16
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .yellow
		
		let labelsStackView = UIStackView(arrangedSubviews: [
			nameLabel,
			categoryLabel,
			ratingsLabel
		])
		labelsStackView.axis = .vertical
		
		let stackView = UIStackView(arrangedSubviews: [
			appIconImageView,
			labelsStackView,
			getButton
		])
		
		stackView.spacing = 12
		stackView.alignment = .center
		
		addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
