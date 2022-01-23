# react-native-image-generator

Library for generate images from other images

## Installation

```sh
yarn add react-native-image-generator
```

## Usage

```js
import { generate } from 'react-native-image-generator';

// ...
const r = await generate(
  [
    {
      uri: 'https://picsum.photos/200/300',
      width: 200,
      height: 300,
      x: 0,
      y: 0,
    },
    {
      uri: 'Mario', // named asset or assets file in android
      width: 200,
      height: 300,
      x: 0,
      y: 0,
    },
  ],
  {
    filename: 'test.png',
    width: 200,
    height: 300,
  }
);
```

## Result

<img src="https://github.com/evgenusov/react-native-image-generator/blob/main/images/result.png?raw=true" width="250" />

## Hot to use assets

To use local image you need to put it in assets

### iOS

In iOS you need to put it Images:

<img src="https://github.com/evgenusov/react-native-image-generator/blob/main/images/xcode_assets.jpeg?raw=true"  />

### Android
Make sure that your file placed here `android/app/src/main/assets/`. For example:
`android/app/src/main/assets/Mario`


## Platforms

- iOS
- Android

## License

MIT
