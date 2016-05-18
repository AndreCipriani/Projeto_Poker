unit UPoker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, DBClient, Grids, DBGrids;

type
  TfmPoker = class(TForm)
    sbIniciarJogo: TSpeedButton;
    bbSair: TBitBtn;
    J1: TClientDataSet;
    J2: TClientDataSet;
    Memo1: TMemo;
    grJ1: TDBGrid;
    grJ2: TDBGrid;
    dsJ1: TDataSource;
    dsJ2: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CarregarBaralhoPoker;
    procedure CriarListasAuxiliares;
    procedure FormCreate(Sender: TObject);
    procedure sbIniciarJogoClick(Sender: TObject);
    procedure bbSairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LimparListas;
    procedure Embaralhar;
    function  Repeticoes(SubTexto, Texto: String): Integer;
    procedure CriarTabelasTemporarias(NomeDataSet: TClientDataSet);
    procedure AnalisarListaResultado(ListaResultadoJ1, ListaResultadoJ2: TStringList);
    procedure DistribuirAsCartas;
    procedure AnalisarRodada;
    function  PesquisaParcialNaLista(ListaNome: TStringList;
              TextoDePesquisa: String): Integer;
    function  TemSequencia(ListaNome: TStringList): Boolean;
    function  SequenciaMesmoNipe(ListaNome: TStringList): Boolean;
    procedure TrocarPosicaoLista(var A, B: Char);

  private
    { Private declarations }


  public
    { Public declarations }
  end;

var
  fmPoker: TfmPoker;
  ListaJ1, ListaJ2, ListaResultadoJ1, ListaResultadoJ2,
  BaralhoPoker, BaralhoPokerEmbaralhado: TStringList;


implementation

uses Math;

{$R *.dfm}

procedure TfmPoker.CarregarBaralhoPoker;
begin

  // NAIPE DE OUROS D -> “Diamonds”
  BaralhoPoker.Add('AD'); // ÁS
  BaralhoPoker.Add('1D');
  BaralhoPoker.Add('2D');
  BaralhoPoker.Add('3D');
  BaralhoPoker.Add('4D');
  BaralhoPoker.Add('5D');
  BaralhoPoker.Add('6D');
  BaralhoPoker.Add('7D');
  BaralhoPoker.Add('8D');
  BaralhoPoker.Add('9D');
  BaralhoPoker.Add('10D');
  BaralhoPoker.Add('JD'); // 11 Valete (Jack)
  BaralhoPoker.Add('QD'); // 12 Dama (Queen)
  BaralhoPoker.Add('KD'); // 13 Rei (King)

  // NAIPE DE ESPADAS S -> “Spades”
  BaralhoPoker.Add('AS'); // ÁS
  BaralhoPoker.Add('1S');
  BaralhoPoker.Add('2S');
  BaralhoPoker.Add('3S');
  BaralhoPoker.Add('4S');
  BaralhoPoker.Add('5S');
  BaralhoPoker.Add('6S');
  BaralhoPoker.Add('7S');
  BaralhoPoker.Add('8S');
  BaralhoPoker.Add('9S');
  BaralhoPoker.Add('10S');
  BaralhoPoker.Add('JS'); // 11 Valete (Jack)
  BaralhoPoker.Add('QS'); // 12 Dama (Queen)
  BaralhoPoker.Add('KS'); // 13 Rei (King)

  // NAIPE DE COPAS H -> “Hearts”
  BaralhoPoker.Add('AH'); // ÁS
  BaralhoPoker.Add('1H');
  BaralhoPoker.Add('2H');
  BaralhoPoker.Add('3H');
  BaralhoPoker.Add('4H');
  BaralhoPoker.Add('5H');
  BaralhoPoker.Add('6H');
  BaralhoPoker.Add('7H');
  BaralhoPoker.Add('8H');
  BaralhoPoker.Add('9H');
  BaralhoPoker.Add('10H');
  BaralhoPoker.Add('JH'); // 11 Valete (Jack)
  BaralhoPoker.Add('QH'); // 12 Dama (Queen)
  BaralhoPoker.Add('KH'); // 13 Rei (King)

  // NAIPE DE COPAS c -> “Clubs”
  BaralhoPoker.Add('AC'); // ÁS
  BaralhoPoker.Add('1C');
  BaralhoPoker.Add('2C');
  BaralhoPoker.Add('3C');
  BaralhoPoker.Add('4C');
  BaralhoPoker.Add('5C');
  BaralhoPoker.Add('6C');
  BaralhoPoker.Add('7C');
  BaralhoPoker.Add('8C');
  BaralhoPoker.Add('9C');
  BaralhoPoker.Add('10C');
  BaralhoPoker.Add('JC'); // 11 Valete (Jack)
  BaralhoPoker.Add('QC'); // 12 Dama (Queen)
  BaralhoPoker.Add('KC'); // 13 Rei (King)

  BaralhoPoker.Sorted := False;

  // Total de 52 cartas, separadas em 4 grupos de 13 cartas cada

