// ##################################
// # TPLVisor - Michel Kunkler 2013 #
// ##################################

(*
  Diese Unit ist für die GUI verantwortlich.
  Hier werden sämtliche Anzeigerelevante Operationen durchgeführt.
  Außerdem finden sich hier die Eingangspunkte für die Events der meisten Objekte.

  Sämtliche andere Units sind im InterfaceTeil bereits eingebunden.
*)

unit TPLVisorMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, Spin,
  TPLParser,
  TPLInterpreter,
  TPLTuringmaschine,
  TPLMagnetband,
  TPLZeichen,
  TPLBefehle,
  TPLErrors;

type
  TTPLVisorForm = class(TForm)
    Parse: TButton;
    Ausfuehren: TButton;
    Einzelschritt: TButton;
    AusfuehrenGB: TGroupBox;
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Laden1: TMenuItem;
    Speichern1: TMenuItem;
    ber1: TMenuItem;
    ParserGB: TGroupBox;
    FehlerMemo: TMemo;    
    Weiter: TButton;
    Pause: TButton;
    TuringmaschineGB: TGroupBox;
    TPLGB: TGroupBox;
    LifeGB: TGroupBox;
    Informationen1: TMenuItem;
    Schritte1: TMenuItem;
    SofortAusfuehren: TButton;
    Band: TPanel;
    BandRechts: TButton;
    BandLinks: TButton;
    Timer1: TTimer;
    Magnetband1: TMenuItem;
    Reset: TButton;
    InterpreterGB: TGroupBox;
    InterpreterEdit: TEdit;
    TPLMemo: TRichEdit;
    Intervall: TSpinEdit;
    Label1: TLabel;
    Magnetband2: TMenuItem;
    exportieren1: TMenuItem;
    importieren1: TMenuItem;
    procedure ParseClick(Sender: TObject);
    procedure AusfuehrenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BandLinksClick(Sender: TObject);
    procedure BandRechtsClick(Sender: TObject);
    procedure Magnetband1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure ber1Click(Sender: TObject);
    procedure Schritte1Click(Sender: TObject);
    procedure SofortAusfuehrenClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure WeiterClick(Sender: TObject);
    procedure EinzelschrittClick(Sender: TObject);
    procedure Laden1Click(Sender: TObject);
    procedure Speichern1Click(Sender: TObject);
    procedure IntervallChange(Sender: TObject);
    procedure exportieren1Click(Sender: TObject);
    procedure importieren1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Parser : TParser;
    Turingmaschine : TTuringmaschine;
    Interpreter : TInterpreter;
  public
    { Public-Deklarationen }
    Padding : integer;
    Schritt : integer;
    procedure RotFaerben(Start : integer; Ende : integer);
    procedure CreateZeichen(ZShape : TShape; ZEdit : TEdit; VLeft : integer);
    procedure VerschiebeZeichen(Zeichen : TObject; Wert : integer);
  end;

var
  TPLVisorForm: TTPLVisorForm;

implementation


{$R *.dfm}

(*
  Färbt Text im Codememo (TPLMemo) rot.
  Start : Erwartet die Startposition, beginnent bei 0
  Ende  : Erwartet die Endposition.
*)
procedure TTPLVisorForm.RotFaerben(Start : integer; Ende : integer);
begin
  // alles auf schwarz setzen
  self.TPLMemo.SelStart := 0;
  self.TPLMemo.SelLength := -1;
  self.TPLMemo.SelAttributes.Color := clBlack;

  // Bereich rot färben
  self.TPLMemo.SelStart := Start;
  self.TPLMemo.SelLength := Ende-Start;
  self.TPLMemo.SelAttributes.Color := clRed;
end;

(*
  Gibt einem erzeugtem Zeichen des Magnetbands seine Eigenschaften.
  ZShape : Shape Objekt des Zeichens
  ZEdit  : Edit Objekt des Zeichens
  VLeft  : Position "Left" des ZShape Objekts.
*)
procedure TTPLVisorForm.CreateZeichen(ZShape : TShape; ZEdit : TEdit; VLeft : integer);
begin
  ShowMessage('gerde');
  with ZShape do
  begin
    Width := 50;
    Height := 50;
    Left := VLeft;
    Top := 25;
    Shape := stRectangle;
    Parent := self.Band;
    SendToBack();
  end;

  with ZEdit do
  begin
    AutoSize := False;
    Text := '#';
    Left := VLeft+1;
    Top := 26;
    Parent := self.Band;
    Font.Height := 48;
    Width := 48;
    Height := 48;
    SendToBack;
  end;
end;

