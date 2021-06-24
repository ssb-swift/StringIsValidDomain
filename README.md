# StringIsValidDomain

Validate domain names in Swift | _[is-valid-domain][ref]_

## Demo

[https://lab.miguelmota.com/is-valid-domain][demo]

## Install

Add the following to the Package.swift dependencies:

```swift
.package(url: "https://github.com/ssb-swift/StringIsValidDomain", from: "1.0.0")
```

[Or add the package in Xcode.][xcode-package-management-guide]

## Usage

```swift
import StringIsValidDomain

"example.com".isValidDomain())                                          // true
"foo.example.com".isValidDomain())                                      // true
"bar.foo.example.com".isValidDomain())                                  // true
"exa-mple.co.uk".isValidDomain())                                       // true
"xn--80ak6aa92e.com".isValidDomain())                                   // true
"_dnslink.ipfs.io".isValidDomain())                                     // true
"exa_mple.com".isValidDomain())                                         // false
"-example.co.uk".isValidDomain())                                       // false
"example".isValidDomain())                                              // false
"ex*mple.com".isValidDomain())                                          // false
"*.example.com".isValidDomain())                                        // false
"*.com".isValidDomain())                                                // false

"foo.example.com".isValidDomain([.subdomain: true])                     // true
"foo.example.com".isValidDomain([.subdomain: false])                    // false
"*.example.com".isValidDomain([.wildcard: false])                       // false
"*.example.com".isValidDomain([.wildcard: true])                        // true
"*.example.com".isValidDomain([.subdomain: false, .wildcard: true])     // false
"はじめよう.みんな".isValidDomain()                                         // false
"はじめよう.みんな".isValidDomain([.allowUnicode: true])                    // true
```

View more [examples](./Tests/StringIsValidDomainTests/StringIsValidDomainTests.swift).

## Contributing

### swift-format

This project uses [swift-format][swift-format] for automatic code formatting as a pre-commit hook; Use the following instructions to set up swift-format for your environment:

**Install swift-format**
```sh
cd <repository-location>
git clone -b swift-5.4-branch https://github.com/apple/swift-format.git
cd swift-format
swift build
```

**Add switf-format to your PATH**
```sh
export PATH=$PATH:~/<repository-location>/swift-format/.build/x86_64-apple-macosx/debug
```
_Don't forget to reload your Terminal configuration._

**Create the Git hook**

* Create the _pre-commit_ file in the project's `.git/hooks` directory.
```sh
touch .git/hooks/pre-commit
```
* Give the file execution rights:
```sh
sudo chmod +x .git/hooks/pre-commit
```
* Add the following script to the _pre-commit_ file and save the changes:
```sh
#!/bin/bash
swift-format --version 1>/dev/null 2>&1
if [ $? -eq 0 ]
then
    git diff --diff-filter=d --staged --name-only | grep -e '\(.*\).swift$' | while read line; do
        swift-format -i "${line}";
        git add "$line";
    done
fi
```

Now, every time you commit new changes in the project, swift-format will automatically format them before committing them.

## FAQ

- Q: Why is trailing dot `.` in domain names verified as `true`?

  - A: Fully qualified domain names allow the trailing dot which represents the root zone. More info [here][source_one] and [here][source_two].

[ref]: https://github.com/miguelmota/is-valid-domain
[demo]: https://lab.miguelmota.com/is-valid-domain
[xcode-package-management-guide]: https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app
[source_one]: http://www.dns-sd.org/trailingdotsindomainnames.html
[source_two]: https://en.wikipedia.org/wiki/Fully_qualified_domain_name