end;


procedure TfmPoker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmPoker.FormCreate(Sender: TObject);
begin

  CriarListasAuxiliares;
  LimparListas;

  CriarTabelasTemporarias(J1);
  CriarTabelasTemporarias(J2);

end;

procedure TfmPoker.sbIniciarJogoClick(Sender: TObject);
begin

  CarregarBaralhoPoker;
  Embaralhar;
  
  DistribuirAsCartas;
  AnalisarRodada;

end;

procedure TfmPoker.bbSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfmPoker.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  if MessageDlg('Deseja sair do Jogo?', mtConfirmation, [mbYes, mbNo], 0) = idYes then begin
    LimparListas;
    Application.Terminate;
  end
  else
    Abort;
  
end;

procedure TfmPoker.Embaralhar;
var
  i, j: Integer;

begin

  BaralhoPokerEmbaralhado.Clear;

  for j := 0 to BaralhoPoker.Count -1  do begin
    I := Random(BaralhoPoker.Count);
    BaralhoPokerEmbaralhado.Add(BaralhoPoker[i]);
  end; // while BaralhoPokerEmbaralhado.Count < 52 do begin

end;

procedure TfmPoker.LimparListas;
begin

  ListaJ1.Clear;
  ListaJ2.Clear;
  ListaResultadoJ1.Clear;
  ListaResultadoJ2.Clear;
  BaralhoPoker.Clear;
  BaralhoPokerEmbaralhado.Clear;

end;


function TfmPoker.Repeticoes(SubTexto, Texto: String): Integer;
var
  i : Integer;

begin

  Result := 0;

  while Pos(SubTexto, Texto) <> 0 do begin
    Texto := Copy(Texto, Pos(SubTexto, Texto) + Length(SubTexto), MaxInt);
    Inc(Result);
  end; // while Pos(SubTexto, Texto) <> 0 do begin

end;

procedure TfmPoker.CriarTabelasTemporarias(NomeDataSet: TClientDataSet);
begin

  with NomeDataSet do begin

    Close;

    with FieldDefs do begin
      Clear;
      Add('Seq', ftInteger, 0, False);
      Add('C', ftString, 3, False);
    end; // with FieldDefs do begin

    CreateDataSet;
    Open;
    LogChanges := False;

  end; // with NomeDataSet do begin

end;

procedure TfmPoker.DistribuirAsCartas;
var
  i, ContJ1, ContJ2: Integer;
  J1JaTem: Boolean;
  CAux: String;

begin
  
  ListaJ1.Clear;
  ListaJ2.Clear;
  ListaResultadoJ1.Clear;
  ListaResultadoJ2.Clear;

  J1.Close;
  J2.Close;
  J1.Open;
  J2.Open;

  ContJ1 := 0;
  ContJ2 := 0;
  J1JaTem := False;

  for i := 0 to BaralhoPokerEmbaralhado.Count -1 do begin

    if J1.RecordCount = 5 then
      J1JaTem := True;

    if J1JaTem = False then begin
      Inc(ContJ1);
      J1.Append;
      if Length(BaralhoPokerEmbaralhado.Strings[i]) = 3 then
        CAux := Copy(BaralhoPokerEmbaralhado.Strings[i], 1, 2)
      else
        CAux := Copy(BaralhoPokerEmbaralhado.Strings[i], 1, 1);
      J1.FieldByName('Seq').AsInteger := ContJ1;
      J1.FieldByName('C').AsString := CAux;
      ListaJ1.Add(CAux);
      J1.Post;
      J1JaTem := True;
    end // if J1JaTem = False then begin
    else begin

      if J2.RecordCount = 5 then
        Break;

      Inc(ContJ2);
      J2.Append;

      if Length(BaralhoPokerEmbaralhado.Strings[i]) = 3 then
        CAux := Copy(BaralhoPokerEmbaralhado.Strings[i], 1, 2)
      else
        CAux := Copy(BaralhoPokerEmbaralhado.Strings[i], 1, 1);
      J2.FieldByName('Seq').AsInteger := ContJ2;
      J2.FieldByName('C').AsString := CAux;
      ListaJ2.Add(CAux);
      J2.Post;
      J1JaTem := False;

    end; // else begin

  end; // for i := 0 to BaralhoPoker.Count -1 do begin

