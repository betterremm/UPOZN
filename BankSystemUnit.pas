Unit BankSystemUnit;

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
    Vcl.ComCtrls,
    Vcl.StdCtrls,
    Vcl.Menus,
    Vcl.Buttons,
    Vcl.Grids;

Type
    TBankAccountType = (BASavings, BACurrent, BACard, BACorrespondent);
    TTransferResult = (TROk, TRInsufficientBalance, TrTooMuchMoney);

    TBankForm = Class(TForm)
        SGMain: TStringGrid;
        MainMenu: TMainMenu;
        SaveDialog: TSaveDialog;
        OpenDialog: TOpenDialog;
        NFile: TMenuItem;
        NOpen: TMenuItem;
        NSave: TMenuItem;
        NBlank: TMenuItem;
        NClose: TMenuItem;
        NInstr: TMenuItem;
        NDev: TMenuItem;
        CBChoice: TComboBox;
        BitBtnAdd: TBitBtn;
        BitBtnDelete: TBitBtn;
        BitBtnEdit: TBitBtn;
        BitBtnSort: TBitBtn;
        LbComboBox: TLabel;
        BitBtnShowAccounts: TBitBtn;
        BitBtnTransferMoney: TBitBtn;
        BitBtnSearch: TBitBtn;
        Procedure FormCreate(Sender: TObject);
        Function FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
        Procedure NCloseClick(Sender: TObject);
        Procedure NSaveClick(Sender: TObject);
        Procedure NDevClick(Sender: TObject);
        Procedure NInstrClick(Sender: TObject);
        Procedure CBChoiceChange(Sender: TObject);
        Procedure WorkWithClients();
        Procedure WorkWithBankAccounts();
        Procedure ShowClients();
        Procedure ShowBankAccounts();
        Procedure BitBtnAddClick(Sender: TObject);
        Procedure BitBtnDeleteClick(Sender: TObject);
        Procedure DeleteClient();
        Procedure DeleteBankAccount();
        Procedure DeleteAllClientAccounts(ClientCode: Integer);
        Function IsClientUnique(Code: Integer): Boolean;
        Function IsBankAccountUnique(AccNumber: Integer): Boolean;
        Procedure SGMainSelectCell(Sender: TObject; ACol, ARow: LongInt; Var CanSelect: Boolean);
        Procedure BitBtnEditClick(Sender: TObject);
        Procedure AddClient(Code: Integer; SurName: String);
        Procedure AddBankAccount(Code, AccNumber: Integer; Balance: Currency; AccType: TBankAccountType; CollectionPercentage: Currency);
        Function DoesClientHaveBankAccount(Code: Integer): Boolean;
        Procedure ChangeAllBankAccountCodes(Target, Replacement: Integer);
        Procedure ChangeClientCode(Target, Replacement: Integer);
        Procedure BitBtnSortClick(Sender: TObject);
        Procedure BitBtnTransferMoneyClick(Sender: TObject);
        Function TransferMoney(Sender, Recipient: Integer; Amount: Currency; SenderPaysCollection: Boolean): TTransferResult;
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure NOpenClick(Sender: TObject);
        Procedure ClearClients;
        Procedure ClearBankAccounts;
        Procedure BitBtnShowAccountsClick(Sender: TObject);
        Procedure BitBtnSearchClick(Sender: TObject);
    Private
        { Private declarations }
    Public Type

        TFileStatus = (FsOK, FsNotFound, FsLocked, FsInvalidSignature);
        TBankAccountType = TBankAccountType;
        PBankAccountNode = ^TBankAccountNode;

        TBankAccountNode = Record
            Code: Integer;
            AccNumber: Integer;
            Balance: Currency;
            AccType: TBankAccountType;
            CollectionPercentage: Currency;
            Next, Prev: PBankAccountNode;
        End;

        TBankAccountList = Record
            Head, Tail: PBankAccountNode;
        End;

        PClientNode = ^TClientNode;

        TClientNode = Record
            Code: Integer;
            SurName: String[15];
            Next, Prev: PClientNode;
        End;

        TClientList = Record
            Head, Tail: PClientNode;
        End;

    Const
        MaxCollectionPercentage = 100;

    Var
        BankAccountList: TBankAccountList;
        ClientList: TClientList;
    End;

Var
    BankForm: TBankForm;

Const
    BA_STRING_ARRAY: Array [0 .. 3] Of String = ('Сберегательный', 'Расчётный', 'Карточный', 'Корреспондентский');
    CB_CHOICE_CLIENTS = 0;
    CB_CHOICE_ACCOUNTS = 1;

Implementation

{$R *.dfm}

Uses
    DevUnit,
    InstrUnit,
    AddEditClientUnit,
    AddEditBankAccountUnit,
    TransferMoneyUnit,
    ShowUnit,
    SearchUnit;

