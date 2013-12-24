// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  Error Records und Konstanten.
  Einmal für den Parser und einmal für den Interpreter.
*)

unit TPLErrors;

interface
type
  TParserError = Record
    InZeile : string;
    UngZustand : string;
    UngBefehl : string;
    NichtImAlphabet : string;
    NichtSchreibbar : string;    
    UngZiel : string;
    JumpErwartet : string;
    KeinParameter : string;
    KeinBefehl : string;
  end;
  TInterpreterError = Record
    NichtGeparst : string;
    KeinBefehl : string;
    UngZiel : string;
  end;

const
  ParserError : TParserError =
  (
    InZeile : 'Fehler in Zeile %d : ';
    UngZustand : 'Ungültiger Zustand : "%s"';
    UngBefehl : 'Ungültiger Befehl : "%s"';
    NichtImAlphabet : 'Zeichen nicht im Alphabet : "%s"';
    NichtSchreibbar : 'Zeichen "%s" nicht schreibbar';
    UngZiel : 'Ungültiger Zielzustand : "%s"';
    JumpErwartet : 'Jump Erwartet : "%s" gefunden';
    KeinParameter : 'Kein weiterer Parameter erwartet : "%s" gefunden';
    KeinBefehl : 'Kein Befehl gefunden';
  );
  InterpreterError : TInterpreterError =
  (
    NichtGeparst : 'Erst Parsen';
    KeinBefehl : 'Kein Befehl gefunden';
    UngZiel : 'Das Ziel %i existiert nicht';
  );
implementation

end.
