import UIKit

class AnimatedEqualizerView: UIView {
    
    let barCount = 28
    
    var containerView: UIView!
    let containerLayer = CALayer()
    
    var childLayers = [CALayer]()
    let lowBezierPath = UIBezierPath()
    let middleBezierPath = UIBezierPath()
    let highBezierPath = UIBezierPath()
    let middleHightBezierPath = UIBezierPath()
    
    var animations = [CABasicAnimation]()
    
    var isShowing = false;
    
    init(containerView: UIView) {
        self.containerView = containerView
        super.init(frame: containerView.frame)
        self.initCommon()
        self.initContainerLayer()
        self.initBezierPath()
        self.initBars()
        self.initAnimation()
        self.isHidden = true
        self.backgroundColor = UIColor.red
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func animate() {
        if (isShowing) {
            return
        }
        isShowing = true
        for index in 0...barCount {
            let maxRandValue = UInt32(barCount - 1)
            let randomNum:UInt32 = arc4random_uniform(maxRandValue)
            let delay = 0.1 * Double(randomNum)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.addAnimation(index)
            }
        }
    }
    
    func startAnimation() {
        self.isHidden = false
    }
    
    func stopAnimation() {
        self.isHidden = true
    }
    
    func initCommon() {
        self.frame = CGRect(x: 0, y: 0, width: containerView!.frame.size.width, height: containerView!.frame.size.height)
    }
    
    func initContainerLayer() {
        containerLayer.frame = CGRect(x: 0, y: 0, width: 320, height: 120)
        containerLayer.anchorPoint = CGPoint(x: 0, y: 0)
        containerLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(containerLayer)
    }
    
    func initBezierPath() {
        lowBezierPath.move(to: CGPoint(x: 0, y: 55));
        lowBezierPath.addLine(to: CGPoint(x: 0, y: 65));
        lowBezierPath.addLine(to: CGPoint(x: 10, y: 65));
        lowBezierPath.addLine(to: CGPoint(x: 10, y: 55));
        lowBezierPath.addLine(to: CGPoint(x: 0, y: 55));
        lowBezierPath.close();
        
        middleBezierPath.move(to: CGPoint(x: 0, y: 15));
        middleBezierPath.addLine(to: CGPoint(x: 0, y: 65));
        middleBezierPath.addLine(to: CGPoint(x: 10, y: 65));
        middleBezierPath.addLine(to: CGPoint(x: 10, y: 15));
        middleBezierPath.addLine(to: CGPoint(x: 0, y: 15));
        middleBezierPath.close();
        
        
        middleHightBezierPath.move(to: CGPoint(x: 0, y: 35));
        middleHightBezierPath.addLine(to: CGPoint(x: 0, y: 65));
        middleHightBezierPath.addLine(to: CGPoint(x: 10, y: 65));
        middleHightBezierPath.addLine(to: CGPoint(x: 10, y: 35));
        middleHightBezierPath.addLine(to: CGPoint(x: 0, y: 35));
        middleHightBezierPath.close();

        
        highBezierPath.move(to: CGPoint(x: 0, y: 0));
        highBezierPath.addLine(to: CGPoint(x: 0, y: 65));
        highBezierPath.addLine(to: CGPoint(x: 10, y: 65));
        highBezierPath.addLine(to: CGPoint(x: 10, y: 0));
        highBezierPath.addLine(to: CGPoint(x: 0, y: 0));
        highBezierPath.close();
    }
    
    func initBars() {
        for index in 0...barCount {
            let bar = CAShapeLayer()
            bar.frame = CGRect(x: CGFloat(11 * index), y: 0, width: 20, height: 200)
            bar.path = lowBezierPath.cgPath
            bar.fillColor = UIColor.gray.cgColor
            containerLayer.addSublayer(bar)
            childLayers.append(bar)
        }
    }
    
    func initAnimation() {
        for _ in 0...barCount {
            let animation = CABasicAnimation(keyPath: "path")
            let randomNum:UInt32 = arc4random_uniform(3)
            switch randomNum {
            case 0:
                animation.toValue = middleBezierPath.cgPath
                break
            case 1:
                animation.toValue = middleHightBezierPath.cgPath
                break
            case 2:
                animation.toValue = highBezierPath.cgPath
                break
            default:
                break
            }
            animation.autoreverses = true
            animation.duration = 0.5
            animation.repeatCount = MAXFLOAT
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
            animations.append(animation)
        }
    }
    
    func addAnimation(_ index: Int) {
        let animationKey = "\(index)Animation"
        childLayers[index].add(animations[index], forKey: animationKey)
    }
}