Procedure TBankForm.ClearClients;
Var
    Temp, Curr: PClientNode;
Begin
    Curr := ClientList.Head;
    While Assigned(Curr) Do
    Begin
        Temp := Curr;
        Curr := Curr^.Next;
        Dispose(Temp);
    End;
    ClientList.Head := Nil;
    ClientList.Tail := Nil;
End;

Procedure TBankForm.ClearBankAccounts;
Var
    Temp, Curr: PBankAccountNode;
Begin
    Curr := BankAccountList.Head;
    While Assigned(Curr) Do
    Begin
        Temp := Curr;
        Curr := Curr^.Next;
        Dispose(Temp);
    End;
    BankAccountList.Head := Nil;
    BankAccountList.Tail := Nil;
End;

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

Function TBankForm.TransferMoney(Sender, Recipient: Integer; Amount: Currency; SenderPaysCollection: Boolean): TTransferResult;
Var
    SenderNode, RecipientNode: PBankAccountNode;
    Temp: PBankAccountNode;
    Collection, TempAmount: Currency;
Begin

    SenderNode := Nil;
    RecipientNode := Nil;
    Temp := BankAccountList.Head;
    While Temp <> Nil Do
    Begin
        If Temp^.AccNumber = Sender Then
            SenderNode := Temp;

        If Temp^.AccNumber = Recipient Then
            RecipientNode := Temp;

        Temp := Temp^.Next;
    End;

    Collection := RoundCurrencyTo2(Amount * SenderNode^.CollectionPercentage / 100);

    If SenderPaysCollection Then
    Begin
        TempAmount := RoundCurrencyTo2(Amount + Collection);
        If SenderNode^.Balance < TempAmount Then
            TransferMoney := TTransferResult.TRInsufficientBalance
        Else
        Begin
            If RecipientNode^.Balance + Amount > 999999999.99 Then
                TransferMoney := TTransferResult.TrTooMuchMoney
            Else
            Begin
                SenderNode^.Balance := SenderNode^.Balance - TempAmount;
                RecipientNode^.Balance := RecipientNode^.Balance + Amount;
            End;
        End;
    End
    Else
    Begin
        If SenderNode^.Balance < Amount Then
            TransferMoney := TTransferResult.TRInsufficientBalance
        Else
        Begin
            If RecipientNode^.Balance + Amount > 999999999.99 Then
                TransferMoney := TTransferResult.TrTooMuchMoney
            Else
            Begin
                SenderNode^.Balance := SenderNode^.Balance - Amount;
                RecipientNode^.Balance := RecipientNode^.Balance + Amount;
            End;
        End;
    End;

End;

Procedure SwapBankAccountNodes(N1, N2: TBankForm.PBankAccountNode);
Var
    Prev1, Next2, Temp: TBankForm.PBankAccountNode;
Begin
    If N1 <> N2 Then
    Begin

        If N2.Prev = N1 Then
        Begin
            N1.Next := N2.Next;
            N2.Prev := N1.Prev;

            If N1.Next <> Nil Then
                N1.Next.Prev := N1;
            If N2.Prev <> Nil Then
                N2.Prev.Next := N2;

            N2.Next := N1;
            N1.Prev := N2;
        End
        Else
        Begin
            Prev1 := N1.Prev;
            Next2 := N2.Next;

            If N1.Next <> Nil Then
                N1.Next.Prev := N2;
            If N2.Prev <> Nil Then
                N2.Prev.Next := N1;

            If Prev1 <> Nil Then
                Prev1.Next := N2;
            If Next2 <> Nil Then
                Next2.Prev := N1;

            Temp := N1.Next;
            N1.Next := N2.Next;
            N2.Next := Temp;

            Temp := N1.Prev;
            N1.Prev := N2.Prev;
            N2.Prev := Temp;
        End;

        If BankForm.BankAccountList.Head = N1 Then
            BankForm.BankAccountList.Head := N2
        Else
            If BankForm.BankAccountList.Head = N2 Then
                BankForm.BankAccountList.Head := N1;

        If BankForm.BankAccountList.Tail = N1 Then
            BankForm.BankAccountList.Tail := N2
        Else
            If BankForm.BankAccountList.Tail = N2 Then
                BankForm.BankAccountList.Tail := N1;
    End;
End;

Procedure TBankForm.ChangeClientCode(Target, Replacement: Integer);
Var
    TempClientNode: PClientNode;
Begin
    TempClientNode := ClientList.Head;
    While TempClientNode <> Nil Do
    Begin
        If TempClientNode^.Code = Target Then
            TempClientNode^.Code := Replacement;
        TempClientNode := TempClientNode^.Next;
    End;
End;

Procedure TBankForm.ChangeAllBankAccountCodes(Target, Replacement: Integer);
Var
    TempBankAccountNode: PBankAccountNode;
