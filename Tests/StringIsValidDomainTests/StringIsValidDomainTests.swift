//
// This source file is part of the StringIsValidDomain open source project.
//
// Copyright (c) 2021 project authors licensed under Mozilla Public License, v.2.0.
// If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// See LICENSE for license information.
// See AUTHORS for the list of the project authors.
//

import StringIsValidDomain
import XCTest

final class StringIsValidDomainTests: XCTestCase {
  func testTDLAndSubdomains() {
    XCTAssertTrue("example.com".isValidDomain())
    XCTAssertTrue("foo.example.com".isValidDomain())
    XCTAssertTrue("bar.foo.example.com".isValidDomain())
    XCTAssertTrue("exa-mple.co.uk".isValidDomain())
    XCTAssertTrue("a.com".isValidDomain())
    XCTAssertTrue("a.b".isValidDomain())
    XCTAssertTrue("foo.bar.baz".isValidDomain())
    XCTAssertTrue("foo-bar.ba-z.qux".isValidDomain())
    XCTAssertTrue("hello.world".isValidDomain())
    XCTAssertTrue("ex-am-ple.com".isValidDomain())
    XCTAssertTrue("xn--80ak6aa92e.com".isValidDomain())
    XCTAssertTrue("example.a9".isValidDomain())
    XCTAssertTrue("example.9a".isValidDomain())
    XCTAssertFalse("example.99".isValidDomain())
  }
  
  func testAllSecondLevelDomains() {
    for sld in sldMap {
      XCTAssertTrue("example.\(sld)".isValidDomain())
    }
  }
  
  func testPunycode() {
    XCTAssertTrue("xn--6qq79v.xn--fiqz9s".isValidDomain())
    XCTAssertTrue("xn--ber-goa.com".isValidDomain())
    XCTAssertFalse("xn--a--ber-goa.com".isValidDomain())
    XCTAssertTrue("xn--c1yn36f.example.com".isValidDomain())
    XCTAssertTrue("xn--addas-o4a.de".isValidDomain())
    XCTAssertTrue("xn--p8j9a0d9c9a.xn--q9jyb4c".isValidDomain())
  }
  
  func testUnicode() {
    XCTAssertFalse("はじめよう.みんな".isValidDomain())
    XCTAssertFalse("名がドメイン.com".isValidDomain())
    XCTAssertTrue("はじめよう.みんな".isValidDomain([.allowUnicode: true]))
    XCTAssertTrue("名がドメイン.com".isValidDomain([.allowUnicode: true]))
  }
  
  func testInvalidTDLAndSubdomains() {
    XCTAssertFalse("localhost".isValidDomain())
    XCTAssertFalse("127.0.0.1".isValidDomain())
    XCTAssertFalse("bar.q-ux".isValidDomain())
    XCTAssertFalse("exa_mple.com".isValidDomain())
    XCTAssertFalse("example".isValidDomain())
    XCTAssertFalse("ex*mple.com".isValidDomain())
    XCTAssertFalse("@#$@#$%fd".isValidDomain())
    XCTAssertFalse("_example.com".isValidDomain())
    XCTAssertFalse("-example.com".isValidDomain())
    XCTAssertFalse("xn–pple-43d.com".isValidDomain())
    XCTAssertFalse("foo._example.com".isValidDomain())
    XCTAssertFalse("foo.-example.com".isValidDomain())
    XCTAssertFalse("foo.example-.co.uk".isValidDomain())
    XCTAssertFalse("example-.com".isValidDomain())
    XCTAssertFalse("example_.com".isValidDomain())
    XCTAssertFalse("foo.example-.com".isValidDomain())
    XCTAssertFalse("foo.example_.com".isValidDomain())
    XCTAssertFalse("example.com-".isValidDomain())
    XCTAssertFalse("example.com_".isValidDomain())
    XCTAssertFalse("-foo.example.com_".isValidDomain())
    XCTAssertFalse("_foo.example.com_".isValidDomain())
    XCTAssertFalse("*.com_".isValidDomain())
    XCTAssertFalse("*.*.com_".isValidDomain())
  }
  
