import UIKit

let name = "Taylor"

for letter in name {
    print(letter)
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

//makes name[i] return a letter in the string
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
name[3]
//name.count == 0 is much slower than name.isEmpty


let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")
extension String {
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
password.deletingPrefix("12")
password.deletingSuffix("45")



let weather = "it's going to rain"
print(weather.capitalized)
//capitalize just first letter
extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}
print(weather.capitalizedFirst)



let input = "Swift is like Objective-C without the C"
input.contains("Swift")
let languages = ["Python", "Ruby", "Swift"]
//checks if a certain string contains any member of an array
extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}
input.containsAny(of: languages)
languages.contains(where: input.contains)


//NSAttributedString
let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 30)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedStringx = NSMutableAttributedString(string: string)
attributedStringx.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedStringx.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedStringx.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedStringx.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedStringx.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


//Challenge #1
extension String {
    func returnWithPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}
"car".returnWithPrefix("nas")
"hero".returnWithPrefix("her")


//challenge #2
extension String {
    var containsNumeric: Bool {
        var result = false
        for char in self {
            if Double(String(char)) != nil {
                result = true
            }
        }
        return result
    }
}

"hello".containsNumeric
"h3ll0:)".containsNumeric


//challenge #3
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

let text = "hahaha\nhehehe\nhohoho"
text.lines

//day 82 challenge #3
extension Array where Element: Comparable {
    mutating func remove(item: Element) -> Array {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
        return self
    }
}

var array = [1,2,1,3,4]
array.remove(item: 1)
print(array)
