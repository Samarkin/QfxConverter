# QFX Converter

Converts a set of OFX ([Open Financial Exchange](https://en.wikipedia.org/wiki/Open_Financial_Exchange)) and QFX ([Intuit's Quicken](https://en.wikipedia.org/wiki/QFX_(file_format))) files into a single CSV ([Comma Separated Values](https://en.wikipedia.org/wiki/Comma-separated_values)) file for further processing.

## To Build & Run
On macOS, you can use [XCode](https://itunes.apple.com/us/app/id497799835) to open `QfxConverter.xcodeproj`.

Alternatively (or if you're using another OS), please refer to [this guide](https://swift.org/download/) to install Swift 4.
Then, execute the following commands to build and run.
```
swift build
.build/debug/QfxConverter <folder>
```

## To Use

```
./QfxConverter <folder>
```

## License

[CC0 1.0 (Public Domain)](LICENSE.md)
