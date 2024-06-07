//
//  CustomSeekBar.swift
//  sdk-tvos-example
//
//  Created by Richard Biroš on 07.06.2024.
//

import SwiftUI
import UIKit

struct CustomSeekBar: UIViewRepresentable {
    @Binding var currentTime: Double
    @Binding var duration: Double
    @Binding var adTimes: [Double]
    var onSeek: (Double) -> Void

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: CustomSeekBar
        var displayLink: CADisplayLink?
        weak var uiView: UIView?

        init(parent: CustomSeekBar) {
            self.parent = parent
            super.init()
            self.displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
            self.displayLink?.add(to: .main, forMode: .common)
        }

        deinit {
            displayLink?.invalidate()
        }

        @objc func updateProgress() {
            guard let uiView = uiView else { return }
            parent.updateView(uiView)
        }

        @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let seekBar = gesture.view else { return }
            let location = gesture.location(in: seekBar)
            let progress = max(0, min(1, location.x / seekBar.bounds.width))
            let newTime = Double(progress) * parent.duration
            print("handlePanGesture: location = \(location.x), progress = \(progress), newTime = \(newTime)")

            if gesture.state == .began || gesture.state == .changed {
                parent.currentTime = newTime
            } else if gesture.state == .ended {
                parent.currentTime = newTime
                print("handlePanGesture: seeking to \(newTime)")
                parent.onSeek(newTime)
            }
        }

        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            guard let seekBar = gesture.view else { return }
            let location = gesture.location(in: seekBar)
            let progress = max(0, min(1, location.x / seekBar.bounds.width))
            let newTime = Double(progress) * parent.duration
            print("handleTapGesture: location = \(location.x), progress = \(progress), newTime = \(newTime)")
            parent.currentTime = newTime
            parent.onSeek(newTime)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        context.coordinator.uiView = view

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:)))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapGesture(_:)))
        tapGesture.delegate = context.coordinator
        view.addGestureRecognizer(tapGesture)

        print("makeUIView: Gesture recognizer added")

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        updateView(uiView)
    }

    private func updateView(_ uiView: UIView) {
        uiView.subviews.forEach { $0.removeFromSuperview() }

        let pastView = UIView()
        pastView.backgroundColor = .white
        uiView.addSubview(pastView)

        let futureView = UIView()
        futureView.backgroundColor = .gray
        uiView.addSubview(futureView)

        let indicator = UIView()
        indicator.backgroundColor = .white
        indicator.layer.cornerRadius = 10
        uiView.addSubview(indicator)

        let timeLabel = UILabel()
        timeLabel.text = formatTime(currentTime)
        timeLabel.textColor = .white
        uiView.addSubview(timeLabel)

        pastView.translatesAutoresizingMaskIntoConstraints = false
        futureView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        let progress = duration > 0 ? CGFloat(currentTime / duration) : 0

        NSLayoutConstraint.activate([
            pastView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            pastView.topAnchor.constraint(equalTo: uiView.topAnchor),
            pastView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            pastView.widthAnchor.constraint(equalTo: uiView.widthAnchor, multiplier: progress),

            futureView.leadingAnchor.constraint(equalTo: pastView.trailingAnchor),
            futureView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            futureView.topAnchor.constraint(equalTo: uiView.topAnchor),
            futureView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),

            indicator.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: pastView.trailingAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 20),
            indicator.heightAnchor.constraint(equalToConstant: 20),

            timeLabel.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: indicator.leadingAnchor, constant: -8)
        ])

        // Add ad markers
        for adTime in adTimes {
            let adProgress = duration > 0 ? CGFloat(adTime / duration) : 0
            let adMarker = UIView()
            adMarker.backgroundColor = .systemYellow
            adMarker.layer.cornerRadius = 7.5
            uiView.addSubview(adMarker)

            adMarker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                adMarker.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
                adMarker.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: uiView.bounds.width * adProgress),
                adMarker.widthAnchor.constraint(equalToConstant: 15),
                adMarker.heightAnchor.constraint(equalToConstant: 15)
            ])
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CustomSeekBar_Previews: PreviewProvider {
    @State static var currentTime: Double = 50
    @State static var duration: Double = 100
    @State static var adTimes: [Double] = [10, 30, 70]

    static var previews: some View {
        CustomSeekBar(currentTime: $currentTime, duration: $duration, adTimes: $adTimes) { newTime in
            print("Seek to \(newTime)")
        }
        .frame(height: 20)
        .cornerRadius(10)
        .padding()
    }
}

