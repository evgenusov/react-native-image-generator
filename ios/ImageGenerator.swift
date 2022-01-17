import Accelerate
import Foundation

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
    
    @objc(generate:withConfig:withResolver:withRejecter:)
    func generate(layers: NSDictionary,
                  config: NSDictionary,
                  resolve:RCTPromiseResolveBlock,
                  reject:RCTPromiseRejectBlock) {
        let width = config["width"] as! Float;
        let height = config["height"] as! Float;
        let filename = config["filename"] as! String;
        
        let newSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        let layers: [Layer] = (layers["layers"] as! [NSDictionary]).map { (item) -> Layer in
            return Layer(
                uri: item["uri"] as! String,
                width: item["width"] as! Float,
                height: item["height"] as! Float,
                x: item["x"] as! Float,
                y: item["y"] as! Float
            );
        }
        
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
            resolve(imageURL.absoluteString);
        } catch {
            reject("error save", "idk", error)
        }
    }
}