Begin
    TempBankAccountNode := BankAccountList.Head;
    While TempBankAccountNode <> Nil Do
    Begin
        If TempBankAccountNode^.Code = Target Then
            TempBankAccountNode^.Code := Replacement;
        TempBankAccountNode := TempBankAccountNode.Next;
    End;
End;

Function TBankForm.IsClientUnique(Code: Integer): Boolean;
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

Function TBankForm.IsBankAccountUnique(AccNumber: Integer): Boolean;
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

Procedure TBankForm.AddClient(Code: Integer; SurName: String);
Var
    PClient: TBankForm.PClientNode;
Begin

    If IsClientUnique(Code) Then
    Begin
        New(PClient);
        PClient^.Code := Abs(Code);
        PClient^.SurName := SurName;
        PClient^.Next := Nil;
        PClient^.Prev := BankForm.ClientList.Tail;
        If BankForm.ClientList.Head = Nil Then
        Begin
            BankForm.ClientList.Tail := PClient;
            BankForm.ClientList.Head := PClient;
        End
        Else
        Begin
            BankForm.ClientList.Tail.Next := PClient;
            BankForm.ClientList.Tail := PClient;
        End;
        BitBtnSearch.Enabled := True;
        BitBtnSearch.Visible := True;
    End
    Else
        MessageBox(BankForm.Handle, 'Клиент с таким кодом уже существует!', 'Внимание', MB_ICONWARNING + MB_OK);

End;

Procedure TBankForm.AddBankAccount(Code, AccNumber: Integer; Balance: Currency; AccType: TBankAccountType; CollectionPercentage: Currency);
Var
    PAccount: TBankForm.PBankAccountNode;
Begin

    If IsBankAccountUnique(AccNumber) Then
    Begin
        New(PAccount);
        PAccount^.Code := Abs(Code);
        PAccount^.AccNumber := Abs(AccNumber);
        PAccount^.Balance := RoundCurrencyTo2(Balance);
        PAccount^.AccType := AccType;
        PAccount^.CollectionPercentage := RoundCurrencyTo2(CollectionPercentage);
        PAccount^.Next := Nil;
        PAccount^.Prev := BankForm.BankAccountList.Tail;
        If BankForm.BankAccountList.Head = Nil Then
        Begin
            BankForm.BankAccountList.Tail := PAccount;
            BankForm.BankAccountList.Head := PAccount;
        End
        Else
        Begin
            BankForm.BankAccountList.Tail.Next := PAccount;
            BankForm.BankAccountList.Tail := PAccount;
        End;
        BitBtnSearch.Enabled := True;
        BitBtnSearch.Visible := True;
    End
    Else
        MessageBox(BankForm.Handle, 'Счет с таким номером уже существует!', 'Внимание', MB_ICONWARNING + MB_OK);
End;

Procedure DeleteBankAccountNode(DelNode: TBankForm.PBankAccountNode);
Begin
    If (DelNode.Prev = Nil) And (DelNode.Next = Nil) Then
    Begin
        BankForm.BankAccountList.Head := Nil;
        BankForm.BankAccountList.Tail := Nil;
    End
    Else
        If DelNode.Prev = Nil Then
        Begin
            BankForm.BankAccountList.Head := BankForm.BankAccountList.Head.Next;
            DelNode.Next.Prev := Nil;
        End
        Else
            If DelNode.Next = Nil Then
            Begin
                BankForm.BankAccountList.Tail := BankForm.BankAccountList.Tail.Prev;
                DelNode.Prev.Next := Nil;
            End
            Else
            Begin
                DelNode.Prev.Next := DelNode.Next;
                DelNode.Next.Prev := DelNode.Prev;
            End;
    Dispose(DelNode);
End;

Function TBankForm.DoesClientHaveBankAccount(Code: Integer): Boolean;
Var
    TempNode: PBankAccountNode;
    NotFound: Boolean;
Begin
    NotFound := True;
    TempNode := BankAccountList.Head;
    While (TempNode <> Nil) And NotFound Do
    Begin
        If TempNode^.Code = Code Then
            NotFound := False;
        TempNode := TempNode.Next;
    End;

    DoesClientHaveBankAccount := Not NotFound;

End;

Procedure TBankForm.DeleteBankAccount();
Var
    DelNode: PBankAccountNode;
    I: Integer;
Begin
    If MessageBox(BankForm.Handle, 'Вы уверены, что хотите удалить банковский аккаунт?', 'Удалить?', MB_ICONWARNING + MB_YESNO)
        = ID_YES Then
    Begin
        DelNode := BankAccountList.Head;
        For I := 2 To SGMain.Selection.Top Do
            DelNode := DelNode.Next;
        DeleteBankAccountNode(DelNode);
        If (ClientList.Head = Nil) And (BankAccountList.Head = Nil) Then
        Begin
            BitBtnSearch.Enabled := False;
            BitBtnSearch.Visible := False;
        End
        Else
        Begin
            BitBtnSearch.Enabled := True;
            BitBtnSearch.Visible := True;
        End;
        ShowBankAccounts();
    End;
