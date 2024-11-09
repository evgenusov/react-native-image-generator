package com.reactnativeimagegenerator

import android.graphics.*
import android.util.Base64
import com.facebook.react.bridge.*

import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.net.URL


class ImageGeneratorModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "ImageGenerator"
  }

  private fun createLayer(data: Map<String, Any>): Layer {
    if (data["uri"] != null) {
      return PictureLayer(
        data["uri"] as String,
        data["width"] as Double,
        data["height"] as Double,
        data["x"] as Double,
        data["y"] as Double
      )
    }

    return TextLayer(
      data["text"] as String,
      data["fontSize"] as Double,
      data["fontFamily"] as String?,
      data["color"] as ArrayList<Double>?,
      data["width"] as Double,
      data["height"] as Double,
      data["x"] as Double,
      data["y"] as Double,
      data["bold"] as Boolean
    )
  }

  private fun getBitmapForLayer(layer: PictureLayer): Bitmap {
    if ("http" in layer.uri) {
      val url = URL(layer.uri);
      return BitmapFactory.decodeStream(url.openConnection().getInputStream())
    }
    if ("file" in layer.uri) {
      val imgFile = File(layer.uri.replace("file://", ""));
      return BitmapFactory.decodeFile(imgFile.absolutePath);
    }
    return BitmapFactory.decodeStream(reactApplicationContext.assets.open(layer.uri));
  }

  private fun drawPictureLayer(canvas: Canvas, layer: PictureLayer) {
    val bitmap = getBitmapForLayer(layer);
    canvas.drawBitmap(
      bitmap,
      null,
      Rect(
        layer.x.toInt(),
        layer.y.toInt(),
        layer.width.toInt(),
        layer.height.toInt()
      ),
      null)
  }

  private fun drawTextLayer(canvas: Canvas, layer: TextLayer) {
//    val paint = TextPaint()


    // draw some text using STROKE style
    val paint = Paint()
    paint.color = Color.TRANSPARENT
    paint.style = Paint.Style.FILL
    canvas.drawPaint(paint)

    if (layer.color != null) {
      paint.color = Color.argb(
        layer.color!![3].toInt() * 255,
        layer.color!![0].toInt(),
        layer.color!![1].toInt(),
        layer.color!![2].toInt()
      );
    } else {
      paint.color = Color.WHITE;
    }

    if (layer.bold) {
      paint.setTypeface(Typeface.DEFAULT_BOLD);
    }
    
    paint.textSize = layer.fontSize.toFloat()
    canvas.drawText(layer.text, layer.x.toFloat(), layer.y.toFloat(), paint)
  }

  private fun drawLayer(canvas: Canvas, layer: Layer) {
    if (layer is PictureLayer) {
      drawPictureLayer(canvas, layer)
    } else {
      drawTextLayer(canvas, layer as TextLayer)
    }
  }

  private fun saveBitmap(bitmap: Bitmap, fileName: String): String {
    val outputDir: File = reactApplicationContext.cacheDir // context being the Activity pointer
    val outputFile: File = File.createTempFile(fileName, ".jpg", outputDir)
    val outputStream = FileOutputStream(outputFile.absoluteFile);
    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
    return "file://" + outputFile.absoluteFile.absolutePath;
  }

  @ReactMethod
  fun generate(layersData: ReadableMap, config: ReadableMap, promise: Promise) {
    val layers = layersData.getArray("layers");
    val width = config.getInt("width")
    val height = config.getInt("height")
    val filename = config.getString("filename")
    val base64: Boolean? = config.getBoolean("base64") as Boolean?
    val bgBitMapConfig = Bitmap.Config.ARGB_8888
    val bgBitmap = Bitmap.createBitmap(width, height, bgBitMapConfig)
    val canvas = Canvas(bgBitmap)
    if (layers != null) {
      for (item in layers.toArrayList()) drawLayer(canvas, createLayer(item as Map<String, Any>))
    }
    if(base64 !== null && base64) {
      val baos = ByteArrayOutputStream()
      bgBitmap.compress(Bitmap.CompressFormat.PNG, 100, baos)
      val result =  Base64.encodeToString(baos.toByteArray(), Base64.DEFAULT)
      promise.resolve("data:image/png;base64,${result}")
    } else {
      val result = saveBitmap(bgBitmap, filename!!)
      promise.resolve(result)
    }

  }


}
