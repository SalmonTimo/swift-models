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
  let datasetRoot = DatasetUtilities.download(
    filename: filename,
    fileExtension: "tar.gz",
    remoteRoot: remoteRoot,
    localStorageDirectory: localStorageDirectory)

  let (soundFiles, transcripts) = fetchFiles(from: datasetRoot)
  
  // TODO: Walk directory, unpack .flac files to spectrogram and align with transcript
  audio, transcripts = fetchFLACFiles(fromRoot: datasetRoot)
  }

  fatalError("Incomplete implementation.")
}

func fetchFiles(from root: URL
) -> (flacURLs: [URL], transcripts: [URL]) {
  let localFileManager = FileManager()
  let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
  let directoryEnumerator = localFileManager.enumerator(at: root, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)!
  var flacURLs: [URL] = []
  var transcriptURLs: [URL] = []
  for case let fileURL as URL in directoryEnumerator {
    if fileURL.absoluteString.hasSuffix(".flac") {
      flacURLs.append(fileURL)
    }
    if fileURL.absoluteString.hasSuffix(".trans.txt") {
      transcriptURLs.append(fileURL)
    }
  }
  return (flacURLs, transcriptURLs)
}
