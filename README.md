CLIKit is an advanced, intuitive command-line parsing library for Swift programs.  It's designed to be elegant, powerful, and have all the right defaults.

[![Anarchy Tools compatible](https://img.shields.io/badge/Anarchy%20Tools-compatible-4BC51D.svg?style=flat)](http://anarchytools.org)
![License:RPL](https://img.shields.io/hexpm/l/plug.svg)
![Swift:3](https://img.shields.io/badge/Swift-3-blue.svg)
![Platform:macOS](https://img.shields.io/badge/Platform-macOS-red.svg)

# Usage

```swift
private final class MyGreatCommand : CLIKit.EasyCommand {
    private let options : [Option] = [DefaultOption(longName: "myOption", help: "Help for this option")]
    private let shortHelp = "Help for this command"
    let name = "myGreatCommand"
    let requiresCommandString = false
    private func command(parseResult: ParseResult) {
        //todo command logic here
    }
}

private let command = MyGreatCommand()

guard let r  = command.parser.parseArguments() else {
    exit(1)
}
command.command(r)
```

# Features

* The best help and usage strings you've ever seen, guaranteed™
* Automatic support for version reporting and required legal notices
* Support for default values and optional arguments
* Security features so your passwords don't end up in bash history accidentally
* Multiple choice options
* Much more!

# Install

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

add

```
git "https://code.sealedabstract.com/drewcrawford/CLIKit.git"
```

to your Cartfile.

You can also download an [official binary release](https://code.sealedabstract.com/drewcrawford/CLIKit/tags)

# Mailing list

We use [discuss.sa](http://discuss.sealedabstract.com/c/code-sa/clikit)

# License

This software is licensed under an open-source strong copyleft license, the [RPL](http://opensource.org/licenses/RPL-1.5).  If that doesn't work for you, commercial licensing is available from the [author](drew@sealedabstract.com).