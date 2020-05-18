//
//  File.swift
//  
//
//  Created by Tim Salmon on 5/18/20.
//

import Foundation
import TensorFlow

func fetchLibriSpeechDataset(
  localStorageDirectory: URL,
  remoteBaseDirectory: String,
  filename: String,
) -> [(data: [Float32], Transcripts: [Int32])] {
  guard let remoteRoot = URL(string: remoteBaseDirectory) else {
    fatalError("Failed to create LibriSpeech root url: \(remoteBaseDirectory)")
  }
  let LibriSpeechDataset = DatasetUtilities.download(
    filename: filename,
    fileExtension: "tar.gz",
    remoteRoot: remoteRoot,
    localStorageDirectory: localStorageDirectory)

  // TODO: Walk directory, unpack .flac files to spectrogram and align with transcript
  }

  fatalError("Incomplete implementation.")
}
