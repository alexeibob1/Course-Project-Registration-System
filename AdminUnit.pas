Unit AdminUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.WinXCtrls, UserUnit,
    Vcl.Menus, Vcl.ExtCtrls, DynamicListUnit, VclTee.TeeGDIPlus,
    VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series, StatisticsUnit, HelpUnit,
    Vcl.Imaging.pngimage;

Const
    SURNAME_SORT = 1;
    AGE_SORT = 2;

Type
    TAdminForm = class(TForm)
        AdminStringGrid: TStringGrid;
        UserSearchBox: TSearchBox;
        MainMenu: TMainMenu;
        HelpButton: TMenuItem;
        HeadingLabel: TLabel;
        SortLabel: TLabel;
        SortingPanel: TPanel;
        DefaultRadioButton: TRadioButton;
        SurnameRadioButton: TRadioButton;
        AgeRadioButton: TRadioButton;
        FilterPanel: TPanel;
        FilterLabel: TLabel;
        RegionEdit: TComboBox;
        RegionCheckBox: TCheckBox;
        InstituteCheckBox: TCheckBox;
        InstituteEdit: TComboBox;
        ConfirmFilterButton: TButton;
        ClearFilterButton: TButton;
        ExitButton: TMenuItem;
        StatisticsButton: TButton;
        BackgroundImage: TImage;
        Procedure FormCreate(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        Procedure RegionEditKeyPress(Sender: TObject; var Key: Char);
        Procedure RegionCheckBoxClick(Sender: TObject);
        Procedure InstituteCheckBoxClick(Sender: TObject);
        Procedure SurnameRadioButtonClick(Sender: TObject);
        Procedure AgeRadioButtonClick(Sender: TObject);
        Procedure DefaultRadioButtonClick(Sender: TObject);
        Procedure UserSearchBoxChange(Sender: TObject);
        Procedure ClearFilterButtonClick(Sender: TObject);
        Procedure ConfirmFilterButtonClick(Sender: TObject);
        Procedure ExitButtonClick(Sender: TObject);
        Procedure StatisticsButtonClick(Sender: TObject);
        Procedure HelpButtonClick(Sender: TObject);
    Private
        Procedure FillUsersInfo();
        Procedure FillGrid();
        Procedure ClearGrid();
        Procedure AddSearchUser(Data: TRequest);
        Procedure CheckFilters();
    Public
        { Public declarations }
    End;

Var
    AdminForm: TAdminForm;

Implementation

{$R *.dfm}

Procedure TAdminForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ModalResult: Integer;
Begin
    ModalResult := Application.MessageBox('Вы уверены, что хотите выйти?','Выход', MB_OKCANCEL + MB_ICONQUESTION);
    If (ModalResult = 1) then
    Begin
        CanClose := True;
        ClearList();
    End
    Else
        CanClose := False;
End;

Procedure TAdminForm.FormCreate(Sender: TObject);
Var
    I: Integer;
Begin
    FillGrid();
    DownloadList();
    FillUsersInfo();
    If (Head = Nil) then
        StatisticsButton.Enabled := False;
End;

Procedure TAdminForm.HelpButtonClick(Sender: TObject);
Var
    HelpForm: THelpForm;
Begin
    Try
        HelpForm := THelpForm.Create(Self);
        HelpForm.ShowModal();
    Finally
        HelpForm.Free();
    End;
End;

Procedure TAdminForm.FillGrid();
Var
    I: Integer;
Begin
    With AdminStringGrid do
    Begin
        Cells[0,0] := 'Фамилия';
        Cells[1,0] := 'Имя';
        Cells[2,0] := 'Дата рождения';
        Cells[3,0] := 'Серия';
        Cells[4,0] := 'Номер паспорта';
        Cells[5,0] := 'Тип УО';
        Cells[6,0] := 'Область';
        Cells[7,0] := 'БЕЛ';
        Cells[8,0] := 'РУС';
        Cells[9,0] := 'АНГ';
        Cells[10,0] := 'МАТ';
        Cells[11,0] := 'БИО';
        Cells[12,0] := 'ХИМ';
        Cells[13,0] := 'ФИЗ';
        Cells[14,0] := 'ИСТ';
        Cells[15,0] := 'ВИС';
        Cells[16,0] := 'ГЕО';
        Cells[17,0] := 'Пользователь';
    End;
    With AdminStringGrid do
    Begin
        ColWidths[0] := 135;
        ColWidths[1] := 135;
        ColWidths[2] := 115;
        ColWidths[3] := 55;
        ColWidths[4] := 125;
        ColWidths[5] := 80;
        ColWidths[6] := 115;
        For I := 7 to 16 do
            ColWidths[I] := 47;
        ColWidths[17] := 118;
    End;
End;

Procedure TAdminForm.ClearGrid();
Var
    I, J: Integer;
Begin
    For J := 0 to (AdminStringGrid.ColCount - 1) do
        For I := 1 to (AdminStringGrid.RowCount - 1) do
            AdminStringGrid.Cells[J, I] := '';
End;

Procedure TAdminForm.FillUsersInfo();
Var
    Curr: PList;
    I, J, K: Integer;
Begin
    Curr := Head;
    I := 2;
    While (Curr <> Nil) do
    Begin
        K := 7; //номер столбца, с которого начинаются учебные предметы

        If (Curr^.Visible) then
        Begin
            AdminStringGrid.RowCount := I;
            AdminStringGrid.Cells[0,I - 1] := Curr^.Data.Surname;
            AdminStringGrid.Cells[1,I - 1] := Curr^.Data.Name;
            AdminStringGrid.Cells[2,I - 1] := DateToStr(Curr^.Data.BirthDate);
            AdminStringGrid.Cells[3,I - 1] := Curr^.Data.SeriesPassport;
            AdminStringGrid.Cells[4,I - 1] := Curr^.Data.PassportNumber;
            AdminStringGrid.Cells[5,I - 1] := Curr^.Data.InstituteType;
            AdminStringGrid.Cells[6,I - 1] := Curr^.Data.Region;
            AdminStringGrid.Cells[17,I - 1] := Curr^.Data.Username;
            For J := 1 to 10 do
            Begin
                If (Curr^.Data.Subjects[J].Status = True) then
                    AdminStringGrid.Cells[K, I - 1] := '   +';
                Inc(K);
            End;
            Inc(I);
        End;
        Curr := Curr^.Next;
    End;
    If (AdminStringGrid.RowCount <> 1) then
        AdminStringGrid.FixedRows := 1;
End;

Procedure TAdminForm.RegionCheckBoxClick(Sender: TObject);
Begin
    If (RegionCheckBox.Checked) then
    Begin
        RegionEdit.ItemIndex := 0;
        RegionEdit.Enabled := True;
    End
    Else
    Begin
        RegionEdit.ItemIndex := -1;
        RegionEdit.Enabled := False;
        RegionEdit.Text := 'Область';
    End;
    CheckFilters();
End;

Procedure TAdminForm.InstituteCheckBoxClick(Sender: TObject);
Begin
    If (InstituteCheckBox.Checked) then
    Begin
        InstituteEdit.ItemIndex := 0;
        InstituteEdit.Enabled := True;
    End
    Else
    Begin
        InstituteEdit.ItemIndex := -1;
        InstituteEdit.Enabled := False;
        InstituteEdit.Text := 'Тип УО';
    End;
    CheckFilters();
End;

Procedure TAdminForm.CheckFilters();
Begin
    If (Not RegionCheckBox.Checked) and (Not InstituteCheckBox.Checked) then
    Begin
        MakeVisible();
        ClearGrid();
        FillUsersInfo();
        DefaultRadioButton.Enabled := True;
    End;
End;

Procedure TAdminForm.StatisticsButtonClick(Sender: TObject);
Var
    VisualForm: TStatisticsForm;
Begin
    VisualForm := TStatisticsForm.Create(Self);
    VisualForm.ShowModal();
    VisualForm.Free();
End;

Procedure TAdminForm.SurnameRadioButtonClick(Sender: TObject);
Begin
    SortList(SURNAME_SORT);
    ClearGrid();
    FillUsersInfo();
End;

Procedure TAdminForm.AgeRadioButtonClick(Sender: TObject);
Begin
    SortList(AGE_SORT);
    ClearGrid();
    FillUsersInfo();
End;

Procedure TAdminForm.DefaultRadioButtonClick(Sender: TObject);
Begin
    ClearGrid();
    ClearList();
    DownloadList();
    FillUsersInfo();
End;

Procedure TAdminForm.ExitButtonClick(Sender: TObject);
Begin
    Self.ModalResult := mrYes;
End;

Procedure TAdminForm.ConfirmFilterButtonClick(Sender: TObject);
Var
    Curr: PList;
Begin
    ClearGrid();
    AdminStringGrid.RowCount := 1;
    MakeVisible();
    If (RegionEdit.ItemIndex <> -1) then
    Begin
        Curr := Head;
        While (Curr <> Nil) do
        Begin
            If (Curr^.Data.Region = RegionEdit.Text) and (Curr^.Visible) then
                Curr^.Visible := True
            Else
                Curr^.Visible := False;
            Curr := Curr^.Next;
        End;
        DefaultRadioButton.Enabled := False;
    End;
    If (InstituteEdit.ItemIndex <> -1) then
    Begin
        Curr := Head;
        While (Curr <> Nil) do
        Begin
            If (Curr^.Data.InstituteType = InstituteEdit.Text) and (Curr^.Visible) then
                Curr^.Visible := True
            Else
                Curr^.Visible := False;
            Curr := Curr^.Next;
        End;
        DefaultRadioButton.Enabled := False;
    End;
    FillUsersInfo();
End;

Procedure TAdminForm.AddSearchUser(Data: TRequest);
Var
    I, J, K: Integer;
Begin
    AdminStringGrid.RowCount := AdminStringGrid.RowCount + 1;
    AdminStringGrid.FixedRows := 1;
    I := AdminStringGrid.RowCount;
    AdminStringGrid.Cells[0,I - 1] := Data.Surname;
    AdminStringGrid.Cells[1,I - 1] := Data.Name;
    AdminStringGrid.Cells[2,I - 1] := DateToStr(Data.BirthDate);
    AdminStringGrid.Cells[3,I - 1] := Data.SeriesPassport;
    AdminStringGrid.Cells[4,I - 1] := Data.PassportNumber;
    AdminStringGrid.Cells[5,I - 1] := Data.InstituteType;
    AdminStringGrid.Cells[6,I - 1] := Data.Region;
    AdminStringGrid.Cells[17,I - 1] := Data.Username;
    K := 7;
    For J := 1 to 10 do
    Begin
        If (Data.Subjects[J].Status) then
            AdminStringGrid.Cells[K, I - 1] := '   +';   
        Inc(K); 
    End;
End;

Procedure TAdminForm.UserSearchBoxChange(Sender: TObject);
Var
    Curr: PList;
    Search: String;
Begin
    ClearGrid();
    AdminStringGrid.RowCount := 1;
    Search := AnsiUpperCase(UserSearchBox.Text);
    If (UserSearchBox.Text = '') then
        FillUsersInfo()
    Else
    Begin
        Curr := Head;
        While (Curr <> Nil) do
        Begin
            If ((Pos(Search, AnsiUpperCase(Curr^.Data.Surname)) <> 0)
                or (Pos(Search, AnsiUpperCase(Curr^.Data.Name)) <> 0)
                    or (Pos(Search, AnsiUpperCase(Curr^.Data.PassportNumber)) <> 0)
                        or (Pos(Search, AnsiUpperCase(Curr^.Data.Username)) <> 0))
                            and (Curr^.Visible)
            then
                AddSearchUser(Curr^.Data);
            Curr := Curr^.Next;
        End;
    End;
End;

Procedure TAdminForm.ClearFilterButtonClick(Sender: TObject);
Begin
    ClearGrid();
    MakeVisible();
    RegionCheckBox.Checked := False;
    RegionEdit.ItemIndex := -1;
    RegionEdit.Enabled := False;
    InstituteCheckBox.Checked := False;
    InstituteEdit.ItemIndex := -1;
    InstituteEdit.Enabled := False;
    DefaultRadioButton.Enabled := True;
    UserSearchBox.Text := '';
    FillUsersInfo();
End;

Procedure TAdminForm.RegionEditKeyPress(Sender: TObject; var Key: Char);
Begin
    Key := #0;
End;


End.
