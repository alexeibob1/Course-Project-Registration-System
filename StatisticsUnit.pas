Unit StatisticsUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeEngine,
    VCLTee.TeeFunci, VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart;

Type
    TRegion = Record
        Name: String;
        Amount: Integer;
    End;

    TRegionsArr = Array[1..6] of TRegion;

    TSubject = Record
        Name: String;
        Amount: Integer;
    End;

    TSubjectsArr = Array[1..10] of TSubject;

    TStatisticsForm = Class(TForm)
        RegionsChart: TChart;
        RegionsSeries: TPieSeries;
        FunctionAdd: TAddTeeFunction;
        SubjectsChart: TChart;
        SubjectsSeries: TPieSeries;
        AddTeeFunction1: TAddTeeFunction;
        Procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
        Procedure CountRegions(Var RegionsArr: TRegionsArr);
        Function InitialiseRegionsArr(): TRegionsArr;
        Procedure FillRegionsChart();
        Procedure FillSubjectsChart();
        Function InitialiseSubjectsArr(): TSubjectsArr;
        Procedure CountSubjects(Var SubjectsArr: TSubjectsArr);
    Public
        { Public declarations }
    End;

Var
    StatisticsForm: TStatisticsForm;

Implementation

{$R *.dfm}

Uses
    AdminUnit, DynamicListUnit;

Procedure TStatisticsForm.FormCreate(Sender: TObject);
Begin
    FillRegionsChart();
    FillSubjectsChart();
End;

Procedure TStatisticsForm.FillRegionsChart();
Var
    RegionsArr: TRegionsArr;
Begin
    RegionsArr := InitialiseRegionsArr();
    CountRegions(RegionsArr);
    With RegionsSeries do
    Begin
        AddPie(RegionsArr[1].Amount, RegionsArr[1].Name, clRed);
        AddPie(RegionsArr[2].Amount, RegionsArr[2].Name, clYellow);
        AddPie(RegionsArr[3].Amount, RegionsArr[3].Name, clGreen);
        AddPie(RegionsArr[4].Amount, RegionsArr[4].Name, clBlue);
        AddPie(RegionsArr[5].Amount, RegionsArr[5].Name, clAqua);
        AddPie(RegionsArr[6].Amount, RegionsArr[6].Name, clLime);
    End;
End;

Procedure TStatisticsForm.CountRegions(Var RegionsArr: TRegionsArr);
Var
    Curr: PList;
Begin
    Curr := Head;
    While (Curr <> Nil) do
    Begin
        If (Curr^.Data.Region = '���������') then
            Inc(RegionsArr[1].Amount)
        Else If (Curr^.Data.Region = '���������') then
            Inc(RegionsArr[2].Amount)
        Else If (Curr^.Data.Region = '����������') then
            Inc(RegionsArr[3].Amount)
        Else If (Curr^.Data.Region = '�����������') then
            Inc(RegionsArr[4].Amount)
        Else If (Curr^.Data.Region = '�������') then
            Inc(RegionsArr[5].Amount)
        Else If (Curr^.Data.Region = '����������') then
            Inc(RegionsArr[6].Amount);
        Curr := Curr^.Next;
    End;
End;

Procedure TStatisticsForm.CountSubjects(Var SubjectsArr: TSubjectsArr);
Var
    Curr: PList;
Begin
    Curr := Head;
    While (Curr <> Nil) do
    Begin
        If (Curr^.Data.Subjects[1].Status) then
            Inc(SubjectsArr[1].Amount);
        If (Curr^.Data.Subjects[2].Status) then
            Inc(SubjectsArr[2].Amount);
        If (Curr^.Data.Subjects[3].Status) then
            Inc(SubjectsArr[3].Amount);
        If (Curr^.Data.Subjects[4].Status) then
            Inc(SubjectsArr[4].Amount);
        If (Curr^.Data.Subjects[5].Status) then
            Inc(SubjectsArr[5].Amount);
        If (Curr^.Data.Subjects[6].Status) then
            Inc(SubjectsArr[6].Amount);
        If (Curr^.Data.Subjects[7].Status) then
            Inc(SubjectsArr[7].Amount);
        If (Curr^.Data.Subjects[8].Status) then
            Inc(SubjectsArr[8].Amount);
        If (Curr^.Data.Subjects[9].Status) then
            Inc(SubjectsArr[9].Amount);
        If (Curr^.Data.Subjects[10].Status) then
            Inc(SubjectsArr[10].Amount);
        Curr := Curr^.Next;
    End;
End;


Function TStatisticsForm.InitialiseRegionsArr(): TRegionsArr;
Var
    RegionsArr: TRegionsArr;
    I: Integer;
Begin
    RegionsArr[1].Name := '���������';
    RegionsArr[2].Name := '���������';
    RegionsArr[3].Name := '����������';
    RegionsArr[4].Name := '�����������';
    RegionsArr[5].Name := '�������';
    RegionsArr[6].Name := '����������';
    For I := 1 to 6 do
        RegionsArr[I].Amount := 0;
    Result := RegionsArr;
End;

Function TStatisticsForm.InitialiseSubjectsArr(): TSubjectsArr;
Var
    SubjectsArr: TSubjectsArr;
    I: Integer;
Begin
    SubjectsArr[1].Name := '���';
    SubjectsArr[2].Name := '���';
    SubjectsArr[3].Name := '���';
    SubjectsArr[4].Name := '���';
    SubjectsArr[5].Name := '���';
    SubjectsArr[6].Name := '���';
    SubjectsArr[7].Name := '���';
    SubjectsArr[8].Name := '���';
    SubjectsArr[9].Name := '���';
    SubjectsArr[10].Name := '���';
    For I := 1 to 10 do
        SubjectsArr[I].Amount := 0;
    Result := SubjectsArr;
End;

Procedure TStatisticsForm.FillSubjectsChart();
Var
    SubjectsArr: TSubjectsArr;
Begin
    SubjectsArr := InitialiseSubjectsArr();
    CountSubjects(SubjectsArr);
    With SubjectsSeries do
    Begin
        AddPie(SubjectsArr[1].Amount, SubjectsArr[1].Name, clRed);
        AddPie(SubjectsArr[2].Amount, SubjectsArr[2].Name, clYellow);
        AddPie(SubjectsArr[3].Amount, SubjectsArr[3].Name, clGreen);
        AddPie(SubjectsArr[4].Amount, SubjectsArr[4].Name, clBlue);
        AddPie(SubjectsArr[5].Amount, SubjectsArr[5].Name, clAqua);
        AddPie(SubjectsArr[6].Amount, SubjectsArr[6].Name, clLime);
        AddPie(SubjectsArr[7].Amount, SubjectsArr[7].Name, clMaroon);
        AddPie(SubjectsArr[8].Amount, SubjectsArr[8].Name, clSilver);
        AddPie(SubjectsArr[9].Amount, SubjectsArr[9].Name, clFuchsia);
        AddPie(SubjectsArr[10].Amount, SubjectsArr[10].Name, clMoneyGreen);
    End;
End;

End.
