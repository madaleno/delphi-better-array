unit BetterArrayTests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.SysUtils,
  System.Rtti,
  BetterArray,
  DUnitX.Generics;

type
  TBetterArrayIntegerTests = class(TTestCase)
  private
    FSUT: TBetterArray<Integer>;
  published
    procedure Add;
    procedure Clear;
    procedure Compact;
    procedure Contains;
    procedure Count;
    procedure DeleteIf;
    procedure First;
    procedure FirstIndexOf;
    procedure Get;
    procedure IsEmpty;
    procedure Last;
    procedure LastIndexOf;
    procedure Map;
    procedure Join;
    procedure JoinQuoted;
    procedure Reverse;
    procedure Select;
    procedure Sort;
    procedure SortWithComparer;
    procedure ToStrings;
    procedure Unique;
  end;

  TBeatle = class
    Name: string;
    Age: Integer;
    constructor Create(Name: string; Age: Integer);
  end;

  TBetterArrayClassTests = class(TTestCase)
  private
    FSUT: TBetterArray<TBeatle>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Remove;
    procedure FreeItem;
    procedure Reverse;
    procedure SortWithComparer;
    procedure ToStrings;
    procedure Map;
    procedure Unique;
  end;

implementation

procedure TBetterArrayIntegerTests.Add;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  CheckEquals(6, FSUT.Count);
  FSUT.Add(0);
  CheckEquals(7, FSUT.Count);
  FSUT.Add([1, 2, 3]);
  CheckEquals(10, FSUT.Count);
end;

procedure TBetterArrayIntegerTests.Clear;
begin
  FSUT.Clear;
  CheckEquals(0, FSUT.Count);
end;

procedure TBetterArrayIntegerTests.Compact;
begin
  FSUT := [1, 0, 2, 0, 0, 7, 0];
  FSUT := FSUT.Compact;

  CheckEquals(3, FSUT.Count);
  CheckEquals(1, FSUT[0]);
  CheckEquals(2, FSUT[1]);
  CheckEquals(7, FSUT[2]);
end;

procedure TBetterArrayIntegerTests.Contains;
begin
  FSUT := [5, 6, 7];
  CheckTrue(FSUT.Contains(7));
  CheckFalse(FSUT.Contains(8));
end;

procedure TBetterArrayIntegerTests.Count;
begin
  FSUT := [1, 2, 3, 2, 1, 0];
  CheckEquals(6, FSUT.Count);
end;

procedure TBetterArrayIntegerTests.DeleteIf;
begin
  FSUT := [1, 4, 5, 9, 11];
  FSUT := FSUT.DeleteIf(function(Item: Integer): Boolean
    begin
      Result := Item < 10;
    end);

  CheckEquals(1, FSUT.Count);
  CheckEquals(11, FSUT[0]);
end;

procedure TBetterArrayIntegerTests.First;
begin
  FSUT := [13, 7, 1];
  CheckEquals(13, FSUT.First);
end;

procedure TBetterArrayIntegerTests.FirstIndexOf;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  CheckEquals(1, FSUT.FirstIndexOf(7));
  CheckEquals(0, FSUT.FirstIndexOf(13));
  CheckEquals(3, FSUT.FirstIndexOf(9));
end;

procedure TBetterArrayIntegerTests.Get;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  CheckEquals(1, FSUT.Get(2));
  CheckEquals(9, FSUT.Get(3));
  CheckEquals(0, FSUT.Get(99));
end;

procedure TBetterArrayIntegerTests.IsEmpty;
begin
  FSUT := [];
  CheckTrue(FSUT.IsEmpty);
end;

procedure TBetterArrayIntegerTests.LastIndexOf;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  CheckEquals(1, FSUT.LastIndexOf(7));
  CheckEquals(0, FSUT.LastIndexOf(13));
  CheckEquals(4, FSUT.LastIndexOf(9));
end;