(*
  Verschiebt ein Zeichen um einen gewünschten Wert.
  Zeichen : Zu verschiebendes Zeichen.
  Wert    : Weite um die das Zeichen verschoben wird in Pixel.
            Positive Werte -> Rechts,
            Negative WErte -> Links.
*)
procedure TTPLVisorForm.VerschiebeZeichen(Zeichen : TObject; Wert : integer);
begin
  TZeichen(Zeichen).ZShape.Left := TZeichen(Zeichen).ZShape.Left+Wert;
  TZeichen(Zeichen).ZEdit.Left := TZeichen(Zeichen).ZShape.Left+1;
end;

(*
  Event, das beim Klicken auf den Butten "Parsen" aufgerufen wird.
  Erzeugt eine Parserinstanz (neu) und ruft die Methode "Parse(TStringList)" auf.
*)
procedure TTPLVisorForm.ParseClick(Sender: TObject);
begin
  self.FehlerMemo.Clear;
  if self.Parser <> nil then
    self.Parser.Destroy;
  self.Parser := TParser.Create(self.FehlerMemo);
  TParser(self.Parser).Parse(self.TPLMemo.Lines);
end;

(*
  Event, das beim Klicken auf "Programm ausführen" aufgerufen wird.
  Erzeugt eine Interpreterinstanz (neu) und startet den Interpretertimer (Timer1).
*)
procedure TTPLVisorForm.AusfuehrenClick(Sender: TObject);
begin
  if self.Parser = nil then
  begin
    ShowMessage(InterpreterError.NichtGeparst);
    exit;
  end;
  try
    self.Intervall.Color := clWindow;
    self.Timer1.Interval := self.Intervall.Value;
    self.Timer1.Enabled := True;

    if self.Interpreter <> nil then
      self.Interpreter.Destroy;

    self.Interpreter := TInterpreter.Create(self, self.Turingmaschine, self.Parser);
  except
    self.Intervall.Color := clRed;
  end;
end;

(*
  Event, das nach einem festgelegten Timerintervall aufgerufen wird.
  Ruft die Methode "interpretiere" der Interpreterinstanz auf.
*)
procedure TTPLVisorForm.Timer1Timer(Sender: TObject);
begin
  if self.Interpreter.Stop then
  begin
    self.InterpreterEdit.Text := 'Programm beendet.';
    self.Timer1.Enabled := False;
  end else
  begin
    self.Interpreter.interpretiere;
  end;
end;

(*
  Event, das beim klicken auf "<<" aufgerufen wird.
  Verschiebt die Ansicht des Magnetbandes nach links.
*)
procedure TTPLVisorForm.BandLinksClick(Sender: TObject);
begin
  if self.Turingmaschine <> nil then
    self.Turingmaschine.Magnetband.ZeigeLinks;
end;

(*
  Event, das beim klicken auf ">>" aufgerufen wird.
  Verschiebt die Ansicht des Magnetbandes nach rechts.
*)
procedure TTPLVisorForm.BandRechtsClick(Sender: TObject);
begin
  if self.Turingmaschine <> nil then
    self.Turingmaschine.Magnetband.ZeigeRechts;
end;

(*
  Event, das beim klicken auf "Informationen->Magnetband" im Hauptmenü aufgerufen wird.
  Zeigt die größe des Magnetbandes.
*)
procedure TTPLVisorForm.Magnetband1Click(Sender: TObject);
begin
  ShowMessage(inttostr(self.Turingmaschine.Magnetband.Laenge));
end;

(*
  Event, das beim Starten des Programmes aufgerufen wird.
*)
procedure TTPLVisorForm.FormCreate(Sender: TObject);
begin
  self.Padding := 10; // 10 px padding zwischen Magnetbandelementen
  self.Schritt := 20; // Schrittlaenge = 20 px
    self.Turingmaschine := TTuringmaschine.Create(self);
end;

(*
  Event, das beim klicken auf "Magnetband resetten" aufgerufen wird.
  Erzeugt die Instanz der Klasse TTuringmaschine neu.
*)
procedure TTPLVisorForm.ResetClick(Sender: TObject);
begin
 if self.Turingmaschine <> nil then
 begin
   self.Turingmaschine.Destroy;
   self.Turingmaschine := TTuringmaschine.Create(self);
 end;
end;

(*
  Event, das beim klicken auf "Über" im Hauptmenü aufgerufen wird.
*)
procedure TTPLVisorForm.ber1Click(Sender: TObject);
begin
  ShowMessage('Michel Kunkler - 2013');
end;

