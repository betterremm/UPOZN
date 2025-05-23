Unit TransferMoneyUnit;

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
    TTransferMoneyForm = Class(TForm)
        EditSender: TEdit;
        EditRecipient: TEdit;
        EditAmount: TEdit;
        LbSender: TLabel;
        LbRecipient: TLabel;
        Label1: TLabel;
        BtnAccept: TButton;
        CBSenderPays: TCheckBox;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure EditAmountChange(Sender: TObject);
        Procedure EditAmountKeyPress(Sender: TObject; Var Key: Char);
        Procedure EditRecipientKeyPress(Sender: TObject; Var Key: Char);
        Procedure EditRecipientChange(Sender: TObject);
        Procedure EditSenderChange(Sender: TObject);
        Procedure BtnAcceptClick(Sender: TObject);
    Private Const
        TAllowedKeys: Set Of Char = ['0' .. '9', #8, #127];
    Public
        IsFilled: Array [1 .. 3] Of Boolean;
        ClosedByButton: Boolean;
    End;

Var
    TransferMoneyForm: TTransferMoneyForm;

Implementation

{$R *.dfm}

Function IsCurrIntCorrect(Var Text: String): Boolean;
Var
    I: Integer;
    Value: Currency;
    IsCorrect: Boolean;
Begin
    I := 1;
    IsCorrect := True;

    While I <= Length(Text) Do
    Begin

        If Not(Text[I] In ['0' .. '9']) Then
        Begin
            Delete(Text, I, 1);
            IsCorrect := False;
        End
        Else
            Inc(I);
    End;

    If (Text <> '') And (IntToStr(StrToInt(Text)) <> Text) Then
    Begin
        IsCorrect := False;
        Text := CurrToStr(StrToCurr(Text));
    End;

    IsCurrIntCorrect := IsCorrect;

End;

Function IsCurrValueCorrect(Var Text: String): Boolean;
Var
    I, NumsAfterDotCount: Integer;
    Value: Currency;
    IsCorrect, DotFound: Boolean;
Begin
    I := 1;
    IsCorrect := True;
    DotFound := False;
    NumsAfterDotCount := Low(Integer);

    While I <= Length(Text) Do
    Begin
        If NumsAfterDotCount > 2 Then
        Begin
            Delete(Text, I, Length(Text) - I + 1);
            IsCorrect := False;
        End
        Else
            If Text[I] = ',' Then
            Begin
                If I = 1 Then
                Begin
                    Text := '0' + Text;
                    IsCorrect := False;
                    I := I + 2;
                    NumsAfterDotCount := 0;
                    Inc(NumsAfterDotCount);
                    DotFound := True;

                End
                Else
                    If DotFound Then
                    Begin
                        Delete(Text, I, 1);
                        IsCorrect := False;
                    End
                    Else
                    Begin
                        DotFound := True;
                        NumsAfterDotCount := 0;
                        Inc(I);
                        Inc(NumsAfterDotCount);
                    End;
            End
            Else
                If Not(Text[I] In ['0' .. '9']) Then
                Begin
                    Delete(Text, I, 1);
                    IsCorrect := False;
                End
                Else
                Begin
                    Inc(I);
                    Inc(NumsAfterDotCount);
                End;
    End;

    If (Length(Text) > 1) And Not(Text.StartsWith('0,')) And (Text[1] = '0') And (CurrToStr(StrToCurr(Text)) <> Text) Then
    Begin
        IsCorrect := False;
        Text := CurrToStr(StrToCurr(Text));
    End;

    IsCurrValueCorrect := IsCorrect;
End;

Procedure TTransferMoneyForm.BtnAcceptClick(Sender: TObject);
Begin
    ClosedByButton := True;
    Close
End;

Procedure TTransferMoneyForm.EditAmountChange(Sender: TObject);
Var
    Text: String;
Begin
    Text := EditAmount.Text;
    If Not IsCurrValueCorrect(Text) Then
    Begin
        EditAmount.Text := Text;
        EditAmount.SelStart := Length(Text);
    End;
    If (Length(Text) > 0) And (StrToCurr(EditAmount.Text) > 999999999.99) Then
    Begin
        EditAmount.Text := '999999999,99';
        EditAmount.SelStart := Length(Text);
    End;

    If (Length(EditAmount.Text) > 0) And (StrToCurr(EditAmount.Text) > 0) Then
        IsFilled[3] := True
    Else
        IsFilled[3] := False;

    BtnAccept.Enabled := IsFilled[1] And IsFilled[2] And IsFilled[3];
End;

Procedure TTransferMoneyForm.EditAmountKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Key = '.' Then
        Key := ','
    Else
        If Not((Key In TAllowedKeys) Or (Key = ',')) Then
            Key := #0;
End;

Procedure TTransferMoneyForm.EditRecipientChange(Sender: TObject);
Var
    Text: String;
Begin
    Text := EditRecipient.Text;
    If Not IsCurrIntCorrect(Text) Then
    Begin
        EditRecipient.Text := Text;
        EditRecipient.SelStart := Length(Text);
    End;
    If Length(EditRecipient.Text) > 0 Then
        IsFilled[2] := True
    Else
        IsFilled[2] := False;

    BtnAccept.Enabled := IsFilled[1] And IsFilled[2] And IsFilled[3];
End;

Procedure TTransferMoneyForm.EditRecipientKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(Key In TAllowedKeys) Then
        Key := #0;
End;

Procedure TTransferMoneyForm.EditSenderChange(Sender: TObject);

Var
    Text: String;
Begin
    Text := EditSender.Text;
    If Not IsCurrIntCorrect(Text) Then
    Begin
        EditSender.Text := Text;
        EditSender.SelStart := Length(Text);
    End;
    If Length(EditSender.Text) > 0 Then
        IsFilled[1] := True
    Else
        IsFilled[1] := False;

    BtnAccept.Enabled := IsFilled[1] And IsFilled[2] And IsFilled[3];
End;

Procedure TTransferMoneyForm.FormCreate(Sender: TObject);
Begin
    IsFilled[1] := False;
    IsFilled[2] := False;
    IsFilled[3] := False;
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TTransferMoneyForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
