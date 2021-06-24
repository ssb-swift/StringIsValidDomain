//
// This source file is part of the StringIsValidDomain open source project.
//
// Copyright (c) 2021 project authors licensed under Mozilla Public License, v.2.0.
// If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// See LICENSE for license information.
// See AUTHORS for the list of the project authors.
//

import Punycode
import Regex

extension String {
  public enum DomainOptions {
    case subdomain
    case allowUnicode
    case wildcard
  }

  public func isValidDomain(_ userOptions: [DomainOptions: Bool] = [:]) -> Bool {
    let defaults = [
      DomainOptions.subdomain: true, DomainOptions.allowUnicode: false,
      DomainOptions.wildcard: false,
    ]
    let options = defaults.merging(userOptions) { (_, new) in new }
    var data = self.lowercased()

    if data.suffix(1) == "." {
      data = String(data.dropLast())
    }

    if options[DomainOptions.allowUnicode] == true {
      data = data.idnaEncoded!
    }

    if data.count > 253 {
      return false
    }

    if !Regex(#"^([a-z0-9-._*]+)$"#).isMatched(by: data) {
      return false
    }

    let sldMatches = Regex(#"(.*)\.(([a-z0-9]+)(\.[a-z0-9]+))"#).allMatches(in: data).flatMap(
      \.groups
    ).map(\.value)
    var labels: [Substring] = []

    if sldMatches.count > 1 {
      if sldMap.contains(sldMatches[1]) {
        labels = sldMatches[0].split(separator: ".", omittingEmptySubsequences: false)
      }
    }

    if labels.count == 0 {
      labels = data.split(separator: ".", omittingEmptySubsequences: false)

      if labels.count <= 1 {
        return false
      }

      let tld = labels.popLast()
      if !Regex(#"^(?:xn--)?(?!^\d+$)[a-z0-9]+$"#).isMatched(by: String(tld!)) {
        return false
      }
    }

    if options[DomainOptions.subdomain] == false && labels.count > 1 {
      return false
    }

    return labels.allSatisfy { label in
      if options[DomainOptions.wildcard] == true && label == "*"
        && labels.lastIndex(of: label)! == 0 && labels.count > 1
      {
        return true
      }

      let validLabelChars = label == labels.last ? #"^([a-zA-Z0-9-]+)$"# : #"^([a-zA-Z0-9-_]+)$"#

      let doubleDashCount = Regex(#"--"#).allMatches(in: String(label)).map(\.value).count
      let xnDashCount = Regex(#"xn--"#).allMatches(in: String(label)).map(\.value).count

      if doubleDashCount != xnDashCount {
        return false
      }
      
      var isValidLabelChars: Bool

      do {
        isValidLabelChars = try Regex(validLabelChars).isMatched(by: String(label))
      } catch {
        isValidLabelChars = false
      }
      
      return isValidLabelChars && label.count < 64 && !label.hasPrefix("-") && !label.hasSuffix("-")
    }
  }
}
