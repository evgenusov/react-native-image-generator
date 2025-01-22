package com.reactnativeimagegenerator

import com.facebook.react.bridge.ReadableArray

interface Layer {
}

class PictureLayer(
  var uri: String,
  var width: Double,
  var height: Double,
  var x: Double,
  var y: Double
) : Layer

class TextLayer(
  var text: String,
  var fontSize: Double,
  var fontFamily: String?,
  var color: ArrayList<Double>?,
  var width: Double,
  var height: Double,
  var x: Double,
  var y: Double,
  var bold: Boolean
) : Layer
