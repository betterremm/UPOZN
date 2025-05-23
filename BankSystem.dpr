program BankSystem;





uses
  Vcl.Forms,
  BankSystemUnit in 'BankSystemUnit.pas' {BankForm},
  AddEditClientUnit in 'AddEditClientUnit.pas' {AddEditClientForm},
  DevUnit in 'DevUnit.pas',
  InstrUnit in 'InstrUnit.pas',
  AddEditBankAccountUnit in 'AddEditBankAccountUnit.pas' {AddEditBankAccountForm},
  TransferMoneyUnit in 'TransferMoneyUnit.pas' {TransferMoneyForm},
  ShowUnit in 'ShowUnit.pas' {ShowForm},
  SearchUnit in 'SearchUnit.pas' {SearchForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBankForm, BankForm);
  Application.CreateForm(TAddEditBankAccountForm, AddEditBankAccountForm);
  Application.CreateForm(TTransferMoneyForm, TransferMoneyForm);
  Application.CreateForm(TShowForm, ShowForm);
  Application.CreateForm(TSearchForm, SearchForm);
  Application.Run;
end.
