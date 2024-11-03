import Foundation
import Vision
import AVFoundation
import MLKitVision
import MLKitTextRecognition
import CoreImage
import UIKit

@objc(OCRFrameProcessorPlugin)
public class OCRFrameProcessorPlugin: FrameProcessorPlugin {
    
    private var textRecognizer = TextRecognizer()
    private static let latinOptions = TextRecognizerOptions()
    private var data: [String: Any] = [:]
    
    public override init(proxy: VisionCameraProxyHolder, options: [AnyHashable: Any]! = [:]) {
        super.init(proxy: proxy, options: options)
        self.textRecognizer = TextRecognizer.textRecognizer(options: OCRFrameProcessorPlugin.latinOptions)
    }
    
    static func processBlocks(blocks:[TextBlock]) -> Array<Any> {
            var blocksArray : [Any] = []
            for block in blocks {
                var blockData : [String:Any] = [:]
                blockData["blockText"] = block.text
                blockData["lines"] = processLines(lines: block.lines)
                blocksArray.append(blockData)
            }
            return blocksArray
        }

        private static func processLines(lines:[TextLine]) -> Array<Any> {
            var linesArray : [Any] = []
            for line in lines {
                var lineData : [String:Any] = [:]
                lineData["text"] = line.text
                linesArray.append(lineData)
            }
            return linesArray
        }

    
    private func getOrientation(orientation: UIImage.Orientation) -> UIImage.Orientation {
        switch orientation {
            case .up:
              return .up
            case .left:
              return .right
            case .down:
              return .down
            case .right:
              return .left
            default:
              return .up
        }
    }
    
    public override func callback(_ frame: Frame, withArguments arguments: [AnyHashable: Any]?) -> Any? {
        
        let buffer = frame.buffer
        let image = VisionImage(buffer: buffer)
        image.orientation = getOrientation(orientation: frame.orientation)
        
        do {
            let result = try self.textRecognizer.results(in: image)
            let blocks = OCRFrameProcessorPlugin.processBlocks(blocks: result.blocks)

            if result.text.isEmpty {
                return [:]
            }else{
                return [
                    "result": [
                        "text": result.text,
                        "blocks": blocks,
                    ]
                ]
            }
        } catch {
            print("Failed to recognize text: \(error.localizedDescription).")
            return [:]
        }
    }
}
