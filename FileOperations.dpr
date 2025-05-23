Library FileOperations;

Uses
    System.SysUtils,
    System.Classes,
    BankSystemUnit;

Type
    TBankAccountType = TBankForm.TBankAccountType;
    PBankAccountNode = TBankForm.PBankAccountNode;
    TBankAccountNode = TBankForm.TBankAccountNode;
    TBankAccountList = TBankForm.TBankAccountList;
    TFileStatus = TBankForm.TFileStatus;
    PClientNode = TBankForm.PClientNode;
    TClientNode = TBankForm.TClientNode;
    TClientList = TBankForm.TClientList;

    TBankAccountData = Record
        Code: Integer;
        AccNumber: Integer;
        Balance: Currency;
        AccType: TBankAccountType;
        CollectionPercentage: Currency;
    End;

    TClientData = Record
        Code: Integer;
        SurName: String[15];
    End;

    TRecordType = (RtClient, RtBankAccount);

    TUniversalRecord = Record
        RecType: TRecordType;
        Case Byte Of
            0:
                (Client: TClientData);
            1:
                (BankAccount: TBankAccountData);
    End;

Const
    ClientSigRec: TUniversalRecord = (RecType: RtClient; Client: (Code: - 999; SurName: 'SIGNATURE'));

    BankAcctSigRec: TUniversalRecord = (RecType: RtBankAccount; BankAccount: (Code: 451004; AccNumber: 44341234; Balance: 999123.0;
        AccType: BACurrent; CollectionPercentage: 23.44));

Function RoundCurrencyTo2(Value: Currency): Currency;
Var
    IntPart: Int64;
    FracPart: Currency;
    ThirdDigit: Integer;
Begin
    Value := Value * 1000;
    IntPart := Trunc(Value);
    FracPart := Value - IntPart;

    ThirdDigit := IntPart Mod 10;
    IntPart := IntPart Div 10;

    If ThirdDigit > 5 Then
        Inc(IntPart)
    Else
        If ThirdDigit = 5 Then
        Begin
            If Odd(IntPart) Then
                Inc(IntPart);
        End;

    Result := IntPart / 100;
End;

Function IsSignatureClientRecord(Const Rec: TUniversalRecord): Boolean;
Begin
    Result := (Rec.RecType = RtClient) And (Rec.Client.Code = -999) And (Rec.Client.SurName = 'SIGNATURE');
End;

Function IsSignatureBankAccountRecord(Const Rec: TUniversalRecord): Boolean;
Begin
    Result := (Rec.RecType = RtBankAccount) And (Rec.BankAccount.Code = 451004) And (Rec.BankAccount.AccNumber = 44341234) And
        (Rec.BankAccount.Balance = 999123) And (Rec.BankAccount.AccType = TBankAccountType.BACurrent) And
        (Rec.BankAccount.CollectionPercentage = 23.44);
End;

Function IsClientUnique(Code: Integer; ClientList: TClientList): Boolean;
Var
    IsUnique: Boolean;
    TempNode: PClientNode;
Begin
    IsUnique := True;

    TempNode := ClientList.Head;
    While (TempNode <> Nil) And IsUnique Do
    Begin
        If TempNode.Code = Code Then
            IsUnique := False
        Else
            TempNode := TempNode^.Next;
    End;
    IsClientUnique := IsUnique;

End;

Function IsBankAccountUnique(AccNumber: Integer; BankAccountList: TBankAccountList): Boolean;
Var
    IsUnique: Boolean;
    TempNode: PBankAccountNode;
Begin
    IsUnique := True;
    TempNode := BankAccountList.Head;
    While (TempNode <> Nil) And IsUnique Do
    Begin
        If TempNode.AccNumber = AccNumber Then
            IsUnique := False
        Else
            TempNode := TempNode^.Next;
    End;
    IsBankAccountUnique := IsUnique;
End;

Function SaveBankFile(Const AFileName: String; ClientList: TClientList; BankAccountList: TBankAccountList): TFileStatus; StdCall;
Var
    FileRec: File Of TUniversalRecord;
    CurrNode: PClientNode;
    AcctNode: PBankAccountNode;
    URec: TUniversalRecord;
    FileHandle: Boolean;
