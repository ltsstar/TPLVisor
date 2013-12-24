// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  Interpreterklasse
*)


unit TPLInterpreter;

interface

uses
  Dialogs, // ShowMessage
  SysUtils, // IntToStr
  TPLTuringmaschine,
  TPLParser,
  TPLMagnetband,
  TPLBefehle;

type
  TInterpreter = class
  private
    Turingmaschine : TTuringmaschine;
    Parser : TParser;
  public
    Form : TObject;
    Befehl : TBefehl;
    Stop : boolean;
    Schritte : integer;
    Constructor Create(Form : TObject; Turingmaschine : TTuringmaschine; Parser : TParser);
    procedure SortiereNachZustand;
    procedure ErsterBefehl;
    procedure KeinBefehl;
    function ZeileFuerZustand(Zustand : integer) : integer;    
    function BefehlFuerZustand(Zustand : integer) : TBefehl;
    procedure NaechsterBefehl;
    procedure interpretiere;
  end;

implementation

uses TPLVisorMain;

{ TInterpreter }

Constructor TInterpreter.Create(Form : TObject; Turingmaschine : TTuringmaschine; Parser : TParser);
begin
  self.Turingmaschine := Turingmaschine;
  self.Parser := Parser;
  self.Form := Form;
  self.SortiereNachZustand;
  self.ErsterBefehl;
end;

procedure TInterpreter.SortiereNachZustand;
var
  i : integer;
  Befehl : TBefehl;
begin
  for i:=1 to High(self.Parser.Befehle) do
  begin
    if self.Parser.Befehle[i].Zustand < self.Parser.Befehle[i-1].Zustand then
    begin
      Befehl := self.Parser.Befehle[i];
      self.Parser.Befehle[i] := self.Parser.Befehle[i-1];
      self.Parser.Befehle[i-1] := Befehl;
      self.SortiereNachZustand;
      break;
    end;
  end;
end;

procedure TInterpreter.ErsterBefehl;
begin
  self.Befehl := self.Parser.Befehle[0];
end;

procedure TInterpreter.KeinBefehl;
begin
  TTPLVisorForm(self.Form).Timer1.Enabled := False;
  TTPLVisorForm(self.Form).InterpreterEdit.Text := 'Error: Kein Befehl';
end;

function TInterpreter.BefehlFuerZustand(Zustand : integer) : TBefehl;
var
  i : integer;
begin
  Result := nil;
  for i:=0 to High(self.Parser.Befehle) do
  begin
    if self.Parser.Befehle[i].Zustand = Zustand then begin
      Result := self.Parser.Befehle[i];
      exit;
    end;
  end;
end;

procedure TInterpreter.NaechsterBefehl;
var
  i : integer;
  Befehl : TBefehl;
begin
  Befehl := self.Befehl;
  for i:=0 to High(self.Parser.Befehle)-1 do
  begin
    if self.Parser.Befehle[i] = self.Befehl then
    begin
      self.Befehl := self.Parser.Befehle[i+1];
      break;
    end;
  end;
  if self.Befehl = Befehl then
    self.Befehl := nil;
end;

function TInterpreter.ZeileFuerZustand(Zustand : integer) : integer;
var
  i : integer;
begin
  Result := -1;
  for i:=0 to High(self.Parser.Befehle) do
  begin
    if self.Parser.Befehle[i].Zustand = Zustand then
    begin
      Result := i;
      exit;
    end;
  end;
end;

procedure TInterpreter.interpretiere;
var
  Erg : boolean;
begin
  if self.Befehl = nil then
  begin
    self.KeinBefehl;
    exit;
  end;
  self.Schritte := self.Schritte+1;
  TTPLVisorForm(self.Form).RotFaerben(self.Befehl.Start,self.Befehl.Ende);
  erg := self.Befehl.Interpretieren(self.Turingmaschine);
  if (erg = False) and (self.Befehl.Befehl = 'halt') then
  begin
    Stop := True;
    exit;
  end
  else if (erg = True) and (self.Befehl.Befehl = 'case') then
  begin
    self.Befehl := self.BefehlFuerZustand(self.Befehl.Ziel);
    exit;
  end;
  self.NaechsterBefehl;
end;

end.
