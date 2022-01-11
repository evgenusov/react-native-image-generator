import Accelerate

struct Layer {
    var uri: String
    var width: Float
    var height: Float
    var x: Float
    var y: Float
    
    init(uri: String, width: Float, height: Float, x: Float, y: Float) {
        self.uri = uri;
        self.width = width;
        self.height = height;
        self.x = x;
        self.y = y;
    }
}

@objc(ImageGenerator)
class ImageGenerator: NSObject {
    
    private var layers: [Layer] = [];
    
    
    /// Add a new layer
    @objc(addLayer:withWidth:withHeight:withX:withY:withResolver:withRejecter:)
    func addLayer(uri: String,
                  width: Float,
                  height: Float,
                  x: Float,
                  y: Float,
                  resolve:RCTPromiseResolveBlock,
                  reject:RCTPromiseRejectBlock) {
        
        let layer = Layer(uri: uri, width: width, height: height, x: x, y: y);
        layers.append(layer);
        
        resolve(nil)
    }
    
    /// save image from layers
    @objc(save:withWidth:withHeight:withResolver:withRejecter:)
    func save(filename: String, width: Float, height: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
        let newSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        for layer in layers {
            if(layer.uri.contains("http")) {
            let url = URL(string: layer.uri)
            let data = try? Data(contentsOf: url!)
            
            let imageLayer = UIImage(data: data!);
                imageLayer!.draw(in: CGRect(
                    origin: CGPoint(x: CGFloat(layer.x), y: CGFloat(layer.y)),
                    size: CGSize(width: CGFloat(layer.width), height: CGFloat(layer.height)))
                )
            } else {
                let imageLayer = UIImage(named: layer.uri)
                imageLayer!.draw(in: CGRect(
                    origin: CGPoint(x: CGFloat(layer.x), y: CGFloat(layer.y)),
                    size: CGSize(width: CGFloat(layer.width), height: CGFloat(layer.height)))
                )
            }
          
            
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename) else {
            return
        }
        let pngData = newImage!.pngData();
        do {
            try pngData?.write(to: imageURL);
            resolve(imageURL.absoluteString)
            self.layers = [];

        } catch {
            reject("error save", "idk", error)
        }
        
    }
    
}
