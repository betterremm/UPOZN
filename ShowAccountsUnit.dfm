object ShowAccountsForm: TShowAccountsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'caption'
  ClientHeight = 302
  ClientWidth = 598
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
  object SGShow: TStringGrid
    Left = -8
    Top = 0
    Width = 608
    Height = 304
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
