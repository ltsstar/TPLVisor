unit TPLVisorMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, parser, befehle, interpreter, turingmaschine;

type
  TTPLVisorForm = class(TForm)
    TPLMemo: TMemo;
    Parse: TButton;
    Ausfuehren: TButton;
    Einzelschritt: TButton;
    AusfuehrenGB: TGroupBox;
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Laden1: TMenuItem;
    Speichern1: TMenuItem;
    OnlineLaden1: TMenuItem;
    OnlineSpeichern1: TMenuItem;
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
    uringtabelle1: TMenuItem;
    SofortAusfuehren: TButton;
    Intervall: TLabeledEdit;
    Band: TPanel;
    BandRechts: TButton;
    BandLinks: TButton;
    Timer1: TTimer;
    Magnetband1: TMenuItem;
    procedure ParseClick(Sender: TObject);
    procedure AusfuehrenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure BandLinksClick(Sender: TObject);
    procedure BandRechtsClick(Sender: TObject);
    procedure Magnetband1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Parser : TParser;
    Turingmaschine : TTuringmaschine;
    Interpreter : TInterpreter;
  public
    { Public-Deklarationen }
  end;

var
  TPLVisorForm: TTPLVisorForm;

implementation

{$R *.dfm}

procedure TTPLVisorForm.ParseClick(Sender: TObject);
begin
  self.FehlerMemo.Clear;
  self.Parser := TParser.Create(self.FehlerMemo);
  self.Parser.Parse(self.TPLMemo.Lines);
end;

procedure TTPLVisorForm.AusfuehrenClick(Sender: TObject);
begin
  try
    self.Timer1.Interval := strtoint(self.Intervall.Text);
    self.Timer1.Enabled := True;

    self.Turingmaschine := TTuringmaschine.Create(Band);
  except
  end;
end;

procedure TTPLVisorForm.Timer1Timer(Sender: TObject);
begin
  self.Interpreter.interpretiere(self.Parser.Befehle);
end;


procedure TTPLVisorForm.PauseClick(Sender: TObject);
begin
  self.Turingmaschine := TTuringmaschine.Create(Band);
end;

procedure TTPLVisorForm.BandLinksClick(Sender: TObject);
begin
  self.Turingmaschine.VerschiebeLinks;
end;

procedure TTPLVisorForm.BandRechtsClick(Sender: TObject);
begin
  self.Turingmaschine.VerschiebeRechts;
end;

procedure TTPLVisorForm.Magnetband1Click(Sender: TObject);
begin
  ShowMessage(inttostr(Length(self.Turingmaschine.Zeichen)));
end;

end.