procedure TBetterArrayIntegerTests.Map;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  FSUT := FSUT.Map(
    function(Value: Integer): Integer
    begin
      Result := Value + 10;
    end
  );

  CheckEquals(23, FSUT[0]);
  CheckEquals(17, FSUT[1]);
  CheckEquals(11, FSUT[2]);
  CheckEquals(19, FSUT[3]);
  CheckEquals(19, FSUT[4]);
  CheckEquals(12, FSUT[5]);
end;

procedure TBetterArrayIntegerTests.Reverse;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  FSUT := FSUT.Reverse;
  CheckEquals(2, FSUT[0]);
  CheckEquals(9, FSUT[1]);
  CheckEquals(9, FSUT[2]);
  CheckEquals(1, FSUT[3]);
  CheckEquals(7, FSUT[4]);
  CheckEquals(13, FSUT[5]);
end;

procedure TBetterArrayIntegerTests.Join;
begin
  FSUT := [13, 7, 1992];
  CheckEquals('13/7/1992', FSUT.Join('/'));
  CheckEquals('13,7,1992', FSUT.Join);
  CheckEquals('1371992', FSUT.Join(''));
  CheckEquals('<13> <7> <1992>', FSUT.Join(' ', '<', '>'));
end;

procedure TBetterArrayIntegerTests.JoinQuoted;
begin
  FSUT := [13, 7, 1992];
  CheckEquals('''13'',''7'',''1992''', FSUT.JoinQuoted);
  CheckEquals('''13''->''7''->''1992''', FSUT.JoinQuoted('->'));
  CheckEquals('"13" "7" "1992"', FSUT.JoinQuoted(' ', '"'));
end;

procedure TBetterArrayIntegerTests.Last;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  CheckEquals(2, FSUT.Last);
end;

procedure TBetterArrayIntegerTests.Select;
var
  EvenNumber: TFunc<Integer, Boolean>;
begin
  EvenNumber := function(Item: Integer): Boolean
    begin
      Result := Item mod 2 = 1;
    end;

  FSUT := [1, 2, 3, 4, 5, 6];
  FSUT := FSUT.Select(EvenNumber);

  CheckEquals(3, FSUT.Count);
  CheckEquals('1,3,5', FSUT.Join);
end;

procedure TBetterArrayIntegerTests.Sort;
begin
  FSUT := [13, 7, 1, 9, 9, 2];
  FSUT := FSUT.Sort;
  CheckEquals(1, FSUT[0]);
  CheckEquals(2, FSUT[1]);
  CheckEquals(7, FSUT[2]);
  CheckEquals(9, FSUT[3]);
  CheckEquals(9, FSUT[4]);
  CheckEquals(13, FSUT[5]);
end;

procedure TBetterArrayIntegerTests.SortWithComparer;
var
  EvenToOddNumbers: TComparison<Integer>;
begin
  EvenToOddNumbers :=
    function(const Left, Right: Integer): Integer
    begin
      if Left = Right then
        Exit(0);

      if Odd(Left) then
        if Odd(Right) then
          Exit(Left - Right)
        else
          Exit(-1);

      if Odd(Right) then
        Exit(1)
      else
        Exit(Left - Right);
    end;

  FSUT := [1, 2, 3, 4, 5, 6, 7, 8];
  FSUT := FSUT.Sort(EvenToOddNumbers);
  CheckEquals(1, FSUT[0]);
  CheckEquals(3, FSUT[1]);
  CheckEquals(5, FSUT[2]);
  CheckEquals(7, FSUT[3]);
  CheckEquals(2, FSUT[4]);
  CheckEquals(4, FSUT[5]);
  CheckEquals(6, FSUT[6]);
end;

procedure TBetterArrayIntegerTests.ToStrings;
var
  ToStringFunc: TFunc<Integer, string>;
begin
  ToStringFunc :=
    function(Item: Integer): string
    begin
      Result := Item.ToString;
    end;

  FSUT := [13, 7, 1992];
  CheckEquals('13/7/1992', FSUT.ToStrings(ToStringFunc).Join('/'));
