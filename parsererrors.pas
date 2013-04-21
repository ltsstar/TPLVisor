unit parsererrors;

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

const
  ParserError : TParserError =
  (
    InZeile : 'Fehler in Zeile %d : ';
    UngZustand : 'Ung�ltiger Zustand : "%s"';
    UngBefehl : 'Ung�ltiger Befehl : "%s"';
    NichtImAlphabet : 'Zeichen nicht im Alphabet : "%s"';
    NichtSchreibbar : 'Zeichen "%s" nicht schreibbar';
    UngZiel : 'Ung�ltiger Zielzustand : "%s"';
    JumpErwartet : 'Jump Erwartet : "%s" gefunden';
    KeinParameter : 'Kein weiterer Parameter erwartet : "%s" gefunden';
    KeinBefehl : 'Kein Befehl gefunden';
  );
implementation

end.
