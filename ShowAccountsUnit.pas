Unit ShowAccountsUnit;

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
    TShowAccountsForm = Class(TForm)
        SGShow: TStringGrid;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure AddAccount(Code, AccNumber: Integer; Balance: Currency; AccType: String; Percentage: Currency);
    Private
        { }
    Public
        { Public declarations }
    End;

Var
    ShowAccountsForm: TShowAccountsForm;

Implementation

{$R *.dfm}

Procedure TShowAccountsForm.AddAccount(Code, AccNumber: Integer; Balance: Currency; AccType: String; Percentage: Currency);
Begin
    //
End;

Procedure TShowAccountsForm.FormCreate(Sender: TObject);
Begin
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
    SGShow.ColCount := 5;
    SGShow.DefaultColWidth := 135;
    SGShow.Cells[0, 0] := 'Код';
    SGShow.Cells[1, 0] := 'Номер счета';
    SGShow.Cells[2, 0] := 'Баланс';
    SGShow.Cells[3, 0] := 'Тип счета';
    SGShow.ColWidths[4] := 60;
    SGShow.Cells[4, 0] := 'Сбор';
End;

Function TShowAccountsForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
