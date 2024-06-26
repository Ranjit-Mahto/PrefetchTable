//
//  PhotoCell.swift
//  Prefetching
//
//  Created by Ranjit Mahto on 31/03/24.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func configure(with viewModel: ViewModel) {
        viewModel.downloadImage { downImage in
            if let image = downImage {
                
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
        }
    }
    
}

import UIKit
import ImageIO
extension UIImageView {
public func loadGif(name: String) {
DispatchQueue.global().async {
let image = UIImage.gif(name: name)
DispatchQueue.main.async {
self.image = image
}
}
}
}
extension UIImage {
public class func gif(data: Data) -> UIImage? {
// Create source from data
guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
print("SwiftGif: Source for the image does not exist")
return nil
}
return UIImage.animatedImageWithSource(source)
}
public class func gif(url: String) -> UIImage? {
// Validate URL
guard let bundleURL = URL(string: url) else {
print("SwiftGif: This image named \"\(url)\" does not exist")
return nil
}
// Validate data
guard let imageData = try? Data(contentsOf: bundleURL) else {
print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
return nil
}
return gif(data: imageData)
}
public class func gif(name: String) -> UIImage? {
// Check for existance of gif
guard let bundleURL = Bundle.main
.url(forResource: name, withExtension: "gif") else {
print("SwiftGif: This image named \"\(name)\" does not exist")
return nil
}
// Validate data
guard let imageData = try? Data(contentsOf: bundleURL) else {
print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
return nil
}
return gif(data: imageData)
}
internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
var delay = 0.1
// Get dictionaries
let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
return delay
}
let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
// Get delay time
var delayObject: AnyObject = unsafeBitCast(
CFDictionaryGetValue(gifProperties,
Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
to: AnyObject.self)
if delayObject.doubleValue == 0 {
delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
}
delay = delayObject as? Double ?? 0
if delay < 0.1 {
delay = 0.1 // Make sure they're not too fast
}
return delay
}
internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
var a = a
var b = b
// Check if one of them is nil
if b == nil || a == nil {
if b != nil {
return b!
} else if a != nil {
return a!
} else {
return 0
}
}
// Swap for modulo
if a! < b! {
let c = a
a = b
b = c
}
// Get greatest common divisor
var rest: Int
while true {
rest = a! % b!
if rest == 0 {
return b! // Found it
} else {
a = b
b = rest
}
}
}
internal class func gcdForArray(_ array: Array<Int>) -> Int {
if array.isEmpty {
return 1
}
var gcd = array[0]
for val in array {
gcd = UIImage.gcdForPair(val, gcd)
}
return gcd
}
internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
let count = CGImageSourceGetCount(source)
var images = [CGImage]()
var delays = [Int]()
// Fill arrays
for i in 0..<count {
// Add image
if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
images.append(image)
}
// At it's delay in cs
let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
source: source)
delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
}
// Calculate full duration
let duration: Int = {
var sum = 0
for val: Int in delays {
sum += val
}
return sum
}()
// Get frames
let gcd = gcdForArray(delays)
var frames = [UIImage]()
var frame: UIImage
var frameCount: Int
for i in 0..<count {
frame = UIImage(cgImage: images[Int(i)])
frameCount = Int(delays[Int(i)] / gcd)
for _ in 0..<frameCount {
frames.append(frame)
}
}
// Heyhey
let animation = UIImage.animatedImage(with: frames,
duration: Double(duration) / 1000.0)
return animation
}
}

//call : self.your_ImageView.loadGif(name: “nameOfGif”)


//Animate image
let img1 = UIImage(named: "panda-0")!
let img2 = UIImage(named: "panda-1")!
let img3 = UIImage(named: "panda-2")!
let animatedImage = UIImage.animatedImage(with: [img1, img2, img3], duration: 1.0)
let imageView: UIImageView = UIImageView(image: animatedImage)
view.addSubview(imageView)

//method 2
let animatedImage = UIImage.animatedImageNamed(“panda-”, duration: 1.0)
let imageView: UIImageView = UIImageView(image: animatedImage)
view.addSubview(imageView)


//or
imageView.animationImages = [img1, img2, img3]
imageView.animationDuration = 1
// must call startAnimating() to trigger animation in this way
imageView.startAnimating()

//or
imageView.image = UIImage.animatedImageNamed(“panda-”, duration: 1.0)
imageView.animationRepeatCount = 0 // default value