Begin
    Result := FsOK;
    Try
        AssignFile(FileRec, AFileName);
        {$I-} Reset(FileRec); {$I+}
        If IOResult = 0 Then
        Begin
            {$I-} Rewrite(FileRec); {$I+}
        End
        Else
        Begin
            {$I-} Rewrite(FileRec); {$I+}
        End;

        If IOResult <> 0 Then
        Begin
            Result := FsLocked;
        End
        Else
        Begin
            URec := ClientSigRec;
            Write(FileRec, URec);
            CurrNode := ClientList.Head;
            While Assigned(CurrNode) Do
            Begin
                URec.RecType := RtClient;
                URec.Client.Code := CurrNode^.Code;
                URec.Client.SurName := CurrNode^.SurName;
                Write(FileRec, URec);
                CurrNode := CurrNode^.Next;
            End;

            URec := BankAcctSigRec;
            Write(FileRec, URec);

            AcctNode := BankAccountList.Head;
            While Assigned(AcctNode) Do
            Begin
                URec.RecType := RtBankAccount;
                URec.BankAccount.Code := AcctNode^.Code;
                URec.BankAccount.AccNumber := AcctNode^.AccNumber;
                URec.BankAccount.Balance := AcctNode^.Balance;
                URec.BankAccount.AccType := AcctNode^.AccType;
                URec.BankAccount.CollectionPercentage := AcctNode^.CollectionPercentage;
                Write(FileRec, URec);
                AcctNode := AcctNode^.Next;
            End;

            CloseFile(FileRec);
        End;
    Except
        SaveBankFile := FsLocked;

    End;
End;

Function OpenBankFile(Const AFileName: String; Var ClientList: TClientList; Var BankAccountList: TBankAccountList): TFileStatus; StdCall;
Var
    FileRec: File Of TUniversalRecord;
    URec: TUniversalRecord;
    InClients: Boolean;
    InAccounts: Boolean;
    Fine: Boolean;
    PClient: PClientNode;
    PBankAccount: PBankAccountNode;
Begin
    OpenBankFile := FsOK;

    If Not FileExists(AFileName) Then
    Begin
        OpenBankFile := (FsNotFound);
    End
    Else
    Begin

        AssignFile(FileRec, AFileName);
        {$I-} Reset(FileRec); {$I+}
        If IOResult <> 0 Then
        Begin
            OpenBankFile := (FsLocked);
        End
        Else
        Begin
            InClients := False;
            InAccounts := False;
            Fine := True;
            While Not Eof(FileRec) And Fine Do
            Begin
                Read(FileRec, URec);

                If Not InClients Then
                Begin
                    If IsSignatureClientRecord(URec) Then
                    Begin
                        InClients := True;
                    End
                    Else
                    Begin
                        OpenBankFile := FsInvalidSignature;
                        Fine := False;
                    End;
                End
                Else
                    If InClients And Not InAccounts Then
                    Begin
                        If IsSignatureBankAccountRecord(URec) Then
                        Begin
                            InAccounts := True;
                        End
                        Else
                        Begin
                            With URec.Client Do
                            Begin
                                If IsClientUnique(Code, ClientList) Then
                                Begin
                                    New(PClient);
                                    PClient^.Code := Abs(Code);
                                    PClient^.SurName := SurName;
                                    PClient.Next := Nil;
                                    PClient.Prev := ClientList.Tail;
                                    If ClientList.Head = Nil Then
                                    Begin
                                        ClientList.Tail := PClient;
                                        ClientList.Head := PClient;
                                    End
                                    Else
                                    Begin
                                        ClientList.Tail.Next := PClient;
                                        ClientList.Tail := PClient;
                                    End;
                                End
                            End;

                        End;

                    End
                    Else
                        If InAccounts Then
                        Begin
                            With URec.BankAccount Do
                            Begin
                                If IsBankAccountUnique(AccNumber, BankAccountList) Then
                                Begin
                                    New(PBankAccount);
                                    PBankAccount^.Code := Abs(Code);
                                    PBankAccount^.AccNumber := Abs(AccNumber);
                                    PBankAccount^.Balance := RoundCurrencyTo2(Balance);
                                    PBankAccount^.AccType := AccType;
                                    PBankAccount^.CollectionPercentage := RoundCurrencyTo2(CollectionPercentage);
                                    PBankAccount.Next := Nil;
                                    PBankAccount.Prev := BankAccountList.Tail;
                                    If BankAccountList.Head = Nil Then
                                    Begin
                                        BankAccountList.Tail := PBankAccount;
                                        BankAccountList.Head := PBankAccount;
                                    End
                                    Else
                                    Begin
                                        BankAccountList.Tail.Next := PBankAccount;
                                        BankAccountList.Tail := PBankAccount;
                                    End;
                                End
                            End;
                        End;
            End;

            CloseFile(FileRec);
        End;
    End;
End;

Exports
    OpenBankFile,
    SaveBankFile;

Begin

End.
