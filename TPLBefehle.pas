// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  In dieser Unit wird zunächst eine Mutterklasse TBefehl definiert, die als Grundlage für
  die Kindsklassen, die jeweiligen Befehle bildet.

  Die Attribute der Klasse TBefehl werden im folgenden kurz beschrieben:
      Start     : Startposition des Befehls (für späteres markieren);
      Ende      : Endposition;
      Ziel      : nächster Zustand sofern gegeben;
      Zustand   : eigener Zustand;
      Schreibe  : Zu schreibender Wert beim write Befehl;
      Bedingung : Bedingung beim case Befehl;
      Befehl    : Name des Befehls;
      Fehler    : Zeiger auf einen Fehlerstring;
      Parameter : Parameter (nach Leerzeichen gesplitteter Befehl);

  Jeder Befehl hat grundsätzlich zwei Methoden:
    function Parsen : boolean; Override;
      Parst den jeweiligen Befehl und gibt true oder false zurück.
      Bei false wird auf den Wert des Fehlerzeigers geschreiben.
    function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Override;
      Interpretiert den Befehl, d.h.: führt sich selbst auf einer übergebenen
      Turingmaschine aus.

  Die Interpretieren Methoden von insb. TCase und TWrite sind exemplarisch
  wie ein endlicher Automat aufgebaut. Ergo: Es gibt einen Zustand und eine Eingabe
  nach denen der Code parst.
  Dieses Prinzip ist im Sinne der Aufgabenstellung performant aber m.E. nach sehr
  unübersichtlich.
  Für weitere Informationen siehe:
    http://www.codeproject.com/Articles/5412/Writing-own-regular-expression-parser
*)

unit TPLBefehle;

interface
uses
  Classes,
  SysUtils,
  Dialogs, // ShowMessage
  TPLErrors,
  TPLTuringmaschine;

type
  TBefehlRecord = record
    Name : string;
    Befehl : pointer;
  end;
  TBefehl = class
    private
    public
      Start     : integer;
      Ende      : integer;
      Ziel      : integer;
      Zustand   : integer;
      Schreibe  : char;
      Bedingung : char;
      Befehl    : string;
      Fehler    : pstring;
      Parameter : TStringList;
      
      Constructor Create; Virtual;
      function Parsen : boolean; Virtual;
      function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Virtual;
      function InAlphabet(Parameter : string) : boolean;      
      function GetNr(Nr : string) : integer;
  end;
  CBefehl = class of TBefehl;
    
  TRight = class(TBefehl)
    Constructor Create; Override;
    function Parsen : boolean; Override;
    function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Override;
  end;
  TLeft = class(TBefehl)
    Constructor Create; Override;
    function Parsen : boolean; Override;
    function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Override;
  end;
  TCase = class(TBefehl)
    Constructor Create; Override;
    function Parsen : boolean; Override;
    function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Override;
  end;
  TWrite = class(TBefehl)
    Constructor Create; Override;
    function Parsen : boolean; Override;
    function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Override;
  end;
  THalt = class(TBefehl)
    Constructor Create; Override;
    function Parsen : boolean; Override;
    function Interpretieren(Turingmaschine : TTuringmaschine) : boolean; Override;
  end;

  const
    BefehlsListe : array[0..4] of TBefehlRecord =
    (
      (Name : 'right'; Befehl : TRight),
      (Name : 'left'; Befehl : TLeft),
      (Name : 'write'; Befehl : TWrite),
      (Name : 'case'; Befehl : TCase),
      (Name : 'halt'; Befehl : THalt)
    );
implementation

{ TBefehl }

Constructor TBefehl.Create;
begin
end;

function TBefehl.Parsen : boolean;
begin
  Result := False;
end;

function TBefehl.Interpretieren(Turingmaschine : TTuringmaschine) : boolean;
begin
  Result := False;
end;

function TBefehl.GetNr(Nr : string) : integer;
begin
  try
    Result := strtoint(Nr);
  except
    Result := -1;
  end;
end;

function TBefehl.InAlphabet(Parameter : string) : boolean;
begin
  Result := False;
  if Length(Parameter) = 1 then
    Result := True;
end;

{ TRight }

Constructor TRight.Create;
begin
  self.Befehl := 'right';
end;

