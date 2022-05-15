import * as React from 'react';

import { StyleSheet, View, Text, Image } from 'react-native';
import { generate } from 'react-native-image-generator';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  const generateImage = React.useCallback(async () => {
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
          uri: 'Mario',
          width: 200,
          height: 300,
          x: 0,
          y: 0,
        },
        {
          text: 'DESIGN',
          fontSize: 23,
          width: 300,
          height: 300,
          x: 50,
          y: 50,
          color: [0, 255, 0, 1.0],
        },
      ],
      {
        filename: 'test.png',
        width: 200,
        height: 300,
        base64: false,
      }
    );

    setResult(r);
  }, []);

  React.useEffect(() => {
    generateImage();
  }, [generateImage]);

  return (
    <View style={styles.container}>
      <Image
        source={{ uri: result }}
        style={{ width: 200, height: 300 }}
        onError={(e) => console.error(e.nativeEvent)}
      />
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