End;

Procedure TBankForm.DeleteAllClientAccounts(ClientCode: Integer);
Var
    DelNode, TempNode: PBankAccountNode;
    I: Integer;
Begin
    DelNode := BankAccountList.Head;
    Repeat
        If DelNode^.Code = ClientCode Then
        Begin
            TempNode := DelNode^.Next;
            DeleteBankAccountNode(DelNode);
            DelNode := TempNode;
        End
        Else
            DelNode := DelNode^.Next;
    Until DelNode = Nil;
End;

Procedure TBankForm.DeleteClient();
Var
    I: Integer;
    DelNode: PClientNode;
    TempNode: PBankAccountNode;

Begin
    If MessageBox(BankForm.Handle, 'Вы уверены, что хотите удалить клиента?', 'Удалить?', MB_ICONWARNING + MB_YESNO) = ID_YES Then
    Begin
        DelNode := ClientList.Head;
        For I := 2 To SGMain.Selection.Top Do
            DelNode := DelNode.Next;

        If DoesClientHaveBankAccount(DelNode^.Code) And (MessageBox(BankForm.Handle, 'Вы желаете вместе с клиентом удалить все его счета?',
            'Удалить?', MB_ICONWARNING + MB_YESNO) = ID_YES) Then
            DeleteAllClientAccounts(DelNode^.Code);
        If (DelNode.Prev = Nil) And (DelNode.Next = Nil) Then
        Begin
            ClientList.Head := Nil;
            ClientList.Tail := Nil;
        End
        Else
            If DelNode.Prev = Nil Then
            Begin
                ClientList.Head := ClientList.Head.Next;
                DelNode.Next.Prev := Nil;
            End
            Else
                If DelNode.Next = Nil Then
                Begin
                    ClientList.Tail := ClientList.Tail.Prev;
                    DelNode.Prev.Next := Nil;
                End
                Else
                Begin
                    DelNode.Prev.Next := DelNode.Next;
                    DelNode.Next.Prev := DelNode.Prev;
                End;
        Dispose(DelNode);
        If (ClientList.Head = Nil) And (BankAccountList.Head = Nil) Then
        Begin
            BitBtnSearch.Enabled := False;
            BitBtnSearch.Visible := False;
        End
        Else
        Begin
            BitBtnSearch.Enabled := True;
            BitBtnSearch.Visible := True;
        End;
        ShowClients();
    End;
End;

Procedure TBankForm.ShowClients();
Var
    TempNodePointer: PClientNode;
    I: Integer;
Begin
    I := 1;
    BitBtnSort.Enabled := False;
    BitBtnSort.Visible := False;
    If ClientList.Head = Nil Then
    Begin
        SGMain.Rows[1].Clear;
        SGMain.RowCount := 2;
        BitBtnDelete.Enabled := False;
        BitBtnDelete.Visible := False;
        BitBtnEdit.Enabled := False;
        BitBtnEdit.Visible := False;
        BitBtnShowAccounts.Enabled := False;
        BitBtnShowAccounts.Visible := False;
    End
    Else
    Begin
        TempNodePointer := ClientList.Head;
        Repeat
        Begin
            SGMain.Cells[0, I] := IntToStr(TempNodePointer^.Code);
            SGMain.Cells[1, I] := TempNodePointer^.SurName;
            Inc(I);
            TempNodePointer := TempNodePointer.Next;
        End
        Until TempNodePointer = Nil;
        SGMain.RowCount := I;

    End;
End;

Procedure TBankForm.SGMainSelectCell(Sender: TObject; ACol, ARow: LongInt; Var CanSelect: Boolean);
Begin
    If ((CBChoice.ItemIndex = CB_CHOICE_CLIENTS) And (ClientList.Head <> Nil)) Or
        ((CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS) And (BankAccountList.Head <> Nil)) Then
    Begin
        BitBtnDelete.Enabled := True;
        BitBtnEdit.Enabled := True;
        BitBtnDelete.Visible := True;
        BitBtnEdit.Visible := True;
    End
    Else
    Begin
        BitBtnDelete.Enabled := False;
        BitBtnEdit.Enabled := False;
        BitBtnDelete.Visible := False;
        BitBtnEdit.Visible := False;
    End;

    If (CBChoice.ItemIndex = CB_CHOICE_CLIENTS) And (ClientList.Head <> Nil) Then
    Begin
        BitBtnShowAccounts.Enabled := True;
        BitBtnShowAccounts.Visible := True
    End
    Else
    Begin
        BitBtnShowAccounts.Enabled := False;
        BitBtnShowAccounts.Visible := False;
    End;
