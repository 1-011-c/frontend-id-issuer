# Frontend ID Issuer
This project is for generating the QRCode Pair PDF.

# How to use
You can download a release for your platfrom from the release tab.

## Options
You can also provide some options to the generate command.
They include:
- `-a` or `--amount`: Specify the amount of QRCode Pairs that should be generated. Default: 10
- `-o` or `--output`: Specify the location where the PDF should be stored. Default: Current working directory.

## Examples
- Generate 20 QRCode Pairs in the current working directory
```
emfi-light.exe generate -a 20
```

- Generate 4 QRCode Pairs in `~/`
```
emfi-light.exe generate -a 4 -o ~/
```


# Development
## Dependencies
To help developing you need the following dependencies:
- [Dart SDK](https://dart.dev/get-dart)

## Usage
1. Clone the project as follows:
```
git clone https://github.com/1-011-c/frontend-id-issuer.git
```

2. Naviagte to `lib/`
3. Run the command line tool like so:
```
dart main.dart generate
```
