import { NativeModules, Platform } from 'react-native';
import type { IConfig, ILayer } from './types';

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

export async function generate(
  layers: ILayer[],
  config: IConfig
): Promise<string> {
  return await ImageGenerator.generate(
    {
      layers,
    },
    config
  );
}
