/// TView ���ǵǰ� ������ �����̴�.
unit View;

interface

uses
  ObserverList, ValueList,
  Classes, SysUtils;

type
  ///  Core���� UI ��ü���� �޽����� �����ϴ� ������ ��� �� �ش�.
  TView = class (TComponent)
  private
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
  protected
    FObserverList : TObserverList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// �޽����� ���� �� ��ü�� ����Ѵ�.
    procedure Add(Observer:TObject);  

    /// Observer���� �޽��� ������ �ߴ��Ѵ�.
    procedure Remove(Observer:TObject);  

    /// ��� �� ��� Observer���� �޽����� �����Ѵ�.
    procedure AsyncBroadcast(AMsg:string);

    /// TCore�� �ʱ�ȭ �ƴ�.
    procedure sp_Initialize;

    /// TCore�� ����ó���� ���۵ƴ�.
    procedure sp_Finalize;    

    /// ��� View ��ü���� ���� �Ǿ���.
    procedure sp_ViewIsReady;  

    /// �ý��� ���ο��� ��� �޽����� ����ϰ��� �� �� ���δ�.
    procedure sp_SystemMessage(AMsg:string; AColor:TColor=clRed);

    /// ���α׷� ����
    procedure sp_Terminate(AMsg:string);

published
    /// �޽��� ���� ���� ��?
    property Active : boolean read GetActive write SetActive;  
  end;

implementation

{ TView }

procedure TView.Add(Observer: TObject);
begin
  FObserverList.Add(Observer);
end;

procedure TView.AsyncBroadcast(AMsg: string);
begin
  FObserverList.AsyncBroadcast( AMsg );
end;

constructor TView.Create(AOwner: TComponent);
begin
  inherited;

  FObserverList := TObserverList.Create(nil);
end;

destructor TView.Destroy;
begin
  FreeAndNil(FObserverList);

  inherited;
end;

function TView.GetActive: boolean;
begin
  Result := FObserverList.Active;
end;

procedure TView.Remove(Observer: TObject);
begin
  FObserverList.Remove(Observer);
end;

procedure TView.SetActive(const Value: boolean);
begin
  FObserverList.Active := Value;
end;

procedure TView.sp_Finalize;
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'Finalize';
    FObserverList.Broadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TView.sp_Initialize;
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'Initialize';
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TView.sp_SystemMessage(AMsg: string; AColor: TColor);
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'SystemMessage';
    Params.Values['Msg'] := AMsg;
    Params.Integers['Color'] := AColor;

    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TView.sp_Terminate(AMsg: string);
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'Terminate';
    Params.Values['Msg']  := AMsg;

    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TView.sp_ViewIsReady;
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'ViewIsReady';
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

end.