End;

Procedure TBankForm.ShowBankAccounts();
Var
    TempNodePointer: PBankAccountNode;
    I: Integer;
Begin
    I := 1;
    If BankAccountList.Head = Nil Then
    Begin
        SGMain.Rows[1].Clear;
        SGMain.RowCount := 2;
        BitBtnDelete.Enabled := False;
        BitBtnEdit.Enabled := False;
        BitBtnSort.Enabled := False;
        BitBtnTransferMoney.Enabled := False;
        BitBtnDelete.Visible := False;
        BitBtnEdit.Visible := False;
        BitBtnSort.Visible := False;
        BitBtnTransferMoney.Visible := False;
    End
    Else
    Begin
        TempNodePointer := BankAccountList.Head;
        Repeat
        Begin
            SGMain.Cells[0, I] := IntToStr(TempNodePointer^.Code);
            SGMain.Cells[1, I] := IntToStr(TempNodePointer^.AccNumber);
            SGMain.Cells[2, I] := CurrToStr(TempNodePointer^.Balance) + ' р.';
            SGMain.Cells[3, I] := BA_STRING_ARRAY[Ord(TempNodePointer^.AccType)];
            SGMain.Cells[4, I] := CurrToStr(TempNodePointer^.CollectionPercentage) + '%';
            Inc(I);
            TempNodePointer := TempNodePointer.Next;
        End
        Until TempNodePointer = Nil;
        BitBtnSort.Enabled := True;
        BitBtnTransferMoney.Enabled := True;
        BitBtnSort.Visible := True;
        BitBtnTransferMoney.Visible := True;
        SGMain.RowCount := I;
    End;
End;

Procedure TBankForm.WorkWithClients();
Begin
    SGMain.ColCount := 2;
    SGMain.ColWidths[0] := 150;
    SGMain.Cells[0, 0] := 'Код';
    SGMain.ColWidths[1] := 450;
    SGMain.Cells[1, 0] := 'Фамилия';

    ShowClients;
    SGMain.Visible := True;
    BitBtnAdd.Enabled := True;
    BitBtnAdd.Visible := True;
    BitBtnTransferMoney.Enabled := False;
    BitBtnTransferMoney.Visible := False;

End;

Procedure TBankForm.WorkWithBankAccounts();
Begin
    SGMain.ColCount := 5;
    SGMain.DefaultColWidth := 135;
    SGMain.Cells[0, 0] := 'Код';
    SGMain.Cells[1, 0] := 'Номер счета';
    SGMain.Cells[2, 0] := 'Баланс';
    SGMain.Cells[3, 0] := 'Тип счета';
    SGMain.ColWidths[4] := 60;
    SGMain.Cells[4, 0] := 'Сбор';

    ShowBankAccounts;
    SGMain.Visible := True;
    BitBtnAdd.Enabled := True;
    BitBtnAdd.Visible := True;
End;

Procedure TBankForm.BitBtnAddClick(Sender: TObject);
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
    Begin
        AddEditClientForm := TAddEditClientForm.Create(Self);
        AddEditClientForm.ShowModal();
        If AddEditClientForm.ClosedByButton Then
            AddClient(StrToInt(AddEditClientForm.EditCode.Text), AddEditClientForm.EditSurname.Text);
        AddEditClientForm.Destroy;
        AddEditClientForm := Nil;
        ShowClients;
    End
    Else
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
        Begin
            AddEditBankAccountForm := TAddEditBankAccountForm.Create(Self);
            AddEditBankAccountForm.ShowModal();
            If AddEditBankAccountForm.ClosedByButton Then
                With AddEditBankAccountForm Do
                Begin
                    AddBankAccount(StrToInt(EditCode.Text), StrToInt(EditAccNumber.Text), StrToCurr(EditBalance.Text),
                        TBankAccountType(CBType.ItemIndex), StrToCurr(EditCollectionPercentage.Text));
                End;
            AddEditBankAccountForm.Destroy;
            AddEditBankAccountForm := Nil;
            ShowBankAccounts;
        End;
End;

Procedure TBankForm.BitBtnDeleteClick(Sender: TObject);
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
        DeleteClient
    Else
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
            DeleteBankAccount;

End;

