(
MIDIClient.init;
MIDIIn.connectAll;
~midiOut = MIDIOut.newByName("IAC Driver", "Bus 1");
)

// ~midiOut.noteOn(0, 24, 90); // range is 24 to 105
// ~midiOut.noteOff(0, 24, 90);
~midiOut.control(0, 14, 127); // chan, ccNum, ccVal


(
~createChoirPattern = {arg seed, midinotes, ctlNum, ccVal;
    var pattern = Pbind(
        \type, \midi,
        \midiout, ~midiOut,
        \chan, 0,
        \amp, Pseg(Pseq([ 0/127, 63/127, 1/127 ]), Pxshuf((5..20)), \lin),
        \midinote, Pstutter(91, Pxshuf(midinotes, inf)),
        \dur, Pseg(Pxshuf(( 1/2, 1/3 .. 1/13 ), inf), Pxshuf((5..17), inf), \sine),
    );

    var cc = Pbind(
        \type, \midi,
        \midicmd, \control,
        \midiout, ~midiOut,
        \chan, 0,
        \ctlNum, ctlNum,
        \control, ccVal,
        \dur, Pn(1,1) // return nil
    );

    Pseed(seed, Pseq([ pattern, cc ], inf));
};

Pdef(\ChoirPat1, ~createChoirPattern.(111, (24..27) ++ (28..90), 14, Pwhite( 0,126,1))).trace.play(quant: 1);
Pdef(\ChoirPat2, ~createChoirPattern.(222, (28..90))).play(quant: 1);
Pdef(\ChoirPat3, ~createChoirPattern.(333, (28..90))).play(quant: 1);
Pdef(\ChoirPat4, ~createChoirPattern.(444, (28..90))).play(quant: 1);
)
