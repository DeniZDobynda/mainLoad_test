//
//  ViewController.swift
//  MainLoad
//
//  Created by Dobanda, Denis on 01.04.20.
//  Copyright © 2020 theDeniZ. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let animationView = AnimationView(animation: Animation.named("Animation"))
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.loop)
        
        let spinView = UIActivityIndicatorView(frame: CGRect(x: 125, y: 525, width: 50, height: 50))
        spinView.color = UIColor.white
        spinView.backgroundColor = UIColor.black
        
        let button = UIButton(frame: CGRect(x: 50, y: 600, width: 200, height: 100))
        button.backgroundColor = UIColor.red
        button.setTitle("Load main thread", for: .normal)
        button.addTarget(self, action: #selector(loadThread), for: .touchUpInside)
        
        view.addSubview(animationView)
        view.addSubview(spinView)
        view.addSubview(button)
        
        spinView.startAnimating()
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 500),
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
    }

    @objc private func loadThread() {
        DispatchQueue.global(qos: .utility).async {
            print("Starting doing background stuff")
            
            let group = DispatchGroup()
            DispatchQueue.main.async(group: group, qos: .utility, flags: .enforceQoS) {
                var vcs = [HeavyViewController]()
                for _ in 0 ..< 100 {
                    let vc = HeavyViewController()
                    vc.loadViewIfNeeded()
                    vc.view.layoutIfNeeded()
                    vcs.append(vc)
                }
            }
            group.wait()
            
            print("Done!")
        }
    }
    
    @objc private func animate(_ sender: UIButton) {
        sender.rotate(duration: 0.2)
    }
    
}

class HeavyViewController: UIViewController {
    override func loadView() {
        view = UIView()
        
        let stack = UIStackView()
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: stack.topAnchor),
            view.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
        
        (0 ..< 200).forEach { (number) in
            let label = UILabel()
            label.text = "\(number)"
            label.sizeToFit()
            stack.addArrangedSubview(label)
        }
    }
}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