Procedure TBankForm.BitBtnEditClick(Sender: TObject);
Var
    I: Integer;
    TempClientPointer: PClientNode;
    TempBankAccountPointer: PBankAccountNode;
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
        With AddEditClientForm Do
        Begin

            AddEditClientForm := TAddEditClientForm.Create(Self);
            TempClientPointer := ClientList.Head;
            For I := 2 To SGMain.Selection.Top Do
                TempClientPointer := TempClientPointer.Next;

            EditCode.Text := IntToStr(TempClientPointer^.Code);
            EditSurname.Text := TempClientPointer^.Surname;
            IsFilled[1] := True;
            IsFilled[2] := True;
            BtnAccept.Enabled := True;
            ShowModal();
            If ClosedByButton Then
            Begin
                If (StrToInt(EditCode.Text) = TempClientPointer^.Code) Or IsClientUnique(StrToInt(EditCode.Text)) Then
                Begin
                    If (StrToInt(EditCode.Text) <> TempClientPointer^.Code) And DoesClientHaveBankAccount(TempClientPointer^.Code) And
                        (MessageBox(BankForm.Handle, 'Вы желаете так же изменить все аккаунты принадлежащие данному клиенту?', 'Изменить?',
                        MB_ICONWARNING + MB_YESNO) = ID_YES) Then
                        ChangeAllBankAccountCodes(TempClientPointer^.Code, StrToInt(EditCode.Text));
                    TempClientPointer^.Code := StrToInt(EditCode.Text);
                    TempClientPointer^.SurName := EditSurName.Text;
                End
                Else
                    MessageBox(BankForm.Handle, 'Изменения не были применены, клиент с таким номером уже существует.', 'Внимание!',
                        MB_ICONWARNING + MB_OK);

            End;
            Destroy;
            AddEditClientForm := Nil;
            ShowClients;
        End
    Else
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
            With AddEditBankAccountForm Do
            Begin
                AddEditBankAccountForm := TAddEditBankAccountForm.Create(Self);
                TempBankAccountPointer := BankAccountList.Head;
                For I := 2 To SGMain.Selection.Top Do
                    TempBankAccountPointer := TempBankAccountPointer.Next;

                EditCode.Text := IntToStr(TempBankAccountPointer^.Code);
                EditAccNumber.Text := IntToStr(TempBankAccountPointer^.AccNumber);
                EditBalance.Text := CurrToStr(TempBankAccountPointer^.Balance);
                CBType.ItemIndex := Ord(TempBankAccountPointer^.AccType);
                EditCollectionPercentage.Text := CurrToStr(TempBankAccountPointer^.CollectionPercentage);
                IsFilled[1] := True;
                IsFilled[2] := True;
                IsFilled[3] := True;
                IsFilled[4] := True;
                IsFilled[5] := True;
                BtnAccept.Enabled := True;
                ShowModal();
                If ClosedByButton Then
                Begin
                    If (StrToInt(EditAccNumber.Text) = TempBankAccountPointer^.AccNumber) Or
                        IsBankAccountUnique(StrToInt(EditAccNumber.Text)) Then
                    Begin
                        If (StrToInt(EditCode.Text) <> TempBankAccountPointer^.Code) And Not IsClientUnique(TempBankAccountPointer^.Code)
                            And (MessageBox(BankForm.Handle, 'Вы желаете так же изменить код клиента владельца аккаунта?', 'Изменить?',
                            MB_ICONWARNING + MB_YESNO) = ID_YES) Then
                            ChangeClientCode(TempBankAccountPointer^.Code, StrToInt(EditCode.Text));
                        TempBankAccountPointer^.Code := StrToInt(EditCode.Text);
                        TempBankAccountPointer^.AccNumber := StrToInt(EditAccNumber.Text);
                        TempBankAccountPointer^.Balance := StrToCurr(EditBalance.Text);
                        TempBankAccountPointer^.AccType := TBankAccountType(CBType.ItemIndex);
                        TempBankAccountPointer^.CollectionPercentage := StrToCurr(EditCollectionPercentage.Text);
                    End
                    Else
                        MessageBox(BankForm.Handle, 'Изменения не были применены, аккаунт с таким номером уже существует.', 'Внимание!',
                            MB_ICONWARNING + MB_OK);

                End;
                Destroy;
                AddEditClientForm := Nil;
                ShowBankAccounts;
            End;

End;

Procedure TBankForm.BitBtnSearchClick(Sender: TObject);
Var
    Code, I: Integer;
    BankAccountNode: PBankAccountNode;
    ClientNode: PClientNode;
Begin
    SearchForm := TSearchForm.Create(Self);
    SearchForm.ShowModal();
    If SearchForm.ClosedByButton Then
    Begin
        Code := StrToInt(SearchForm.EditCode.Text);
        ShowForm := TShowForm.Create(Self);
        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
        Begin
            ShowForm.WorkWithClients := False;
            I := 1;
            BankAccountNode := BankAccountList.Head;
            While BankAccountNode <> Nil Do
            Begin
                If BankAccountNode^.Code = Code Then
                Begin
                    With BankAccountNode^ Do
                        ShowForm.AddAccount(Code, AccNumber, Balance, BA_STRING_ARRAY[Ord(AccType)], CollectionPercentage, I);
                    Inc(I);
                End;
                BankAccountNode := BankAccountNode.Next;
            End;
            ShowForm.Caption := 'Поиск по коду ' + IntToStr(Code);
            ShowForm.SGShow.RowCount := I;
        End
        Else
            If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
            Begin
                ShowForm.WorkWithClients := True;
                I := 1;
                ClientNode := ClientList.Head;
                While ClientNode <> Nil Do
                Begin
                    If ClientNode^.Code = Code Then
                    Begin
                        With ClientNode^ Do
                            ShowForm.AddClient(Code, Surname, I);
                        Inc(I);
                    End;
                    ClientNode := ClientNode.Next;
                End;
                ShowForm.Caption := 'Поиск по коду ' + IntToStr(Code);
                ShowForm.SGShow.RowCount := I;
            End;

        ShowForm.ShowModal();
        ShowForm.Destroy;
        ShowForm := Nil;
    End;

    SearchForm.Destroy;
    SearchForm := Nil;