end;

procedure TfmPoker.AnalisarListaResultado(ListaResultadoJ1,
  ListaResultadoJ2: TStringList);
var
  Msg: String;
  UmParJ1, DoisParesJ1, TrincaJ1, QuadraJ1: Boolean;
  UmParJ2, DoisParesJ2, TrincaJ2, QuadraJ2: Boolean;
  i: integer;

begin

  Msg := '';

  UmParJ1     := False;
  DoisParesJ1 := False;
  TrincaJ1    := False;
  QuadraJ1    := False;

  UmParJ2     := False;
  DoisParesJ2 := False;
  TrincaJ2    := False;
  QuadraJ2    := False;

  if ListaResultadoJ1.Count > ListaResultadoJ2.Count then
    Msg := 'J1 Ganhou';

  if ListaResultadoJ1.Count < ListaResultadoJ2.Count then
    Msg := 'J2 Ganhou';

  if ListaResultadoJ1.Count = ListaResultadoJ2.Count then begin

    UmParJ1     := PesquisaParcialNaLista(ListaResultadoJ1, 'UmPar=') >= 0;
    //DoisParesJ1 := ListaResultadoJ1.IndexOf('DoisPares=') > 0;
    TrincaJ1    := PesquisaParcialNaLista(ListaResultadoJ1, 'Trinca=') >= 0;
    QuadraJ1    := PesquisaParcialNaLista(ListaResultadoJ1, 'Quadra=') >= 0;

    UmParJ2     := PesquisaParcialNaLista(ListaResultadoJ2, 'UmPar=') >= 0;
    //DoisParesJ2 := ListaResultadoJ2.IndexOf('DoisPares=') > 0;
    TrincaJ2    := PesquisaParcialNaLista(ListaResultadoJ2, 'Trinca=') >= 0;
    QuadraJ2    := PesquisaParcialNaLista(ListaResultadoJ2, 'Quadra=') >= 0;

    if (QuadraJ1) and (QuadraJ2 = False) then
      Msg := 'Jogador 1 Ganhou'
    else
    if (QuadraJ1 = False) and (QuadraJ2) then
      Msg := 'Jogador 2 Ganhou'
    else
    if (TrincaJ1) and (TrincaJ2 = False) then
      Msg := 'Jogador 1 Ganhou'
    else
    if (TrincaJ1 = False) and (TrincaJ2) then
      Msg := 'Jogador 2 Ganhou'
    else
    if (TrincaJ1 = False) and (TrincaJ2) then
      Msg := 'Jogador 2 Ganhou'
    else
      Msg := 'Alguém Ganhou'; // rever pra comparar, pegar a carta mais alta

  end // if ListaResultadoJ1.Count = ListaResultadoJ2.Count then begin
  else
    Msg := 'Nínguem Ganhou';

  if Trim(Msg) <> ''  then
    MessageDlg(PChar(Msg), mtInformation, [mbOK], 0);

end;


procedure TfmPoker.AnalisarRodada;
var
  UmPar, DoisPares, Trinca, Quadra,
  EmSequencia, EmSequenciMesmoNipe,
  Flush, Straight: Boolean;

