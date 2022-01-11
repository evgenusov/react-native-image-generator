# react-native-image-generator

Library for generate images from other images

## Installation

```sh
yarn add react-native-image-generator
```

## Usage

```js
import { addLayer, save } from 'react-native-image-generator';

// ...

const generate = useCallback(
    async () => {
      await addLayer({
        uri: 'https://picsum.photos/200/300', // can be url 
        width: 200,
        height: 300,
        x: 0,
        y: 0,
      });

      await addLayer({
        uri: 'Mario',  // can be names asset
        width: 200,
        height: 300,
        x: 0,
        y: 0,
      });

      const r = await save({
        filename: 'test.png',
        width: 200,
        height: 300,
      });
      setResult(r);
    },
    [],
)
```

## Result

<img src="https://github.com/evgenusov/react-native-image-generator/blob/main/images/result.png?raw=true" width="250" />

## Hot to use assets
To use local image you need to put it in assets
### iOS
In iOS you need to put it Images:

<img src="https://github.com/evgenusov/react-native-image-generator/blob/main/images/xcode_assets.jpeg?raw=true"  />


## Platform
- [+] iOS
- [] Android (in progress)

## License

MIT
