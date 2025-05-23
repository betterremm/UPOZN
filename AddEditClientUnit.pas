Unit AddEditClientUnit;

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
    Vcl.StdCtrls;

Type
    TAddEditClientForm = Class(TForm)
        EditCode: TEdit;
        EditSurname: TEdit;
        LbCode: TLabel;
        LbSurname: TLabel;
        BtnAccept: TButton;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure EditCodeKeyPress(Sender: TObject; Var Key: Char);
        Procedure EditCodeChange(Sender: TObject);
        Procedure EditSurnameChange(Sender: TObject);
        Procedure BtnAcceptClick(Sender: TObject);
    Private Const
        TAllowedKeys: Set Of Char = ['0' .. '9', #8, #127];

    Public
        ClosedByButton: Boolean;

    Var
        IsFilled: Array [1 .. 2] Of Boolean;
    End;

Var
    AddEditClientForm: TAddEditClientForm;

Implementation

{$R *.dfm}

Procedure TAddEditClientForm.BtnAcceptClick(Sender: TObject);
Begin
    ClosedByButton := True;
    Close
End;

Procedure TAddEditClientForm.EditCodeChange(Sender: TObject);

Begin

    If Length(EditCode.Text) > 0 Then
        IsFilled[1] := True
    Else
        IsFilled[1] := False;

    BtnAccept.Enabled := IsFilled[1] And IsFilled[2];

End;

Procedure TAddEditClientForm.EditCodeKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(Key In TAllowedKeys) Then
        Key := #0;
End;

Procedure TAddEditClientForm.EditSurnameChange(Sender: TObject);
Begin
    If EditSurname.Text = '' Then
        IsFilled[2] := False
    Else
        IsFilled[2] := True;
    BtnAccept.Enabled := IsFilled[1] And IsFilled[2];
End;

Procedure TAddEditClientForm.FormCreate(Sender: TObject);
Begin
    ClosedByButton := False;
    IsFilled[1] := False;
    IsFilled[2] := False;

    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TAddEditClientForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
