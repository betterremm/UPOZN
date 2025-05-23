Unit FileOperations;

Interface

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

Function OpenBankFile(Const AFileName: String): TFileStatus; StdCall;
Function SaveBankFile(Const AFileName: String): TFileStatus; StdCall;

Implementation

Const
    ClientSigRec: TUniversalRecord = (RecType: RtClient; Client: (Code: - 999; SurName: 'SIGNATURE'));

    BankAcctSigRec: TUniversalRecord = (RecType: RtBankAccount; BankAccount: (Code: 451004; AccNumber: 44341234; Balance: 999123.0;
        AccType: BACurrent; CollectionPercentage: 23.44));

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

Function SaveBankFile(Const AFileName: String): TFileStatus;
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
            //file exists: try rewrite to clear
            {$I-} Rewrite(FileRec); {$I+}
        End
        Else
        Begin
            //new file
            {$I-} Rewrite(FileRec); {$I+}
        End;

        If IOResult <> 0 Then
        Begin
            Result := FsLocked;
        End
        Else
        Begin
            //write signature for clients
            URec := ClientSigRec;
            Write(FileRec, URec);
            //write all clients
            CurrNode := BankForm.ClientList.Head;
            While Assigned(CurrNode) Do
            Begin
                URec.RecType := RtClient;
                URec.Client.Code := CurrNode^.Code;
                URec.Client.SurName := CurrNode^.SurName;
                Write(FileRec, URec);
                CurrNode := CurrNode^.Next;
            End;

            //write signature for bank accounts
            URec := BankAcctSigRec;
            Write(FileRec, URec);

            //write all bank accounts
            AcctNode := BankForm.BankAccountList.Head;
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

Function OpenBankFile(Const AFileName: String): TFileStatus; StdCall;
Var
    FileRec: File Of TUniversalRecord;
    URec: TUniversalRecord;
    InClients: Boolean;
    InAccounts: Boolean;
    Fine: Boolean;
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

            //initialize state
            InClients := False;
            InAccounts := False;
            Fine := True;
            While Not Eof(FileRec) And Fine Do
            Begin
                Read(FileRec, URec);

                If Not InClients Then
                Begin
                    //expect client signature
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
                            //add client node
                            BankForm.AddClient(URec.Client.Code, URec.Client.SurName);
                    End
                    Else
                        If InAccounts Then
                        Begin
                            //add bank account node
                            With URec.BankAccount Do
                                BankForm.AddBankAccount(Code, AccNumber, Balance, AccType, CollectionPercentage);
                        End;
            End;

            CloseFile(FileRec);
        End;
    End;
End;

Exports OpenBankFile, SaveBankFile;

End.
