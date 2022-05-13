Unit DynamicListUnit;

Interface

Uses
    SysUtils;

Type
    TSubject = Record
        Status: Boolean;
    End;

    TSubjArr = Array[1..10] of TSubject;

    TRequest = Record
        Username: String[10];
        Surname: String[15];
        Name: String[15];
        BirthDate: TDate;
        SeriesPassport: String[2];
        PassportNumber: String[7];
        InstituteType: String[15];
        Region: String[11];
        Subjects: TSubjArr;
    End;

    RequestsFile = File of TRequest;

    PList = ^TList;
    TList = Record
        Data: TRequest;
        Visible: Boolean;
        Next: PList;
    End;

Var
    Head, Tail: PList;

Procedure ClearList();

Procedure AddRequest(Var CurrRequest: PList; Request: TRequest);

Procedure DeleteRequest(Var CurrRequest: PList);

Function CheckUserRequest(Username: String): PList;

Procedure DownloadList();

Procedure MakeVisible();

Procedure SortList(Filter: Integer);

Procedure SortedInsert(Var NewNode, Sorted: PList; Filter: Integer);

Implementation

Procedure ClearList();
Var
    Curr, Temp: PList;
Begin
    Curr := Head;
    While (Curr <> Nil) do
    Begin
        Temp := Curr^.Next;
        Dispose(Curr);
        Curr := Temp;
    End;
End;

Procedure AddRequest(Var CurrRequest: PList; Request: TRequest);
Var
    NewRecord, Last: PList;
Begin
    If (CurrRequest = Nil) then
    Begin
        New(CurrRequest);
        CurrRequest^.Data := Request;
        CurrRequest^.Next := Nil;
        If (Head = Nil) then
            Head := CurrRequest;
        If (Tail <> Nil) then
        Begin
            Last := Tail;
            Tail := CurrRequest;
            Last^.Next := CurrRequest;
        End;
        Tail := CurrRequest;
    End
    Else
        CurrRequest^.Data := Request;
End;

Procedure DeleteRequest(Var CurrRequest: PList);
Var
    Temp, Curr: PList;
Begin
    If (CurrRequest = Head) and (CurrRequest = Tail) then
    Begin
        Dispose(CurrRequest);
        Head := Nil;
        Tail := Nil;
    End
    Else If (CurrRequest = Head) then
    Begin
        Temp := Head;
        Head := CurrRequest^.Next;
        Dispose(Temp);
    End
    Else If (CurrRequest = Tail) then
    Begin
        Curr := Head;
        While (Curr^.Next <> Tail) do
            Curr := Curr^.Next;
        Temp := Curr;
        Dispose(Curr^.Next);
        Temp^.Next := Nil;
        Tail := Temp;
    End
    Else
    Begin
        Curr := Head;
        While (Curr^.Next <> CurrRequest) do
            Curr := Curr^.Next;
        Temp := Curr^.Next;
        Curr^.Next := Curr^.Next^.Next;
        Dispose(Temp);
    End;
End;

Function CheckUserRequest(Username: String): PList;
Var
    Curr: PList;
Begin
    Curr := Head;
    While (Curr <> Nil) and (Curr^.Data.Username <> Username) do
        Curr := Curr^.Next;
    Result := Curr;
End;

Procedure DownloadList();
Var
    Request: TRequest;
    NewRecord, Last: PList;
    InputFile: RequestsFile;
Begin
    AssignFile(InputFile, 'UsersData.txt');
    If (FileExists('UsersData.txt')) then
        Reset(InputFile)
    Else
        Rewrite(InputFile);
    Head := Nil;
    Tail := Nil;
    While Not (EOF(InputFile)) do
    Begin
        Read(InputFile, Request);
        New(NewRecord);
        NewRecord^.Data := Request;
        NewRecord^.Visible := True;
        NewRecord^.Next := Nil;
        If (Head = Nil) then
        Begin
            Head := NewRecord;
        End;
        If (Tail <> Nil) then
        Begin
            Last := Tail;
            Tail := NewRecord;
            Last^.Next := NewRecord;
        End;
        Tail := NewRecord;
    End;
    CloseFile(InputFile);
End;

Procedure MakeVisible();
Var
    Curr: PList;
Begin
    Curr := Head;
    While (Curr <> Nil) do
    Begin
        Curr^.Visible := True;
        Curr := Curr^.Next;
    End;
End;

Procedure SortedInsert(Var NewNode, Sorted: PList; Filter: Integer);
Var
    Curr: PList;
Begin
    If (Sorted = Nil)
        or ((Filter = 1) and (AnsiUpperCase(Sorted^.Data.Surname) >= AnsiUpperCase(NewNode^.Data.Surname)))
        or ((Filter = 2) and (Sorted^.Data.BirthDate >= NewNode^.Data.BirthDate)) then
    Begin
        NewNode^.Next := Sorted;
        Sorted := NewNode;
    End
    Else
    Begin
        Curr := Sorted;
        While (Curr^.Next <> Nil) and (((AnsiUpperCase(Curr^.Next.Data.Surname) < AnsiUpperCase(NewNode^.Data.Surname)) and (Filter = 1))
            or (Curr^.Next.Data.BirthDate < NewNode^.Data.BirthDate) and (Filter = 2)) do
            Curr := Curr^.Next;
        NewNode^.Next := Curr^.Next;
        Curr^.Next := NewNode;
    End;
End;

Procedure SortList(Filter: Integer);
Var
    Sorted, Curr, NewNode, Next: PList;
Begin
    Curr := Head;
    Sorted := Nil;
    While (Curr <> Nil) do
    Begin
        Next := Curr^.Next;

        SortedInsert(Curr, Sorted, Filter);

        Curr := Next;
    End;
    Head := Sorted;
    Curr := Head;
    If (Curr <> Nil) then
        While (Curr^.Next <> Nil) do
            Curr := Curr^.Next;
    Tail := Curr;
End;

end.
