//
//  InputValidator.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation

protocol InputValidatorProtocol: class {
    static func isValid(value: String) -> Bool
}

public class InputValidator {
    
    public static func isValid(value: String) -> Bool {
        return isIP(value: value)
    }
    
    fileprivate static let IpRegex: [String:String] = [
        "4": "(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})",
        "6": "[0-9A-Fa-f]{1,4}"
    ]
    
    fileprivate static func isIP(value: String) -> Bool {
        return isIPv4(value: value) || isIPv6(value: value)
    }
    
    fileprivate static func isIPv4(value: String) -> Bool {
        guard let regex = IpRegex["4"] else { return false }
        return value.matches(regex)
    }
    
    
    fileprivate static func isIPv6(value: String) -> Bool {
        
        let string: String = self.removeDashes(self.removeSpaces(value))
        var blocks = string.split(omittingEmptySubsequences: false) {
            $0 == ":"
        }.map { String($0) }
        
        var foundOmissionBlock = false // marker to indicate ::
        
        // At least some OS accept the last 32 bits of an IPv6 address
        // (i.e. 2 of the blocks) in IPv4 notation, and RFC 3493 says
        // that '::ffff:a.b.c.d' is valid for IPv4-mapped IPv6 addresses,
        // and '::a.b.c.d' is deprecated, but also valid.
        
        let lastBlock = blocks[blocks.count - 1]
        let foundIPv4TransitionBlock = (blocks.count > 0 ? InputValidator.isIPv4(value: lastBlock) : false)
        let expectedNumberOfBlocks = (foundIPv4TransitionBlock ? 7 : 8)
        
        if (blocks.count > expectedNumberOfBlocks) {
            return false
        }
        
        
        if (string == "::") {
            return true
        } else if (String(string[string.startIndex..<string.index(string.startIndex, offsetBy: 2)]) == "::") {
            blocks.remove(at: 0)
            blocks.remove(at: 0)
            foundOmissionBlock = true
        } else if (String(String(string.reversed())[string.startIndex..<string.index(string.startIndex, offsetBy: 2)]) == "::") {
            blocks.removeLast()
            blocks.removeLast()
            foundOmissionBlock = true
        }
        
        for i in 0 ..< blocks.count {
            guard let regex = IpRegex["6"] else { return false }
            
            if (blocks[i] == "" && i > 0 && i < blocks.count - 1) {
                if (foundOmissionBlock) {
                    return false
                }
                foundOmissionBlock = true
            } else if (foundIPv4TransitionBlock && i == blocks.count - 1) {
                
            } else {
                let currentBlock = blocks[i]
                let matches = currentBlock.matches(regex)
                if !matches {
                    return false
                }
            }
        }
        
        if (foundOmissionBlock) {
            return blocks.count >= 1
        } else {
            return blocks.count == expectedNumberOfBlocks
        }
    }
    
    fileprivate static func removeSpaces(_ value: String) -> String {
        return self.removeCharacter(value, char: " ")
    }
    
    fileprivate static func removeDashes(_ value: String) -> String {
        return self.removeCharacter(value, char: "-")
    }
    
    fileprivate static func removeCharacter(_ value: String, char: String) -> String {
        return value.replacingOccurrences(of: char, with: "")
    }
    
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