end;

procedure TBetterArrayIntegerTests.Unique;
begin
  FSUT := [1, 2, 2, 3, 1, 3, 4, 5, 5];
  FSUT := FSUT.Unique;
  CheckEquals(5, FSUT.Count);
  CheckEquals('1,2,3,4,5', FSUT.Join);
end;

procedure TBetterArrayClassTests.TearDown;
begin
  inherited;
  FSUT.FreeAll;
end;

procedure TBetterArrayClassTests.ToStrings;
var
  ToStringFunc: TFunc<TBeatle, string>;
begin
  ToStringFunc :=
    function(Item: TBeatle): string
    begin
      Result := Item.Name;
    end;

  CheckEquals('John & Ringo & Paul & George', FSUT.ToStrings(ToStringFunc).Join(' & '));
end;

procedure TBetterArrayClassTests.Unique;
begin
  FSUT.Add(FSUT[0]);
  FSUT.Add(FSUT[2]);
  CheckEquals(6, FSUT.Count);
  FSUT := FSUT.Unique;
  CheckEquals(4, FSUT.Count);
end;

procedure TBetterArrayClassTests.FreeItem;
begin
  FSUT.FreeItem(3);
  FSUT.FreeItem(0);

  CheckEquals(2, FSUT.Count);
  CheckEquals('Ringo', FSUT[0].Name);
  CheckEquals('Paul', FSUT[1].Name);
end;

procedure TBetterArrayClassTests.Map;
var
  RemoveOlderThan70: TFunc<TBeatle, TBeatle>;
begin
  RemoveOlderThan70 :=
    function(Item: TBeatle): TBeatle
    begin
      if Item.Age > 70 then
      begin
        Item.Free;
        Exit(nil);
      end;

      Result := Item;
    end;
  FSUT := FSUT.Map(RemoveOlderThan70).Compact;
  CheckEquals(2, FSUT.Count);
  CheckEquals('John', FSUT[0].Name);
  CheckEquals('George', FSUT[1].Name);
end;

procedure TBetterArrayClassTests.Remove;
var
  Paul: TBeatle;
begin
  Paul := FSUT.Get(1);
  try
    FSUT.Remove(1);
    CheckEquals(3, FSUT.Count);
    CheckTrue(Assigned(Paul));
  finally
    Paul.Free;
  end;
end;

procedure TBetterArrayClassTests.Reverse;
begin
  FSUT := FSUT.Reverse;
  CheckEquals('George', FSUT[0].Name);
  CheckEquals('Paul', FSUT[1].Name);
  CheckEquals('Ringo', FSUT[2].Name);
  CheckEquals('John', FSUT[3].Name);
end;

procedure TBetterArrayClassTests.SetUp;
begin
  inherited;
  FSUT := [
    TBeatle.Create('John', 45),
    TBeatle.Create('Ringo', 77),
    TBeatle.Create('Paul', 75),
    TBeatle.Create('George', 58)
  ];
end;

procedure TBetterArrayClassTests.SortWithComparer;
var
  OrderByAge: TComparison<TBeatle>;
begin
  OrderByAge :=
    function(const Left, Right: TBeatle): Integer
    begin
      Result := Left.Age - Right.Age;
    end;

  FSUT := FSUT.Sort(OrderByAge);
  CheckEquals('John', FSUT[0].Name);
  CheckEquals('George', FSUT[1].Name);
  CheckEquals('Paul', FSUT[2].Name);
  CheckEquals('Ringo', FSUT[3].Name);
end;

constructor TBeatle.Create(Name: string; Age: Integer);
begin
  Self.Name := Name;
  Self.Age := Age;
end;

initialization
  RegisterTest(TBetterArrayIntegerTests.Suite);
  RegisterTest(TBetterArrayClassTests.Suite);

end.


