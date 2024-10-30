package com.visioncameraocr

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.mrousavy.camera.frameprocessors.FrameProcessorPluginRegistry

class VisionCameraOcrPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        val modules = mutableListOf<NativeModule>()
        modules.add(OCRResult(reactContext))
        if(!OCRFrameProcessorPlugin.isRegistered){
            OCRFrameProcessorPlugin.isRegistered = true
            // vision camera @4.1.0
            FrameProcessorPluginRegistry.addFrameProcessorPlugin("scanOCR") { proxy, options ->
                OCRFrameProcessorPlugin(proxy, options)
            }
        }
        return modules
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }
}
