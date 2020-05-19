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
  filename: String
) -> [(data: [Float32], transcript: [Int32])] {
  guard let remoteRoot = URL(string: remoteBaseDirectory) else {
    fatalError("Failed to create LibriSpeech root url: \(remoteBaseDirectory)")
  }
  let datasetDirectory = DatasetUtilities.downloadResource(
    filename: filename,
    fileExtension: "tar.gz",
    remoteRoot: remoteRoot,
    localStorageDirectory: localStorageDirectory)

  let (soundFiles, transcripts) = fetchFiles(from: datasetDirectory)
  
  let mappedTranscripts = alignTranscriptsWithFiles(transcripts: transcripts, audioFiles: soundFiles)
  // TODO: Audiofiles -> Spectrogram
  // TODO: Label-encode transcripts with a vocab

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

func alignTranscriptsWithFiles(transcripts: [URL],
                               audioFiles: [URL]
) -> Dictionary<String, [String]> {
  var fileTranscriptMap = Dictionary<String, [String]>()
  for path in transcripts {
    do {
      let data = try String(contentsOf: path)
      for line in data.components(separatedBy: .newlines) {
        let components = line.components(separatedBy: " ")
        let filePattern = components[0]
        let words = Array(components.dropFirst())
        fileTranscriptMap[filePattern] = words
      }
    } catch {
      print("Could not read, skipping " + path.absoluteString)
      continue
    }
  }
  return fileTranscriptMap
}
