//
// Created by JK on 2021/03/31.
//

import UIKit

extension IndexPath {
	var nextRow: IndexPath {
		IndexPath(row: self.row + 1, section: self.section)
	}
}
