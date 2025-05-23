Unit ShowUnit;

Interface

Uses
    Winapi.Windows,
    Winapi.Messages,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Forms,
    Vcl.Dialogs,
    Vcl.Grids;

Type
    TShowForm = Class(TForm)
        SGShow: TStringGrid;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure AddAccount(Code, AccNumber: Integer; Balance: Currency; AccType: String; CollectionPercentage: Currency; I: Integer);
        Procedure AddClient(Code: Integer; Surname: String; I: Integer);
        Procedure FormShow(Sender: TObject);
    Private
        { }
    Public
        WorkWithClients: Boolean;
    End;

Var
    ShowForm: TShowForm;

Implementation

{$R *.dfm}

Procedure TShowForm.AddClient(Code: Integer; Surname: String; I: Integer);
Begin
    SGShow.Cells[0, I] := IntToStr(Code);
    SGShow.Cells[1, I] := SurName;
End;

Procedure TShowForm.AddAccount(Code, AccNumber: Integer; Balance: Currency; AccType: String; CollectionPercentage: Currency; I: Integer);
Begin
    SGShow.Cells[0, I] := IntToStr(Code);
    SGShow.Cells[1, I] := IntToStr(AccNumber);
    SGShow.Cells[2, I] := CurrToStr(Balance) + ' р.';
    SGShow.Cells[3, I] := AccType;
    SGShow.Cells[4, I] := CurrToStr(CollectionPercentage) + '%';
End;

Procedure TShowForm.FormCreate(Sender: TObject);
Begin
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;

End;

Function TShowForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

Procedure TShowForm.FormShow(Sender: TObject);
Begin
    If WorkWithClients Then
    Begin
        SGShow.ColCount := 2;
        SGShow.ColWidths[0] := 150;
        SGShow.Cells[0, 0] := 'Код';
        SGShow.ColWidths[1] := 450;
        SGShow.Cells[1, 0] := 'Фамилия';
    End
    Else
    Begin
        SGShow.ColCount := 5;
        SGShow.DefaultColWidth := 135;
        SGShow.Cells[0, 0] := 'Код';
        SGShow.Cells[1, 0] := 'Номер счета';
        SGShow.Cells[2, 0] := 'Баланс';
        SGShow.Cells[3, 0] := 'Тип счета';
        SGShow.ColWidths[4] := 60;
        SGShow.Cells[4, 0] := 'Сбор';
    End;
End;

End.
