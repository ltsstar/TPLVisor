unit befehle;

interface
uses
  Classes,
  SysUtils,
  Dialogs, // ShowMessage
  parsererrors;

type
  TBefehlRecord = record
    Name : string;
    Befehl : pointer;
  end;
  TBefehl = class
    private
      Parameter : TStringList;
    public
      Zustand : integer;
      Befehl : string;
      Schreibe : char;
      Bedingung : char;
      Fehler : pstring;
      Ziel : integer;
      Constructor Create(Zustand : integer; Parameter : TStringList; Fehler : pstring); Virtual;
      function Parsen : boolean; Virtual;
      function InAlphabet(Parameter : string) : boolean;      
      function GetNr(Nr : string) : integer;
  end;
  CBefehl = class of TBefehl;
    
  TRight = class(TBefehl)
    Constructor Create(Zustand : integer; Parameter : TStringList; Fehler : pstring); Override;
    function Parsen : boolean; Override;
  end;
  TLeft = class(TBefehl)
    Constructor Create(Zustand : integer; Parameter : TStringList; Fehler : pstring); Override;
    function Parsen : boolean; Override;
  end;
  TCase = class(TBefehl)
    Constructor Create(Zustand : integer; Parameter : TStringList; Fehler : pstring); Override;
    function Parsen : boolean; Override;
  end;
  TWrite = class(TBefehl)
    Constructor Create(Zustand : integer; Parameter : TStringList; Fehler : pstring); Override;
    function Parsen : boolean; Override;    
  end;
  THalt = class(TBefehl)
    Constructor Create(Zustand : integer; Parameter: TStringList; Fehler : pstring); Override;
    function Parsen : boolean; Override;
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

Constructor TBefehl.Create(Zustand : integer; Parameter : TStringList; Fehler : pstring);
begin
  self.Parameter := Parameter;
  self.Zustand := Zustand;
  self.Fehler := Fehler;
end;

function TBefehl.Parsen : boolean;
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

Constructor TRight.Create(Zustand : integer; Parameter : TStringList; Fehler : pstring);
begin
  inherited Create(Zustand, Parameter, Fehler);
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

{ TLeft }

Constructor TLeft.Create(Zustand : integer; Parameter : TStringList; Fehler : pstring);
begin
  inherited Create(Zustand, Parameter, Fehler);
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

{ TWrite }

Constructor TWrite.Create(Zustand : integer; Parameter : TStringList; Fehler : pstring);
begin
  inherited Create(Zustand, Parameter, Fehler);
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

{ TCase }

Constructor TCase.Create(Zustand : integer; Parameter : TStringList; Fehler : pstring);
begin
  inherited Create(Zustand, Parameter, Fehler);
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

{ THalt }

Constructor THalt.Create(Zustand : integer; Parameter : TStringList; Fehler : pstring);
begin
  inherited Create(Zustand, Parameter, Fehler);
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
end.
