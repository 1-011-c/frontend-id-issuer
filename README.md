# Frontend ID Issuer
This project is for generating the QRCode Pair PDF.


# Dependencies
To use this project you need the following:
- [Dart SDK](https://dart.dev/get-dart)

# Usage
1. Clone the project as follows:
```
git clone https://github.com/1-011-c/frontend-id-issuer.git
```

2. Naviagte to `lib/`
3. Run the command line tool like so:
```
dart main.dart generate
```

# Options
You can also provide some options to the generate command.
They include:
- `-a` or `--amount`: Specify the amount of QRCode Pairs that should be generated. Default: 10
- `-o` or `--output`: Specify the location where the PDF should be stored. Default: Current working directory.
