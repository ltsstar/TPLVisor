unit formtype;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

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
    Autor: TLabel;
    Informationen1: TMenuItem;
    Schritte1: TMenuItem;
    uringtabelle1: TMenuItem;
    SofortAusfuehren: TButton;
    LabeledEdit1: TLabeledEdit;
    Band: TPanel;
    BandRechts: TButton;
    BandLinks: TButton;
    Shape1: TShape;
    procedure ParseClick(Sender: TObject);
end;

