CLIKit is an advanced, intuitive command-line parsing library for Swift programs.  It's designed to be elegant, powerful, and have all the right defaults.

# Usage

```swift
private final class MyGreatCommand : CLIKit.EasyCommand {
    private let options : [Option] = [DefaultOption(longName: "myOption", help: "Help for this option")
    private let shortHelp = "Help for this command"
    let name = "myGreatCommand"
    private func command(parseResult: ParseResult) {
        //todo command logic here
    }
}

let result = command.parser.parseArguments()
command.command(result)
```

# Features

* Automatically builds usage / help
* Automatically displays required legal notices

# Install

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

add

```
git "https://code.sealedabstract.com/drewcrawford/CLIKit.git" "master"
```

to your Cartfile.

# License

This software is licensed under an open-source strong copyleft license, the [RPL](http://opensource.org/licenses/RPL-1.5).  If that doesn't work for you, commercial licensing is available from the [author](drew@sealedabstract.com).  