End;

Procedure TBankForm.BitBtnShowAccountsClick(Sender: TObject);
Var
    TempClientNode: PClientNode;
    TempBankAccountNode: PBankAccountNode;
    CompCode, I: Integer;
Begin
    ShowForm := TShowForm.Create(Self);
    TempClientNode := ClientList.Head;
    For I := 2 To SGMain.Selection.Top Do
        TempClientNode := TempClientNode.Next;
    CompCode := TempClientNode^.Code;
    I := 1;
    TempBankAccountNode := BankAccountList.Head;
    While TempBankAccountNode <> Nil Do
    Begin
        If TempBankAccountNode^.Code = CompCode Then
        Begin
            With TempBankAccountNode^ Do
                ShowForm.AddAccount(Code, AccNumber, Balance, BA_STRING_ARRAY[Ord(AccType)], CollectionPercentage, I);
            Inc(I);
        End;
        TempBankAccountNode := TempBankAccountNode.Next;
    End;
    ShowForm.Caption := 'Клиент ' + TempClientNode^.Surname;
    ShowForm.SGShow.RowCount := I;
    If I > 1 Then
        ShowForm.ShowModal()
    Else
        MessageBox(BankForm.Handle, 'У данного пользователя нет счетов!', 'Внимание', MB_ICONWARNING + MB_OK);

    ShowForm.Destroy;
    ShowForm := Nil;
    ShowClients;
End;

Procedure TBankForm.BitBtnSortClick(Sender: TObject);

Var
    INode, JNode: PBankAccountNode;
    Swapped: Boolean;

Begin
    If (BankAccountList.Head <> Nil) And (BankAccountList.Head.Next <> Nil) Then
        Repeat
            Swapped := False;
            INode := BankAccountList.Head;
            While (INode <> Nil) And (INode.Next <> Nil) Do
            Begin
                JNode := INode.Next;
                If INode.AccType > JNode.AccType Then
                Begin
                    SwapBankAccountNodes(INode, JNode);
                    Swapped := True;
                    If INode.Prev <> Nil Then
                        INode := INode.Prev;
                End
                Else
                    INode := INode.Next;
            End;
        Until Not Swapped;

    ShowBankAccounts();
End;

Procedure TBankForm.BitBtnTransferMoneyClick(Sender: TObject);
Var
    TrRes: TTransferResult;
Begin
    With TransferMoneyForm Do
    Begin
        TransferMoneyForm := TTransferMoneyForm.Create(Self);
        TransferMoneyForm.ShowModal();
        If TransferMoneyForm.ClosedByButton Then
            If Not IsBankAccountUnique(StrToInt(EditSender.Text)) And Not IsBankAccountUnique(StrToInt(EditRecipient.Text)) Then
            Begin
                TrRes := TransferMoney(StrToInt(EditSender.Text), StrToInt(EditRecipient.Text), StrToCurr(EditAmount.Text),
                    CBSenderPays.Checked);
                If TrRes = TTransferResult.TROk Then
                    MessageBox(BankForm.Handle, 'Перевод успешен!', 'Успех!', MB_ICONINFORMATION + MB_OK)
                Else
                    If TrRes = TTransferResult.TRInsufficientBalance Then
                        MessageBox(BankForm.Handle, 'Недостаточно средств!', 'Отклонено!', MB_ICONWARNING + MB_OK)
                    Else
                        If TrRes = TTransferResult.TrTooMuchMoney Then
                            MessageBox(BankForm.Handle, 'Запрещено держать такое количество денег на одном счете!', 'Отклонено!',
                                MB_ICONWARNING + MB_OK);

            End
            Else
                MessageBox(BankForm.Handle, 'Был введен несуществующий пользователь, перевод отклонен!', 'Внимание!',
                    MB_ICONWARNING + MB_OK);
        TransferMoneyForm.Destroy;
        TransferMoneyForm := Nil;
    End;
    ShowBankAccounts;
End;

Procedure TBankForm.CBChoiceChange(Sender: TObject);
Begin
    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
        WorkWithClients()
    Else
        WorkWithBankAccounts();
