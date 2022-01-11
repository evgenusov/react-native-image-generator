import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-image-generator' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const ImageGenerator = NativeModules.ImageGenerator
  ? NativeModules.ImageGenerator
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export async function addLayer(data: {
  uri: string,
  width: number,
  height: number,
  x: number,
  y: number
}): Promise<void> {
  return await ImageGenerator.addLayer(data.uri, data.width, data.height, data.x, data.y);
}


export async function save(data: {
  filename: string,
  width: number,
  height: number,
}): Promise<string> {
  return await ImageGenerator.save(data.filename, data.width, data.height);
}
