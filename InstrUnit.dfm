object InstrForm: TInstrForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'InstrForm'
  ClientHeight = 213
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHelp = FormHelp
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 105
    Height = 15
    Caption = #1055#1080#1079#1076#1086#1087#1083#1102#1081' '#1074#1080#1090#1072#1083#1103
  end
  object CloseInstrBtn: TButton
    Left = 216
    Top = 180
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = CloseInstrBtnClick
  end
end