End;

Procedure TBankForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    CanClose := MessageBox(BankForm.Handle, 'Вы уверены что хотите выйти?', 'Выйти?', MB_ICONQUESTION + MB_YESNO) = ID_YES;

End;

Procedure TBankForm.FormCreate(Sender: TObject);
Begin
    BankAccountList.Head := Nil;
    BankAccountList.Tail := Nil;
    ClientList.Head := Nil;
    ClientList.Tail := Nil;
    Constraints.MaxHeight := Height;
    Constraints.MaxWidth := Width;
    Constraints.MinHeight := Height;
    Constraints.MinWidth := Width;
End;

Function TBankForm.FormHelp(Command: Word; Data: THelpEventData; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    InstrForm := TInstrForm.Create(Self);
    InstrForm.ShowModal();
    InstrForm.Destroy;
    InstrForm := Nil;
    FormHelp := True;
End;

Procedure TBankForm.NCloseClick(Sender: TObject);
Begin
    Close
End;

Procedure TBankForm.NDevClick(Sender: TObject);
Begin
    DevForm := TDevForm.Create(Self);
    DevForm.ShowModal();
    DevForm.Destroy;
    DevForm := Nil;
End;

Procedure TBankForm.NInstrClick(Sender: TObject);
Begin
    InstrForm := TInstrForm.Create(Self);
    InstrForm.ShowModal();
    InstrForm.Destroy;
    InstrForm := Nil;
End;

Function OpenBankFile(Const AFileName: String; Var ClientList: TBankForm.TClientList; Var BankAccountList: TBankForm.TBankAccountList)
    : TBankForm.TFileStatus; StdCall; External 'FileOperations.dll';
Function SaveBankFile(Const AFileName: String; ClientList: TBankForm.TClientList; BankAccountList: TBankForm.TBankAccountList)
    : TBankForm.TFileStatus; StdCall; External 'FileOperations.dll';

Procedure TBankForm.NOpenClick(Sender: TObject);
Var
    Status: TFileStatus;
    TempClientList: TClientList;
    TempBankAccountList: TBankAccountList;
Begin
    If OpenDialog.Execute Then
    Begin
        ClearClients;
        TempClientList.Head := Nil;
        TempClientList.Tail := Nil;
        TempBankAccountList.Head := Nil;
        TempBankAccountList.Tail := Nil;
        ClearBankAccounts;
        Status := OpenBankFile(OpenDialog.FileName, TempClientList, TempBankAccountList);
        Case Status Of
            FsOK:
                Begin
                    MessageBox(BankForm.Handle, 'Файл успешно загружен!', 'Успех!', MB_ICONINFORMATION + MB_OK);

                    ClearBankAccounts;
                    ClearClients;
                    BankAccountList := TempBankAccountList;
                    ClientList := TempClientList;
                    If CBChoice.ItemIndex = CB_CHOICE_CLIENTS Then
                        ShowClients
                    Else
                        If CBChoice.ItemIndex = CB_CHOICE_ACCOUNTS Then
                            ShowBankAccounts;
                End;
            FsNotFound:
                Begin
                    MessageBox(BankForm.Handle, 'Файл не был найден!', 'Внимание!', MB_ICONWARNING + MB_OK);
                    ClearClients;
                    ClearBankAccounts;
                End;
            FsLocked:
                Begin
                    MessageBox(BankForm.Handle, 'Файл занят или недоступен.', 'Внимание!', MB_ICONWARNING + MB_OK);
                    ClearClients;
                    ClearBankAccounts;
                End;
            FsInvalidSignature:
                Begin
                    MessageBox(BankForm.Handle, 'Неверная структура файла.', 'Внимание!', MB_ICONWARNING + MB_OK);
                    ClearClients;
                    ClearBankAccounts;
                End;

        End;
    End;
End;

Procedure TBankForm.NSaveClick(Sender: TObject);
Var
    Status: TFileStatus;
Begin
    If (BankAccountList.Head = Nil) Or (ClientList.Head = Nil) Then
        MessageBox(BankForm.Handle, 'Сначала добавьте хотя бы по одной записи в каждом из списков.', 'Внимание!', MB_ICONWARNING + MB_OK)
    Else
        If SaveDialog.Execute Then
        Begin
            Status := SaveBankFile(SaveDialog.FileName, ClientList, BankAccountList);
            Case Status Of
                FsOK:
                    MessageBox(BankForm.Handle, 'Файл успешно был сохранен!', 'Успех!', MB_ICONINFORMATION + MB_OK);
                FsLocked:
                    MessageBox(BankForm.Handle, 'Не удалось сохранить файл, он был занят другим процессом.', 'Внимание!',
                        MB_ICONWARNING + MB_OK)
            End;
        End;
End;

End.