function TRight.Parsen : boolean;
begin
  Result := True;
  if self.Parameter.Count > 0 then
  begin
    self.Fehler^ := Format(ParserError.KeinParameter, [self.Parameter[0]]);
    Result := False;
  end;
end;

function TRight.Interpretieren(Turingmaschine : TTuringmaschine) : boolean;
begin
  Turingmaschine.BefehlRechts;
  Result := True;
end;

{ TLeft }

Constructor TLeft.Create;
begin
  self.Befehl := 'left';
end;

function TLeft.Parsen : boolean;
begin
  Result := True;
  if self.Parameter.Count > 0 then
  begin
    self.Fehler^ := Format(ParserError.KeinParameter, [self.Parameter[0]]);
    Result := False;
  end;
end;

function TLeft.Interpretieren(Turingmaschine : TTuringmaschine) : boolean;
begin
  Turingmaschine.BefehlLinks;
  Result := True;
end;

{ TWrite }

Constructor TWrite.Create;
begin
  self.Befehl := 'write';
end;

function TWrite.Parsen : boolean;
type
  TStatus = (SNull, Se);
var
  Status : TStatus;
begin
  Status := SNull;
  Result := False;
  while self.Parameter.Count > 0 do
  begin
    case Status of
      SNull :
      begin
        if self.InAlphabet(self.Parameter[0]) = False then
        begin
          self.Fehler^ := Format(ParserError.NichtImAlphabet, [self.Parameter[0]]);
          break;
        end;
        Status := Se;
        self.Schreibe := self.Parameter[0][1];
        self.Parameter.Delete(0);
      end;
      Se :
      begin
        Result := True;
        if self.Parameter.Count > 0 then
        begin
          Result := False;
          self.Fehler^ := Format(ParserError.KeinParameter, [self.Parameter[0]]);
        end;
        break;
      end;
    end;
  end;
end;

function TWrite.Interpretieren(Turingmaschine : TTuringmaschine) : boolean;
begin
  Turingmaschine.BefehlSchreibe(self.Schreibe);
  Result := True;
end;

{ TCase }

Constructor TCase.Create;
begin
  self.Befehl := 'case';
end;

function TCase.Parsen : boolean;
type
  TStatus = (SNull, Se, SJump, Sn);
var
  Status : TStatus;
begin
  Status := SNull;
  Result := False;
  while self.Parameter.Count > 0 do
  begin
    case Status of
      SNull :
      begin
        if self.InAlphabet(self.Parameter[0]) = False then
        begin
          self.Fehler^ := Format(ParserError.NichtImAlphabet, [self.Parameter[0]]);
          break;
        end;
        self.Bedingung := Parameter[0][1];
        Status := Se;
        self.Parameter.Delete(0);
      end;
      Se :
      begin
        if LowerCase(self.Parameter[0]) <> 'jump' then
        begin
          self.Fehler^ := Format(ParserError.JumpErwartet, [self.Parameter[0]]);
          break;
        end;
        Status := SJump;
        self.Parameter.Delete(0);
      end;
      SJump :
      begin
        if self.GetNr(self.Parameter[0]) = -1 then
        begin
          self.Fehler^ := Format(ParserError.UngZiel, [self.Parameter[0]]);
          break;
        end;
        Status := Sn;
        self.Ziel := self.GetNr(self.Parameter[0]);
        self.Parameter.Delete(0);
      end;
      Sn :
      begin
        Result := True;
        if self.Parameter.Count > 0 then
        begin
          Result := False;
          self.Fehler^ := Format(ParserError.KeinParameter, [self.Parameter[0]]);
        end;
        break;
      end;
    end;
  end;
end;

function TCase.Interpretieren(Turingmaschine : TTuringmaschine) : boolean;
begin
  Result := Turingmaschine.BefehlSpringeWenn(self.Bedingung, self.Ziel);
end;

{ THalt }

Constructor THalt.Create;
begin
  self.Befehl := 'halt';
end;

function THalt.Parsen : boolean;
begin
  Result := True;
  if self.Parameter.Count > 0 then
  begin
    Result := False;
    self.Fehler^ := Format(ParserError.KeinParameter, [self.Parameter[0]]);
  end;
end;

function THalt.Interpretieren(Turingmaschine : TTuringmaschine) : boolean;
begin
  Result := False;
end;
end.
