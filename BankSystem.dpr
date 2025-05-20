program BankSystem;

uses
  Vcl.Forms,
  BankSystemUnit in 'BankSystemUnit.pas' {BankForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBankForm, BankForm);
  Application.Run;
end.
