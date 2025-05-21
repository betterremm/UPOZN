Unit AddEditBankAccountUnit;

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
    FillArray = Array [1 .. 5] Of Boolean;

    TAddEditBankAccountForm = Class(TForm)
        EditCode: TEdit;
        LbCode: TLabel;
        BtnAccept: TButton;
        EditAccNumber: TEdit;
        LbAccNumber: TLabel;
        EditBalance: TEdit;
        LbBalance: TLabel;
        EditCollectionPercentage: TEdit;
        LbCollectionPercentage: TLabel;
        CBType: TComboBox;
        LbAccountType: TLabel;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure EditNumKeyPress(Sender: TObject; Var Key: Char);
        Procedure EditCodeChange(Sender: TObject);
        Procedure BtnAcceptClick(Sender: TObject);
        Procedure EditAccNumberChange(Sender: TObject);
        Procedure EditDecimalKeyPress(Sender: TObject; Var Key: Char);
        Procedure EditBalanceChange(Sender: TObject);
        Procedure CBTypeChange(Sender: TObject);
        Procedure EditCollectionPercentageChange(Sender: TObject);
    Private Const
        TAllowedKeys: Set Of Char = ['0' .. '9', #8, #127];

    Public
        ClosedByButton: Boolean;

    Var
        IsFilled: FillArray;
    End;

Var
    AddEditBankAccountForm: TAddEditBankAccountForm;

Implementation

{$R *.dfm}

Function IsFilledCheck(F: FillArray): Boolean;
Begin
    IsFilledCheck := F[1] And F[2] And F[3] And F[4] And F[5];
End;

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

Procedure TAddEditBankAccountForm.BtnAcceptClick(Sender: TObject);
Begin
    ClosedByButton := True;
    Close
End;

Procedure TAddEditBankAccountForm.CBTypeChange(Sender: TObject);
Begin
    IsFilled[4] := True;
    BtnAccept.Enabled := IsFilledCheck(IsFilled);
End;

Procedure TAddEditBankAccountForm.EditAccNumberChange(Sender: TObject);
Var
    Text: String;
Begin
    Text := EditAccNumber.Text;
    If Not IsCurrIntCorrect(Text) Then
    Begin
        EditAccNumber.Text := Text;
        EditAccNumber.SelStart := Length(Text);
    End;
    If Length(EditAccNumber.Text) > 0 Then
        IsFilled[2] := True
    Else
        IsFilled[2] := False;

    BtnAccept.Enabled := IsFilledCheck(IsFilled);
End;

Procedure TAddEditBankAccountForm.EditBalanceChange(Sender: TObject);
Var
    Text: String;
Begin
    Text := EditBalance.Text;
    If Not IsCurrValueCorrect(Text) Then
    Begin
        EditBalance.Text := Text;
        EditBalance.SelStart := Length(Text);
    End;
    If (Length(Text) > 9) And (StrToCurr(EditBalance.Text) > 999999999.99) Then
    Begin
        EditBalance.Text := '999999999,99';
        EditBalance.SelStart := Length(Text);
    End;

    If Length(EditBalance.Text) > 0 Then
        IsFilled[3] := True
    Else
        IsFilled[3] := False;

    BtnAccept.Enabled := IsFilledCheck(IsFilled);
End;

Procedure TAddEditBankAccountForm.EditDecimalKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Key = '.' Then
        Key := ','
    Else
        If Not((Key In TAllowedKeys) Or (Key = ',')) Then
            Key := #0;
End;

Procedure TAddEditBankAccountForm.EditCodeChange(Sender: TObject);
Var
    Text: String;
Begin
    Text := EditCode.Text;
    If Not IsCurrIntCorrect(Text) Then
    Begin
        EditCode.Text := Text;
        EditCode.SelStart := Length(Text);
    End;

    If Length(EditCode.Text) > 0 Then
        IsFilled[1] := True
    Else
        IsFilled[1] := False;

    BtnAccept.Enabled := IsFilledCheck(IsFilled);

End;

Procedure TAddEditBankAccountForm.EditCollectionPercentageChange(Sender: TObject);

Var
    Text: String;
Begin
    Text := EditCollectionPercentage.Text;
    If Not IsCurrValueCorrect(Text) Then
    Begin
        EditCollectionPercentage.Text := Text;
        EditCollectionPercentage.SelStart := Length(Text);
    End;
    If (Length(Text) > 3) And (StrToCurr(EditCollectionPercentage.Text) > 999.99) Then
    Begin
        EditCollectionPercentage.Text := '999,99';
        EditCollectionPercentage.SelStart := Length(Text);
    End;
    If Length(EditCollectionPercentage.Text) > 0 Then
        IsFilled[5] := True
    Else
        IsFilled[5] := False;

    BtnAccept.Enabled := IsFilledCheck(IsFilled);
End;

Procedure TAddEditBankAccountForm.EditNumKeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(Key In TAllowedKeys) Then
        Key := #0;
End;

Procedure TAddEditBankAccountForm.FormCreate(Sender: TObject);
Begin
    ClosedByButton := False;
    IsFilled[1] := False;
    IsFilled[2] := False;
    IsFilled[3] := False;
    IsFilled[4] := False;
    IsFilled[5] := False;
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TAddEditBankAccountForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := True;
End;

End.