begin

  J1.IndexFieldNames := 'C';
  J2.IndexFieldNames := 'C';

  J1.First;
  while not J1.Eof do begin

    Quadra := (Repeticoes(J1.FieldByName('C').AsString, ListaJ1.Text) = 4);
    Trinca := (Repeticoes(J1.FieldByName('C').AsString, ListaJ1.Text) = 3);
    //DoisPares := (Repeticoes(J1.FieldByName('C').AsString, ListaJ1.Text) = 2);
    UmPar := (Repeticoes(J1.FieldByName('C').AsString, ListaJ1.Text) = 2);

    if UmPar then
      if ListaResultadoJ1.IndexOf('UmPar=' + J1.FieldByName('C').AsString)= -1  then
        ListaResultadoJ1.Add('UmPar=' + J1.FieldByName('C').AsString);

    if DoisPares then
      if ListaResultadoJ1.IndexOf('DoisPares=' + J1.FieldByName('C').AsString)= -1  then
        ListaResultadoJ1.Add('DoisPares=' + J1.FieldByName('C').AsString);

    if Trinca then
      if ListaResultadoJ1.IndexOf('Trinca=' + J1.FieldByName('C').AsString)= -1  then
        ListaResultadoJ1.Add('Trinca=' + J1.FieldByName('C').AsString);

    if Quadra then
      if ListaResultadoJ1.IndexOf('Quadra=' + J1.FieldByName('C').AsString)= -1  then
        ListaResultadoJ1.Add('Quadra=' + J1.FieldByName('C').AsString);

    J1.Next;

  end; // while not J1.Eof do begin

  EmSequencia         := False;
  EmSequenciMesmoNipe := False;
  Flush               := False;
  Straight            := False;

  if TemSequencia(ListaJ1) then
    if SequenciaMesmoNipe(ListaJ1) then
      Flush := True
    else
      Straight := True;

  J2.First;
  while not J2.Eof do begin

    Quadra := (Repeticoes(J2.FieldByName('C').AsString, ListaJ2.Text) = 4);
    Trinca := (Repeticoes(J2.FieldByName('C').AsString, ListaJ2.Text) = 3);
    //DoisPares := (Repeticoes(J2.FieldByName('C').AsString, ListaJ2.Text) = 2);
    UmPar := (Repeticoes(J2.FieldByName('C').AsString, ListaJ2.Text) = 2);

    if UmPar then
      if ListaResultadoJ2.IndexOf('UmPar=' + J2.FieldByName('C').AsString)= -1  then
        ListaResultadoJ2.Add('UmPar=' + J2.FieldByName('C').AsString);

    if DoisPares then
      if ListaResultadoJ2.IndexOf('DoisPares=' + J2.FieldByName('C').AsString)= -1  then
        ListaResultadoJ2.Add('DoisPares=' + J2.FieldByName('C').AsString);

    if Trinca then
      if ListaResultadoJ2.IndexOf('Trinca=' + J2.FieldByName('C').AsString)= -1  then
        ListaResultadoJ2.Add('Trinca=' + J2.FieldByName('C').AsString);

    if Quadra then
      if ListaResultadoJ2.IndexOf('Quadra=' + J2.FieldByName('C').AsString)= -1  then
        ListaResultadoJ2.Add('Quadra=' + J2.FieldByName('C').AsString);

    J2.Next;

  end; // while not J2.Eof do begin

  EmSequencia         := False;
  EmSequenciMesmoNipe := False;
  Flush               := False;
  Straight            := False;

  if TemSequencia(ListaJ2) then
    if SequenciaMesmoNipe(ListaJ2) then
      Flush := True
    else
      Straight := True;

  // Para verificar na tela
  Memo1.Clear;
  Memo1.Lines.Add(ListaResultadoJ1.Text);
  Memo1.Lines.Add(ListaResultadoJ2.Text);

  AnalisarListaResultado(ListaResultadoJ1, ListaResultadoJ2);

end;

procedure TfmPoker.CriarListasAuxiliares;
begin

  ListaJ1 := TStringList.Create;
  ListaJ2 := TStringList.Create;
  ListaResultadoJ1 := TStringList.Create;
  ListaResultadoJ2 := TStringList.Create;
  BaralhoPoker := TStringList.Create;
  BaralhoPokerEmbaralhado := TStringList.Create;

end;

function TfmPoker.PesquisaParcialNaLista(ListaNome: TStringList;
  TextoDePesquisa: String): Integer;
begin

  for Result := 0 to ListaNome.Count - 1 do
    if Pos(TextoDePesquisa, ListaNome[Result]) > 0 then
      Exit;

  //Se não encontrar nada retorna -1
  Result := -1;

end;

function TfmPoker.SequenciaMesmoNipe(ListaNome: TStringList): Boolean;
begin
//
end;

function TfmPoker.TemSequencia(ListaNome: TStringList): Boolean;
begin
//
end;

procedure TfmPoker.TrocarPosicaoLista(var A, B: Char);
var
  C: Char;
  
begin

  C := A;
  A := B;
  B := C;

end;

end.
