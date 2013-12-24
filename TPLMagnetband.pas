// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  Magnetband
*)

unit TPLMagnetband;

interface
uses
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Menus,
  Dialogs, // Show Message
  SysUtils, // Format
  TPLZeichen;

type
  TMagnetband = class
  private
    Form : TObject;
  public
    ErstesZeichen : TZeichenKette; // Performance
    LetztesZeichen : TZeichenKette;
    Position : TZeichenKette;
    Padding : integer;
    Laenge : integer; // Performance
    procedure ErweitereLinks;
    procedure ErweitereRechts;
    procedure ZeigeLinks;
    procedure ZeigeRechts;
    procedure links;
    procedure rechts;
    procedure schreibe(wert : char);
    function hole : char;

    //View
    function GetRechtsMax : integer;

    //constructor / destructor
    constructor Create(Form : TObject);
    destructor Destroy; Reintroduce;
  end;
  CMagnetband = class of TMagnetband;

implementation

uses TPLVisorMain;

{ TMagnetband }

constructor TMagnetband.Create(Form : TObject);
begin
  self.Form := TTPLVisorForm(Form);
  self.Position := TZeichenKette.Create;
  self.ErstesZeichen := self.Position;
  self.LetztesZeichen := self.Position;
  self.Padding := TTPLVisorForm(self.Form).Padding;

  self.Position.Zeichen.Anzeigen(self.Form, 0);
  self.Laenge := 1;
  self.Position.Zeichen.ZEdit.Color := clRed;
end;

destructor TMagnetband.Destroy;
var
  Zeichen : TZeichenKette;
begin
  Zeichen := self.ErstesZeichen;
  while Zeichen <> self.LetztesZeichen do
  begin
    Zeichen := TZeichenKette(Zeichen.Naechstes);
    TZeichenKette(Zeichen.Vorheriges).Destroy;
  end;
  Zeichen.Destroy;
end;

procedure TMagnetband.ErweitereLinks;
var
  Zeichen : TZeichenKette;
begin
  Zeichen := TZeichenKette.Create;
  self.ErstesZeichen.Vorheriges := TZeichenKette(Zeichen);
  Zeichen.Naechstes := self.ErstesZeichen;

  Zeichen.Zeichen.Anzeigen(self.Form,
                                      self.ErstesZeichen.Zeichen.ZShape.Left -
                                      self.ErstesZeichen.Zeichen.ZShape.Width -
                                      self.Padding);
  self.ErstesZeichen := Zeichen;
  self.Laenge := self.Laenge+1;
end;

procedure TMagnetband.ErweitereRechts;
var
  Zeichen : TZeichenKette;
begin
  Zeichen := TZeichenKette.Create;
  self.LetztesZeichen.Naechstes := TZeichenKette(Zeichen);
  Zeichen.Vorheriges := self.LetztesZeichen;

  Zeichen.Zeichen.Anzeigen(self.Form,
                                      self.LetztesZeichen.Zeichen.ZShape.Left +
                                      self.LetztesZeichen.Zeichen.ZShape.Width +
                                      self.Padding);
  self.LetztesZeichen := Zeichen;
  self.Laenge := self.Laenge+1;
end;
procedure TMagnetband.ZeigeLinks;
var
  Zeichen : TZeichenKette;
begin
  Zeichen := self.ErstesZeichen;
  while Zeichen <> nil do
  begin
    TTPLVisorForm(self.Form).VerschiebeZeichen(Zeichen.Zeichen, TTPLVisorForm(self.Form).Schritt);
    Zeichen := TZeichenKette(Zeichen.Naechstes);
  end;

  while self.ErstesZeichen.Zeichen.ZShape.Left > 0 do
    self.ErweitereLinks;
end;

procedure TMagnetband.ZeigeRechts;
var
  Zeichen : TZeichenKette;
begin
  Zeichen := self.ErstesZeichen;
  while Zeichen <> nil do
  begin
    TTPLVisorForm(self.Form).VerschiebeZeichen(Zeichen.Zeichen, -TTPLVisorForm(self.Form).Schritt);
    Zeichen := TZeichenKette(Zeichen.Naechstes);
  end;
  
  while self.GetRechtsMax < TTPLVisorForm(self.Form).Band.Width do
    self.ErweitereRechts;
end;

procedure TMagnetband.Links;
begin
  self.Position.Zeichen.ZEdit.Color := clWhite;
  if self.Position.Vorheriges = nil then
    self.ErweitereLinks
  else
    self.Position := TZeichenKette(self.Position.Vorheriges);
  self.Position.Zeichen.ZEdit.Color := clRed;    
end;

procedure TMagnetband.Rechts;
begin
  self.Position.Zeichen.ZEdit.Color := clWhite;
  if self.Position.Naechstes = nil then
    self.ErweitereRechts;
  self.Position := TZeichenKette(self.Position.Naechstes);
  self.Position.Zeichen.ZEdit.Color := clRed;
end;

procedure TMagnetband.Schreibe(Wert : char);
begin
  self.Position.Zeichen.ZEdit.Text := Wert;
end;

function TMagnetband.Hole : char;
begin
  Result := self.Position.Zeichen.ZEdit.Text[1];
end;

function TMagnetband.GetRechtsMax : integer;
begin
  Result := self.LetztesZeichen.Zeichen.ZShape.Left + self.LetztesZeichen.Zeichen.ZShape.Width + self.Padding;
end;
end.