(*
  Event, das beim klicken auf "Informationen->Schritte" im Hauptmenü aufgerufen wird.
  Zeigt die Anzahl der Schritte, die die Turingmaschine abgearbeitet hat an.
*)
procedure TTPLVisorForm.Schritte1Click(Sender: TObject);
begin
  if self.Interpreter <> nil then
    ShowMessage(inttostr(self.Interpreter.Schritte));
end;

(*
  Event, das beim klicken auf "Sofort ausführen" aufgerufen wird.
  Ruft die Methode "interpretiere" der Turingmaschine so lange auf, bis die Turingmaschine
  angehalten hat.
*)
procedure TTPLVisorForm.SofortAusfuehrenClick(Sender: TObject);
begin
  self.ParseClick(self);
  if self.Parser <> nil then
  begin
    self.Interpreter := TInterpreter.Create(self, self.Turingmaschine, self.Parser);
    while self.Interpreter.Stop <> True do self.Interpreter.interpretiere;
  end;
end;

(*
  Event, das beim klicken auf "Pause" aufgerufen wird.
  Pausiert die Ausführung der Turingmaschine.
*)
procedure TTPLVisorForm.PauseClick(Sender: TObject);
begin
  if self.Interpreter <> nil then
    self.Timer1.Enabled := False;
end;

(*
  Event, das beim klicken auf "Weiter" aufgerufen wird.
  Setzt die Ausführung der Turingmaschine fort.
*)
procedure TTPLVisorForm.WeiterClick(Sender: TObject);
begin
  if self.Interpreter <> nil then
    self.Timer1.Enabled := True;
end;

(*
  Event, das beim klicken auf "Einzelschritt" aufgerufen wird.
  Interpretiert einen Befehl.
*)
procedure TTPLVisorForm.EinzelschrittClick(Sender: TObject);
begin
  if (self.Interpreter <> nil) and (self.Interpreter.Stop = False) then
    self.Interpreter.interpretiere;
end;

(*
  Event, das beim klicken auf "Datei->Laden" im Hauptmenü aufgerufen wird.
  Lädt Code in das Codememo (TPLMemo)
*)
procedure TTPLVisorForm.Laden1Click(Sender: TObject);
var
  OpenDialog : TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  OpenDialog.Filter := 'TPLVisor Code|*.tpl';
  if OpenDialog.Execute then
    self.TPLMemo.Lines.LoadFromFile(OpenDialog.FileName);
end;

(*
  Event, das beim klicken auf "Datei->Speichern" im Hauptmenü aufgerufen wird.
  Speichert den Code des Codememos (TPLMemo)
*)
procedure TTPLVisorForm.Speichern1Click(Sender: TObject);
var
  SaveDialog : TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(self);
  SaveDialog.Filter := 'TPLVisor Code|*.tpl';
  SaveDialog.DefaultExt := 'tpl';
  if SaveDialog.Execute then
    self.TPLMemo.Lines.SaveToFile(SaveDialog.FileName);
end;

(*
  Event, das beim ändern der Intervallgeschwindigkeit aufgerufen wird.
*)
procedure TTPLVisorForm.IntervallChange(Sender: TObject);
begin
  try
    self.Timer1.Interval := self.Intervall.Value;
  except
  end;
end;

(*
  Event, das beim klicken auf "Datei->Magnetband->exportieren" im Hauptmenü aufgerufen wird.
  Speichert das Magnetband als Zeichenkette.
*)
procedure TTPLVisorForm.exportieren1Click(Sender: TObject);
var
  SaveDialog : TSaveDialog;
  Text : TStringList;
begin
  if self.Turingmaschine = nil then exit;
  SaveDialog := TSaveDialog.Create(self);
  SaveDialog.Filter := 'TPLVisor Magnetband|*.tub';
  SaveDialog.DefaultExt := 'tub';
  if SaveDialog.Execute then
  begin
    Text := TStringList.Create;
    Text.Add(self.Turingmaschine.MagnetbandToString);
    Text.SaveToFile(SaveDialog.FileName);
  end;

end;

(*
  Event, das beim klicken auf "Datei->Magnetband->importieren" im Hauptmenü aufgerufen wird.
  Lädt ein Magnetband von einer Datei.
*)
procedure TTPLVisorForm.importieren1Click(Sender: TObject);
var
  OpenDialog : TOpenDialog;
  Text : TStringList;
begin
  if self.Turingmaschine = nil then exit;
  OpenDialog := TOpenDialog.Create(self);
  OpenDialog.Filter := 'TPLVisor Magnetband|*.tub';
  if OpenDialog.Execute then
  begin
    Text := TStringList.Create;
    Text.LoadFromFile(OpenDialog.FIleName);
    self.Turingmaschine.StringToMagnetband(Text[0]);
  end;

end;

end.
