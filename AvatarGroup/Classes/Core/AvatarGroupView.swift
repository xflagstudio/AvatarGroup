//
//  AvatarGroupView.swift
//  AvatarGroup
//
//  Created by Meng Li on 2019/05/23.
//  Copyright © 2018 XFLAG. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SnapKit

open class AvatarGroupView: UIView {
    
    public enum Alignment: CaseIterable {
        case left
        case center
        case right
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.alignment = .center
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private lazy var containerViews: [UIView] = []
    
    private lazy var imageViews: [UIImageView] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        addSubview(stackView)
    }
    
    private func createConstraints() {
        stackView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview()
            switch (alignment, reverse) {
            case (.left, true):
                $0.trailing.equalToSuperview()
            case (.left, false):
                $0.leading.equalToSuperview()
            case (.right, true):
                $0.leading.equalToSuperview()
            case (.right, false):
                $0.trailing.equalToSuperview()
            case (.center, _):
                $0.center.equalToSuperview()
            }
        }
    }
    
    private var cgAffineTransform: CGAffineTransform {
        return CGAffineTransform(scaleX: reverse ? -1 : 1, y: 1)
    }
    
    func removeAllAvatars() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        containerViews.removeAll()
        imageViews.removeAll()
    }
    
    func addImageView() -> UIImageView {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = (bounds.height - 2 * borderWidth) / 2
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = borderColor
            view.addSubview(imageView)
            view.layer.cornerRadius = bounds.height / 2
            view.layer.masksToBounds = true
            view.transform = cgAffineTransform
            return view
        }()
        
        imageViews.append(imageView)
        containerViews.append(containerView)
        stackView.addArrangedSubview(containerView)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().offset(-2 * borderWidth)
        }
        
        containerView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(containerView.snp.height)
        }
        return imageView
    }
    
    @IBInspectable
    public var spacing: CGFloat = 0 {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    @IBInspectable
    public var reverse: Bool = false {
        didSet {
            transform = cgAffineTransform
            containerViews.forEach { $0.transform = cgAffineTransform }
            createConstraints()
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .white {
        didSet {
            containerViews.forEach { $0.backgroundColor = borderColor }
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 2 {
        didSet {
            let cornerRadius = (bounds.height - 2 * borderWidth) / 2
            imageViews.forEach { $0.layer.cornerRadius = cornerRadius }
        }
    }
    
    public var alignment: Alignment = .left {
        didSet {
            createConstraints()
        }
    }

    public var count: Int {
        return containerViews.count
    }
    
    public func setAvatars(images: [UIImage?]) {
        removeAllAvatars()
        
        images.forEach {
            let imageView = addImageView()
            imageView.image = $0
        }
    }
    
}