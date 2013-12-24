object TPLVisorForm: TTPLVisorForm
  Left = 538
  Top = 109
  Width = 718
  Height = 693
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'TPLVisor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    702
    634)
  PixelsPerInch = 96
  TextHeight = 13
  object AusfuehrenGB: TGroupBox
    Left = 352
    Top = 0
    Width = 343
    Height = 241
    Anchors = [akTop, akRight]
    Caption = 'Ausf'#252'hren'
    TabOrder = 0
    DesignSize = (
      343
      241)
    object Parse: TButton
      Left = 16
      Top = 192
      Width = 137
      Height = 33
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Parsen'
      TabOrder = 0
      OnClick = ParseClick
    end
    object LifeGB: TGroupBox
      Left = 8
      Top = 16
      Width = 327
      Height = 169
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Life'
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 88
        Width = 113
        Height = 13
        Caption = 'Intervallgeschwindigkeit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Ausfuehren: TButton
        Left = 8
        Top = 16
        Width = 137
        Height = 33
        Caption = 'Programm ausf'#252'hren'
        TabOrder = 0
        OnClick = AusfuehrenClick
      end
      object Pause: TButton
        Left = 176
        Top = 16
        Width = 137
        Height = 33
        Caption = 'Pause'
        TabOrder = 1
        OnClick = PauseClick
      end
      object Weiter: TButton
        Left = 176
        Top = 64
        Width = 137
        Height = 33
        Caption = 'Weiter'
        TabOrder = 2
        OnClick = WeiterClick
      end
      object Einzelschritt: TButton
        Left = 176
        Top = 113
        Width = 137
        Height = 33
        Caption = 'Einzelschritt'
        TabOrder = 3
        OnClick = EinzelschrittClick
      end
      object Reset: TButton
        Left = 8
        Top = 113
        Width = 137
        Height = 33
        Caption = 'Magnetband resetten'
        TabOrder = 4
        OnClick = ResetClick
      end
      object Intervall: TSpinEdit
        Left = 8
        Top = 64
        Width = 137
        Height = 22
        Increment = 50
        MaxValue = 10000
        MinValue = 50
        TabOrder = 5
        Value = 1000
        OnChange = IntervallChange
      end
    end
    object SofortAusfuehren: TButton
      Left = 184
      Top = 192
      Width = 137
      Height = 33
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Programm sofort ausf'#252'hren'
      TabOrder = 2
      OnClick = SofortAusfuehrenClick
    end
  end
  object ParserGB: TGroupBox
    Left = 352
    Top = 248
    Width = 343
    Height = 209
    Anchors = [akTop, akRight, akBottom]
    Caption = 'Parser'
    TabOrder = 1
    DesignSize = (
      343
      209)
    object FehlerMemo: TMemo
      Left = 6
      Top = 16
      Width = 331
      Height = 185
      Anchors = [akTop, akRight, akBottom]
      ReadOnly = True
      TabOrder = 0
    end
  end
  object TuringmaschineGB: TGroupBox
    Left = 8
    Top = 516
    Width = 688
    Height = 116
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Turingmaschine'
    TabOrder = 2
    DesignSize = (
      688
      116)
    object Band: TPanel
      Left = 8
      Top = 20
      Width = 672
      Height = 90
      Anchors = [akLeft, akRight]
      TabOrder = 0
      DesignSize = (
        672
        90)
      object BandRechts: TButton
        Left = 622
        Top = 0
        Width = 50
        Height = 89
        Anchors = [akRight]
        Caption = '>>'
        TabOrder = 0
        OnClick = BandRechtsClick
      end
      object BandLinks: TButton
        Left = 0
        Top = 0
        Width = 50
        Height = 89
        Anchors = [akLeft]
        Caption = '<<'
        TabOrder = 1
        OnClick = BandLinksClick
      end
    end
  end
  object TPLGB: TGroupBox
    Left = 8
    Top = 0
    Width = 341
    Height = 513
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'TPL'
    TabOrder = 3
    DesignSize = (
      341
      513)
    object TPLMemo: TRichEdit
      Left = 8
      Top = 16
      Width = 325
      Height = 489
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object InterpreterGB: TGroupBox
    Left = 352
    Top = 464
    Width = 343
    Height = 49
    Anchors = [akRight, akBottom]
    Caption = 'Interpreter'
    TabOrder = 4
    object InterpreterEdit: TEdit
      Left = 8
      Top = 16
      Width = 329
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
  end
  object MainMenu: TMainMenu
    Left = 664
    Top = 8
    object Datei1: TMenuItem
      Caption = 'Datei'
      object Laden1: TMenuItem
        Caption = 'Laden'
        OnClick = Laden1Click
      end
      object Speichern1: TMenuItem
        Caption = 'Speichern'
        OnClick = Speichern1Click
      end
      object Magnetband2: TMenuItem
        Caption = 'Magnetband'
        object exportieren1: TMenuItem
          Caption = 'exportieren'
          OnClick = exportieren1Click
        end
        object importieren1: TMenuItem
          Caption = 'importieren'
          OnClick = importieren1Click
        end
      end
    end
    object Informationen1: TMenuItem
      Caption = 'Informationen'
      object Schritte1: TMenuItem
        Caption = 'Schritte'
        OnClick = Schritte1Click
      end
      object Magnetband1: TMenuItem
        Caption = 'Magnetband'
        OnClick = Magnetband1Click
      end
    end
    object ber1: TMenuItem
      Caption = #220'ber'
      OnClick = ber1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 635
    Top = 8
  end
end