  func testSubdomain() {
    XCTAssertTrue("example.com".isValidDomain())
    XCTAssertTrue("foo.example.com".isValidDomain())
    XCTAssertTrue("example.com".isValidDomain([.subdomain: true]))
    XCTAssertTrue("foo.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("foo.example.com".isValidDomain([.subdomain: false]))
    XCTAssertFalse("-foo.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("foo-.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("-foo-.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("-foo.example.com".isValidDomain())
    XCTAssertFalse("foo-.example.com".isValidDomain())
    XCTAssertFalse("-foo-.example.com".isValidDomain())
    XCTAssertFalse("foo-.bar.example.com".isValidDomain())
    XCTAssertFalse("-foo.bar.example.com".isValidDomain())
    XCTAssertFalse("-foo-.bar.example.com".isValidDomain())
    XCTAssertFalse("-foo-.bar.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("foo-.bar.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("-foo-.bar.example.com".isValidDomain([.subdomain: true]))
    XCTAssertFalse("-foo-.-bar-.example.com".isValidDomain([.subdomain: true]))
    XCTAssertTrue("example.com".isValidDomain([.subdomain: false]))
    XCTAssertFalse("*.example.com".isValidDomain([.subdomain: true]))
  }
  
  func testSubdomainUnderscores() {
    XCTAssertTrue("_dnslink.ipfs.io".isValidDomain())
    XCTAssertFalse("_dnslink.ip_fs.io".isValidDomain())
    XCTAssertTrue("_foo.example.com".isValidDomain())
    XCTAssertTrue("xn--_eamop.donata.com".isValidDomain())
    XCTAssertTrue("__foo.example.com".isValidDomain())
  }
  
  func testSecondLevelDomain() {
    XCTAssertTrue("example.co.uk".isValidDomain())
    XCTAssertTrue("exampl1.co.uk".isValidDomain([.subdomain: false]))
    XCTAssertFalse("abc.example.co.uk".isValidDomain([.subdomain: false]))
    XCTAssertFalse("*.example.co.uk".isValidDomain([.subdomain: true]))
    XCTAssertTrue("*.example.co.uk".isValidDomain([.subdomain: true, .wildcard: true]))
  }
  
  func testWildcard() {
    XCTAssertFalse("*.example.com".isValidDomain())
    XCTAssertFalse("*.example.com".isValidDomain([.wildcard: false]))
    XCTAssertTrue("*.example.com".isValidDomain([.wildcard: true]))
    XCTAssertFalse("*.*.com".isValidDomain([.wildcard: true]))
    XCTAssertFalse("*.com".isValidDomain([.wildcard: true]))
    XCTAssertTrue("example.com".isValidDomain([.wildcard: true]))
    XCTAssertTrue("example.com".isValidDomain([.subdomain: true, .wildcard: true]))
    XCTAssertTrue("*.example.com".isValidDomain([.subdomain: true, .wildcard: true]))
    XCTAssertFalse("*.example.com".isValidDomain([.subdomain: false, .wildcard: true]))
  }
  
  func testValidLength() {
    XCTAssertTrue(
      "\(String(repeating: "a", count: 63)).\(String(repeating: "b", count: 63)).\(String(repeating: "c", count: 63)).\(String(repeating: "c", count: 61))"
        .isValidDomain())
    XCTAssertFalse(
      "\(String(repeating: "a", count: 63)).\(String(repeating: "b", count: 63)).\(String(repeating: "c", count: 63)).\(String(repeating: "c", count: 62))"
        .isValidDomain())
  }
  
  func testInvalidStrings() {
    XCTAssertFalse("foo.example.com*".isValidDomain())
    XCTAssertFalse("foo.example.com*".isValidDomain([.wildcard: true]))
    XCTAssertFalse("google.com\"'\\\"\\\"\"\\\"\\'test test".isValidDomain())
    XCTAssertFalse("google.com.au'\"'\\\"\\\"\"\\\"\\'test".isValidDomain())
    XCTAssertFalse("...".isValidDomain())
    XCTAssertFalse("example..com".isValidDomain())
    XCTAssertFalse(".example.".isValidDomain())
    XCTAssertFalse(".example.com".isValidDomain())
    XCTAssertFalse("\"example.com\"".isValidDomain())
    XCTAssertFalse("http://xn--addas-o4a.de".isValidDomain())
  }
}
