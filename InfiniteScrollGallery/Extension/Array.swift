//
//  Array.swift
//  InfiniteScrollGallery
//
//  Created by Aulia Nastiti on 07/10/23.
//

extension Array where Element: Hashable {
    //Returns a new array without duplicates,
    func removeDuplicates() -> [Element] {
        var addedDict = Set<Element>()
        return filter {
            addedDict.insert($0).inserted
        }
    }
    //Modifies the array in-place to remove duplicates
    mutating func removingDuplicates() {
        self = self.removeDuplicates()
    }
}
