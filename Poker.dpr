program Poker;

uses
  Forms,
  UPoker in 'Shared\UPoker.pas' {fmPoker};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmPoker, fmPoker);
  Application.Run;
end.
