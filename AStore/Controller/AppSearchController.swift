//
// Created by SANGBONG MOON on 2019-04-20.
// Copyright (c) 2019 Scott Moon. All rights reserved.
//

import UIKit

class AppSearchController: UICollectionViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = .red
	}
	
	init() {
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
