//: ## Sean Costello Reverb
//: This is a great sounding reverb that we just love.
import AudioKitPlaygrounds
import AudioKit

let file = try AKAudioFile(readFileName: playgroundAudioFiles[0])

let player = try AKAudioPlayer(file: file)
player.looping = true

var reverb = AKCostelloReverb(player)
reverb.cutoffFrequency = 9_900 // Hz
reverb.feedback = 0.92

AudioKit.output = reverb
AudioKit.start()

player.play()

//: User Interface Set up
import AudioKitUI

class PlaygroundView: AKPlaygroundView {

    var cutoffFrequencySlider: AKPropertySlider?
    var feedbackSlider: AKPropertySlider?

    override func setup() {
        addTitle("Sean Costello Reverb")

        addSubview(AKResourcesAudioFileLoaderView(player: player, filenames: playgroundAudioFiles))

        cutoffFrequencySlider = AKPropertySlider(property: "Cutoff Frequency",
                                                 value: reverb.cutoffFrequency,
                                                 range: 20 ... 5_000,
                                                 format: "%0.1f Hz"
        ) { sliderValue in
            reverb.cutoffFrequency = sliderValue
        }
        addSubview(cutoffFrequencySlider)

        feedbackSlider = AKPropertySlider(property: "Feedback", value: reverb.feedback) { sliderValue in
            reverb.feedback = sliderValue
        }
        addSubview(feedbackSlider)

        let presets = ["Short Tail", "Low Ringing Tail"]
        addSubview(AKPresetLoaderView(presets: presets) { preset in
            switch preset {
            case "Short Tail":
                reverb.presetShortTailCostelloReverb()
            case "Low Ringing Tail":
                reverb.presetLowRingingLongTailCostelloReverb()
            default:
                break
            }
            self.updateUI()
        })
    }

    func updateUI() {
        cutoffFrequencySlider?.value = reverb.cutoffFrequency
        feedbackSlider?.value = reverb.feedback
    }

}

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = PlaygroundView()
