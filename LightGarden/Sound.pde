class Sound {
  Gain gain;
  SamplePlayer samplePlayer;
  Envelope envelope;

  Sound(String samplePath, float startingValue, AudioContext ac) {
    this.envelope = new Envelope(ac, startingValue);
    this.gain = new Gain(ac, 1, this.envelope);

    try {
      this.samplePlayer = new SamplePlayer(ac, new Sample(samplePath));
      this.samplePlayer.setKillOnEnd(false);
      this.samplePlayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
    }
    catch(Exception e)
    {
      println("Exception while attempting to load sample!");
      e.printStackTrace(); // then print a technical description of the error
      exit(); // and exit the program
    }

    this.gain.addInput(this.samplePlayer);   
    this.samplePlayer.setToLoopStart();
    this.samplePlayer.start();
  }

  public Gain getGain() {
    return this.gain;
  }

  public void setEnvelope(float value, int duration) {
    this.envelope.addSegment(value, duration);
  }

  public void setPlayerPosition(double position) {
    this.samplePlayer.setPosition(position);
  }
}

