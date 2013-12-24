// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  Turingmaschine

  Befehle werden beim Interpretieren der Befehlsobjekte aufgerufen.
  Hat ein Magnetband als Attribut.
  Kann das Magnetband als String speichern oder laden.
*)

unit TPLTuringmaschine;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus,
  TPLMagnetband,
  TPLZeichen;

type
  TTuringmaschine = class
  private
    Form : TObject;
    procedure ZeichenAnfuegen;
  public
    Magnetband : TMagnetband;
    Panel : TPanel;
    Constructor Create(Form : TObject);
    Destructor Destroy; Reintroduce;
    procedure PanelResize(Sender: TObject);

    procedure BefehlLinks;
    procedure BefehlRechts;
    procedure BefehlSchreibe(Wert : char);
    function BefehlSpringeWenn(Wert : char; Ziel : integer) : boolean;
    function BefehlHole : char;

    function MagnetbandToString : string;
    procedure StringToMagnetband(Text : string);

  end;

implementation

uses TPLVisorMain;
{ TTuringmaschine }

Constructor TTuringmaschine.Create(Form : TObject);
begin
  self.Form := TTPLVisorForm(Form);
  self.Panel := TTPLVisorForm(self.Form).Band;
  self.Magnetband := TMagnetband.Create(self.Form);
  TTPLVisorForm(Form).Band.OnResize := self.PanelResize;

  self.PanelResize(Nil);
  //self.CreateMagnetkopf;
end;

Destructor TTuringmaschine.Destroy;
begin
  self.Magnetband.Destroy;
end;

procedure TTuringmaschine.ZeichenAnfuegen;
begin
  self.Magnetband.ErweitereRechts;
end;

procedure TTuringmaschine.PanelResize(Sender: TObject);
begin
  // Magnetband nach rechts auffüllen
  while self.Magnetband.GetRechtsMax < self.Panel.Width do
    self.ZeichenAnfuegen;
end;

procedure TTuringmaschine.BefehlLinks;
begin
  self.Magnetband.links;
end;

procedure TTuringmaschine.BefehlRechts;
begin
  self.Magnetband.rechts;
end;

procedure TTuringmaschine.BefehlSchreibe(Wert : char);
begin
  self.Magnetband.Position.Zeichen.ZEdit.Text := Wert;
end;

function TTuringmaschine.BefehlSpringeWenn(Wert : char; Ziel : integer) : boolean;
begin
  Result := False;
  if self.Magnetband.Position.Zeichen.ZEdit.Text = Wert then
    Result := True;
end;

function TTuringmaschine.BefehlHole : char;
begin
  Result := self.Magnetband.hole;
end;

function TTuringmaschine.MagnetbandToString : string;
var
  Position : TZeichenKette;
begin
  Position := self.Magnetband.ErstesZeichen;
  Result := '';
  while Position <> nil do
  begin
    Result := Result+Position.Zeichen.ZEdit.Text;
    Position := TZeichenKette(Position.Naechstes);
  end;
end;

procedure TTuringmaschine.StringToMagnetband(Text : string);
var
  i : integer;
  Position : TZeichenKette;
begin
  self.Magnetband.Destroy;
  self.Magnetband := TMagnetband.Create(self.Form);

  Position := self.Magnetband.ErstesZeichen;
  for i:=1 to Length(Text) do
  begin
    Position.Zeichen.ZEdit.Text := Text[i];
    self.Magnetband.ErweitereRechts;
    Position := TZeichenKette(Position.Naechstes);
  end;
  self.PanelResize(nil);
end;
end.
