object WatchListsForm: TWatchListsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088
  ClientHeight = 350
  ClientWidth = 682
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
  object SGUsers: TStringGrid
    Left = 0
    Top = 8
    Width = 204
    Height = 337
    ColCount = 1
    DefaultColWidth = 200
    DefaultRowHeight = 40
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 0
  end
  object SGBankAccounts: TStringGrid
    Left = 210
    Top = 8
    Width = 469
    Height = 337
    ColCount = 1
    DefaultColWidth = 465
    DefaultRowHeight = 40
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 1
  end
end
