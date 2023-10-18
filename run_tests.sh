#!/bin/bash

cd ./example;
dart pub get
rm -f lib/*.g.dart
dart run build_runner build --delete-conflicting-outputs;
flutter test
cd ..

dart run test