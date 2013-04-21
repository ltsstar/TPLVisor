unit interpreter;

interface

uses
  Dialogs, // ShowMessage
  turingmaschine,
  befehle;

type
  TInterpreter = class
  private
    Befehle : array of TBefehl;
  public
    Zustand : integer;
    Magnetband : TMagnetband;
    function interpretiere(Befehle : array of TBefehl) : boolean;
    function GetBefehl(Befehle : array of TBefehl; Zustand : integer; Ziel : integer) : TBefehl;
  end;

implementation

{ TInterpreter }

function TInterpreter.GetBefehl(Befehle : array of TBefehl; Zustand : integer; Ziel : integer) : TBefehl;
var
  i : integer;
begin
  if Ziel <> 0 then
  begin
    for i:=0 to High(self.Befehle) do
    begin
      if Befehle[i].Zustand = Ziel then
      begin
        Result := Befehle[i];
        exit;
      end;
    end;
  end else
  begin
    for i:=0 to High(self.Befehle) do
    begin
      if Befehle[i].Zustand = Zustand then
      begin
        // exception handling
        Result := Befehle[i+1];
        exit;
      end;
    end;
  end;
end;



function TInterpreter.interpretiere(Befehle : array of TBefehl) : boolean;
var
  Befehl : TBefehl;
begin
  if Length(Befehle) = 0 then
    exit;

  Befehl := Befehle[0];
  Befehl := self.GetBefehl(Befehle, Befehl.Zustand, Befehl.Ziel);
  
end;

end.
