package com.visioncameraocr

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class OCRResult(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    
    override fun getName() = "OCRResult"

    companion object {
        private val ocrResults = mutableListOf<String>()
        private const val MAX_SIZE = 15

        fun addResult(text: String) {
            if (ocrResults.size >= MAX_SIZE) {
                ocrResults.removeAt(0)
            }
            ocrResults.add(text)
        }

        fun getMostFrequentOrLatest(): String {
            return ocrResults.groupingBy { it }.eachCount()
                .maxByOrNull { it.value }?.key ?: ocrResults.lastOrNull() ?: ""
        }

        fun clearResults() {
            ocrResults.clear()
        }
    }

    @ReactMethod
    fun emptyResults() {
        OCRResult.clearResults() // Calls the companion object function
    }
}
