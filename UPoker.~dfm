object fmPoker: TfmPoker
  Left = 211
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Poker - The Game'
  ClientHeight = 361
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbIniciarJogo: TSpeedButton
    Left = 24
    Top = 16
    Width = 137
    Height = 73
    Cursor = crHandPoint
    Caption = 'Iniciar Jogo'
    OnClick = sbIniciarJogoClick
  end
  object Label1: TLabel
    Left = 296
    Top = 96
    Width = 47
    Height = 13
    Caption = 'Jogador 1'
  end
  object Label2: TLabel
    Left = 400
    Top = 96
    Width = 47
    Height = 13
    Caption = 'Jogador 2'
  end
  object bbSair: TBitBtn
    Left = 408
    Top = 304
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = '&Sair'
    TabOrder = 0
    OnClick = bbSairClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 192
    Width = 241
    Height = 105
    TabOrder = 1
  end
  object grJ1: TDBGrid
    Left = 296
    Top = 112
    Width = 81
    Height = 185
    DataSource = dsJ1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'C'
        Title.Caption = 'Cartas'
        Visible = True
      end>
  end
  object grJ2: TDBGrid
    Left = 400
    Top = 112
    Width = 81
    Height = 185
    DataSource = dsJ2
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'C'
        Title.Caption = 'Cartas'
        Visible = True
      end>
  end
  object J1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 296
    Top = 8
  end
  object J2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 408
    Top = 8
  end
  object dsJ1: TDataSource
    DataSet = J1
    Left = 304
    Top = 48
  end
  object dsJ2: TDataSource
    DataSet = J2
    Left = 408
    Top = 40
  end
end
