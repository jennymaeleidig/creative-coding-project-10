// Simple audio player with multiple tracks using Minim library

// The goal behind this project is to demonstrate the use of lists and arrays.
// Additionally, this projet serves as a demonstration of how to playback audio files, which i plan to do for my final project.
// I ran into some issues with the Processing Sound library, so I switched to the Minim library instead.
// I got that pointer from: https://stackoverflow.com/a/53950426

// I've bundled a couple tracks here as part of the demo, so I hope you enjoy them!
// See the track metadata below for more info and artist credits.

import ddf.minim.*;
import java.util.List;
import java.util.ArrayList;

String[][] trackMetadata; //2D array to hold track file names and titles
Minim minim; //https://stackoverflow.com/questions/53950278/outofboundsexception-in-processing-sound-library
Track currentTrack;

class Track {
  String name;
  String artist;
  int length; //in ms
  AudioPlayer player;

  Track(String name, String artist, int length, AudioPlayer player) {
    this.name = name;
    this.artist = artist;
    this.length = length;
    this.player = player;
  }
}

List<Track> tracks = new ArrayList<Track>();

void setup() {
  size (350, 200);
  minim = new Minim(this);
  trackMetadata = new String[][] {
    {"track-01.wav", "The Starting Line", "Niel Cicierega"},
    {"track-02.wav", "3rD BEST", "3D BLAST"},
    {"track-03.wav", "The Number Song", "DJ Shadow"},
    {"track-04.wav", "The Me In Me", "Blarf"},
  };


  for (String[] track : trackMetadata) {
    String fileName = track[0];
    String title = track[1];
    String artist = track[2];
    AudioPlayer player = minim.loadFile(fileName);
    // apply master volume to each loaded player so they start at the same level
    // Debug: log each track's length and total
    int totalLength = 0;
    for (int i = 0; i < tracks.size(); i++) {
      totalLength += tracks.get(i).length;
    }
    tracks.add(new Track(title, artist, player.length(), player));
  }

  currentTrack = tracks.get(0); // Start with the first track
}

void draw() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(12);
  String status = currentTrack.player.isPlaying() ? "Playing" : "Paused";
  text("Track: " + currentTrack.name + "\n" +
    "Status: " + status + "\n" +
    "Artist: " + currentTrack.artist + "\n" +
    "Space: Play/Pause\n" +
    "Right Arrow: Next Track\n" +
    "Left Arrow: Previous Track", width/2, height/2);
}

void keyPressed() {
  if (key == ' ') {
    if ( currentTrack.player.isPlaying() ) {
      currentTrack.player.pause();
    } else {
      currentTrack.player.play();
    }
  }

  if (keyCode == RIGHT) {
    // jump to beginning of next track (wrap to first)
    boolean wasPlaying = currentTrack.player.isPlaying();
    int currentIndex = tracks.indexOf(currentTrack);
    int nextIndex = (currentIndex + 1) % tracks.size();
    // proceed even if wrapping to first; if only one track this will do nothing visible
    if (nextIndex != currentIndex || tracks.size() > 1) {
      currentTrack.player.pause();
      currentTrack = tracks.get(nextIndex);
      currentTrack.player.cue(0);
      if (wasPlaying) {
        currentTrack.player.play();
      }
    }
  }

  if (keyCode == LEFT) {
    // jump to beginning of previous track (wrap to last)
    boolean wasPlaying = currentTrack.player.isPlaying();
    int currentIndex = tracks.indexOf(currentTrack);
    int prevIndex = (currentIndex - 1 + tracks.size()) % tracks.size();
    currentTrack.player.pause();
    currentTrack = tracks.get(prevIndex);
    currentTrack.player.cue(0);
    if (wasPlaying) {
      currentTrack.player.play();
    }
  }
}
