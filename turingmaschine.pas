unit turingmaschine;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TMagnetband = class
  private
    Position : integer;
    Band : array of char;
    procedure ErweitereLinks;
    procedure ErweitereRechts;
  public
    procedure links;
    procedure rechts;
    procedure schreibe(wert : char);
    function hole : char;
  end;
  CMagnetband = class of TMagnetband;

  TZeichen = class
    public
      ZShape : TShape;
      ZLabel : TLabel;
      Constructor Create(AOwner : TComponent; AParent : TWinControl; ALeft: integer);
      function GetLeft : integer;
      procedure SetLeft(Left : integer);
  end;
  TTuringmaschine = class
  private
    ZeichenArrayBreite : integer;
    procedure GetZeichenArrayBreite;
    procedure ZeichenAnfuegen;
    procedure MagnetkopfErstellen;
  public
    Magnetkopf : TShape;
    Zeichen : array of TZeichen;  
    Panel : TPanel;
    Constructor Create(Panel : TPanel);
    procedure PanelResize(Sender: TObject);
    procedure VerschiebeLinks;
    procedure VerschiebeRechts;

  end;

implementation

{ TMagnetband }

procedure TMagnetband.ErweitereLinks;
var
  i : integer;
begin
  SetLength(self.Band, Length(self.Band)+1);
  for i:=High(self.Band) downto 1 do
    self.Band[i] := self.Band[i-1];
  self.Band[0] := '#';
end;

procedure TMagnetband.ErweitereRechts;
begin
  SetLength(self.Band, Length(self.Band)+1);
  self.Band[High(self.Band)] := '#';
end;

procedure TMagnetband.Links;
begin
  if self.Position = 0 then
    self.ErweitereLinks
  else
    self.Position := self.Position-1;
end;

procedure TMagnetband.Rechts;
begin
  if self.Position = High(self.Position) then
    self.ErweitereRechts;
  self.Position := self.Position+1;
end;

procedure TMagnetband.Schreibe(Wert : char);
begin
  self.Band[self.Position] := Wert;
end;

function TMagnetband.Hole : char;
begin
  Result := self.Band[self.Position];
end;

{ TZeichen }

Constructor TZeichen.Create(AOwner : TComponent; AParent : TWinControl; ALeft: integer);
begin
  self.ZShape := TShape.Create(AOwner);
  with ZShape do
  begin
    Width := 50;
    Height := 50;
    Left := ALeft;
    Top := 25;
    Shape := stRectangle;
    Parent := AParent;
  end;

  self.ZLabel := TLabel.Create(AOwner);
  with ZLabel do
  begin
    Caption := '#';  
    Left := ALeft+1;
    Top := 26;
    Parent := AParent;
    Font.Height := 48;
    Width := 48;
    Height := 48;
    Alignment := taCenter;
  end;
end;

function TZeichen.GetLeft : integer;
begin
  Result := self.ZShape.Left;
end;

procedure TZeichen.SetLeft(Left : integer);
begin
  self.ZShape.Left := Left;
  self.ZLabel.Left := Left+1;
end;

{ TTuringmaschine }

Constructor TTuringmaschine.Create(Panel : TPanel);
var
  Breite : integer;
begin
  self.Panel := Panel;
  self.MagnetKopf := TShape.Create(Panel);
  self.Panel.OnResize := self.PanelResize;

  self.ZeichenArrayBreite := 0;
  self.PanelResize(Nil);
  self.MagnetkopfErstellen;
end;

procedure TTuringmaschine.MagnetkopfErstellen;
begin
  with self.Magnetkopf do
  begin
    Width := 54;
    Height := 80;
    Top := 10;
    Left := self.Zeichen[Trunc(Length(Zeichen)/2)].GetLeft-2;
    Parent := self.Panel;
    SendToBack;
  end;
end;

procedure TTuringmaschine.GetZeichenArrayBreite;
begin
  self.ZeichenArrayBreite := self.Zeichen[High(self.Zeichen)].ZShape.Left
                              + self.Zeichen[High(self.Zeichen)].ZShape.Width
                              + 5; // 5px padding
end;

procedure TTuringmaschine.ZeichenAnfuegen;
begin
  SetLength(self.Zeichen, Length(self.Zeichen)+1);
  self.Zeichen[High(self.Zeichen)] := TZeichen.Create(self.Panel, self.Panel, self.ZeichenArrayBreite);
  self.GetZeichenArrayBreite;
end;


procedure TTuringmaschine.PanelResize(Sender: TObject);
begin
  // nach rechts auffüllen
  while self.ZeichenArrayBreite < self.Panel.Width do
    self.ZeichenAnfuegen;
end;

procedure TTuringmaschine.VerschiebeLinks;
var
  i : integer;
  Schritt : integer;
  Padding : integer;
begin
  Schritt := 10;
  if (self.Zeichen[0].ZShape.Left + Schritt - 5) >= 50 then
  begin
    // Zeichen nach Links schieben
    self.Zeichen[0].SetLeft((self.Zeichen[0].ZShape.Left + Schritt - 5) - 50);
    for i:=1 to High(Zeichen) do
      self.Zeichen[i].SetLeft(self.Zeichen[i-1].GetLeft+55);
    self.GetZeichenArrayBreite;

    // Neues Zeichen rechts anhängen!
    self.ZeichenAnfuegen;

    // Inhalte nach rechts verschieben
    for i:=High(self.Zeichen) downto 1 do
      self.Zeichen[i].ZLabel.Caption := self.Zeichen[i-1].ZLabel.Caption;
    self.Zeichen[0].ZLabel.Caption := '#';
  end else
  begin
    // Zeichen nach Rechts schieben
    for i:=0 to High(self.Zeichen) do
    begin
     self.Zeichen[i].ZShape.Left := self.Zeichen[i].ZShape.Left+Schritt;
     self.Zeichen[i].ZLabel.Left := self.Zeichen[i].ZLabel.Left+Schritt;
    end;
    self.GetZeichenArrayBreite;
  end;
  self.Magnetkopf.Left := self.Magnetkopf.Left+Schritt;
end;

procedure TTuringmaschine.VerschiebeRechts;
var
  i : integer;
  Schritt : integer;
  Padding : integer;
begin
  Schritt := 10;
  for i:=0 to High(self.Zeichen) do
  begin
    self.Zeichen[i].ZShape.Left := self.Zeichen[i].ZShape.Left-Schritt;
    self.Zeichen[i].ZLabel.Left := self.Zeichen[i].ZLabel.Left-Schritt;
  end;
  self.GetZeichenArrayBreite;
  if self.ZeichenArrayBreite < self.Panel.Width then
    self.ZeichenAnfuegen;
  self.Magnetkopf.Left := self.Magnetkopf.Left - Schritt;
end;
end.
