import * as React from 'react';

import { StyleSheet, View, Text, Image } from 'react-native';
import { addLayer, save } from 'react-native-image-generator';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();


  const generate = React.useCallback(
    async () => {
      await addLayer({
        uri: 'https://picsum.photos/200/300',
        width: 200,
        height: 300,
        x: 0,
        y: 0,
      });

      await addLayer({
        uri: 'Mario',
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

  React.useEffect(() => {
    generate();

  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Image source={{ uri: result }} style={{ width: 200, height: 300 }} />
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
