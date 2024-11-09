import Accelerate
import Foundation


@objc(ImageGenerator)
class ImageGenerator: NSObject {
    
    func layerFactory(layer: NSDictionary) -> Layer {
        if layer["uri"] != nil {
            return PictureLayer(
                uri: layer["uri"] as! String,
                width: layer["width"] as! Float,
                height: layer["height"] as! Float,
                x: layer["x"] as! Float,
                y: layer["y"] as! Float
            );
        } else {
            return TextLayer(
                text: layer["text"] as! String,
                fontSize: layer["fontSize"] as! Int,
                width: layer["width"] as! Float,
                height: layer["height"] as! Float,
                x: layer["x"] as! Float,
                y: layer["y"] as! Float,
                fontFamily: layer["fontFamily"] as? String,
                bold: layer["bold"] as? Bool,
                color: layer["color"] as? [Float]
            )
        }
    }

    
    func getImageByUri(uri: String) -> UIImage? {
        if(uri.contains("http")) {
            let url = URL(string: uri);
            let data = try? Data(contentsOf: url!)
            return UIImage(data: data!);
        } else {
            return UIImage(named: uri)
        }
    }
    
    func drawPictureLayer(layer: PictureLayer) {
        let imageLayer = getImageByUri(uri: layer.uri);
        if imageLayer != nil {
            imageLayer!.draw(in: CGRect(
                origin: CGPoint(x: CGFloat(layer.x), y: CGFloat(layer.y)),
                size: CGSize(width: CGFloat(layer.width), height: CGFloat(layer.height)))
            )
        }
    }
    
    func drawTextLayer(layer: TextLayer) {
        let textColor = UIColor(
            red: CGFloat(layer.color[0]),
            green: CGFloat(layer.color[1]),
            blue: CGFloat(layer.color[2]),
            alpha: CGFloat(layer.color[3])
        );
        let textFont: UIFont!
        if (layer.bold) {
            textFont = UIFont.systemFont(ofSize: CGFloat(layer.fontSize), weight: .heavy)
        } else {
            textFont = UIFont(name: layer.fontFamily, size: CGFloat(layer.fontSize))
        }
        let text = NSString(string: layer.text);
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
         ]

        
        text.draw(in: CGRect(
            origin: CGPoint(x: CGFloat(layer.x), y: CGFloat(layer.y)),
            size: CGSize(width: CGFloat(layer.width), height: CGFloat(layer.height))),
                  withAttributes: textFontAttributes as [NSAttributedString.Key : Any]
                
        )
        
        
    }
    
    func drawLayer(layer: Layer) {
        if layer is PictureLayer {
            drawPictureLayer(layer: layer as! PictureLayer);
        } else {
            drawTextLayer(layer: layer as! TextLayer);
        }
    }

    @objc(generate:withConfig:withResolver:withRejecter:)
    func generate(layers: NSDictionary,
                  config: NSDictionary,
                  resolve:RCTPromiseResolveBlock,
                  reject:RCTPromiseRejectBlock) {
        let width = config["width"] as! Float;
        let height = config["height"] as! Float;
        let filename = config["filename"] as! String;
        let base64 = config["base64"] as? Bool ?? false;
        
        let newSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        let scale = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        
        let layers: [Layer] = (layers["layers"] as! [NSDictionary]).map { (item) -> Layer in
         return layerFactory(layer: item)
        }
        
        for layer in layers {
            drawLayer(layer: layer);
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename) else {
            return
        }
        

        do {
            if(base64) {
                let jpegData = newImage!.pngData()!
                let base64Data = jpegData.base64EncodedString()
                let imgBase64 = "data:image/png;base64,\(base64Data)"
                resolve(imgBase64)
            } else {
                let pngData = newImage!.pngData();
                try pngData?.write(to: imageURL);
                resolve(imageURL.absoluteString);
            }
 
        } catch {
            reject("error save", "idk", error)
        }
        
        
    
    }
}
