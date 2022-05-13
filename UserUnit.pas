Unit UserUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.ComCtrls,
    Vcl.ExtCtrls, Vcl.WinXCalendars, Vcl.WinXPickers, DynamicListUnit, HelpUnit;

Type
    TCheckBoxesArr = Array[1..10] of TCheckBox;

    TUserForm = class(TForm)
        SurnameEdit: TEdit;
        NameEdit: TEdit;
        SeriesPassportEdit: TComboBox;
        PassportEdit: TEdit;
        HeaderLabel: TLabel;
        ControlMenu: TMainMenu;
        HelpButton: TMenuItem;
        InstituteEdit: TComboBox;
        RegionEdit: TComboBox;
        BelarussianCheckBox: TCheckBox;
        SubjectsBox: TGroupBox;
        RussianCheckBox: TCheckBox;
        EnglishCheckBox: TCheckBox;
        MathsCheckBox: TCheckBox;
        BiologyCheckBox: TCheckBox;
        ChemistryCheckBox: TCheckBox;
        PhysicsCheckBox: TCheckBox;
        BelHistoryCheckBox: TCheckBox;
        WorldHistoryCheckBox: TCheckBox;
        GeographyCheckBox: TCheckBox;
        SendRequestButton: TButton;
        CancelRequestButton: TButton;
        StatusShape: TShape;
        RequestStatusLabel: TLabel;
        PersonalComboBox: TGroupBox;
        DocumentComboBox: TGroupBox;
        AdditionalComboBox: TGroupBox;
        BirthDatePicker: TDatePicker;
        BirthDataLabel: TLabel;
        ErrorLabel: TLabel;
        LoginLabel: TLabel;
        UsernameLabel: TLabel;
        StatusLabel: TLabel;
        ExitButton: TMenuItem;
        ErrorShape: TShape;
        Procedure SeriesPassportEditKeyPress(Sender: TObject; var Key: Char);
        Procedure InstituteEditKeyPress(Sender: TObject; var Key: Char);
        Function CheckChosenSubjects(): Boolean;
        Procedure BelarussianCheckBoxClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure SendRequestButtonClick(Sender: TObject);
        Function CreateListOfSubjects(): TSubjArr;
        Function FillCheckBoxesArr(): TCheckBoxesArr;
        Procedure FormActivate(Sender: TObject);
        Function CheckSendingRequest(): Boolean;
        Procedure SurnameEditChange(Sender: TObject);
        Procedure SurnameEditKeyPress(Sender: TObject; var Key: Char);
        Procedure CancelRequestButtonClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        Procedure ExitButtonClick(Sender: TObject);
        Procedure HelpButtonClick(Sender: TObject);
        Procedure PassportEditChange(Sender: TObject);
    Private
        Procedure RewriteRequestsFile();
        Procedure FillForm();
    Public
        CheckBoxesArr: TCheckBoxesArr;
    End;
    
Implementation

{$R *.dfm}

Procedure TUserForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    ModalResult: Integer;
Begin
    If (StatusLabel.Font.Color = $000080FF) then
    Begin
        ModalResult := Application.MessageBox('Имеются несохранённые данные. Выйти без сохранения?','Выход', MB_OKCANCEL + MB_ICONQUESTION);
    End
    Else
        ModalResult := Application.MessageBox('Вы уверены, что хотите выйти?','Выход', MB_OKCANCEL + MB_ICONQUESTION);
    If (ModalResult = 1) then
    Begin
        CanClose := True;
        ClearList();
    End
    Else
        CanClose := False;
End;

Procedure TUserForm.FormCreate(Sender: TObject);
Begin
    DownloadList();
    CheckBoxesArr := FillCheckBoxesArr();
End;

Procedure TUserForm.HelpButtonClick(Sender: TObject);
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

Procedure TUserForm.FormActivate(Sender: TObject);
Begin
    FillForm();
End;

Function TUserForm.FillCheckBoxesArr(): TCheckBoxesArr;
Begin
    CheckBoxesArr[1] := BelarussianCheckBox;
    CheckBoxesArr[2] := RussianCheckBox;
    CheckBoxesArr[3] := EnglishCheckBox;
    CheckBoxesArr[4] := MathsCheckBox;
    CheckBoxesArr[5] := BiologyCheckBox;
    CheckBoxesArr[6] := ChemistryCheckBox;
    CheckBoxesArr[7] := PhysicsCheckBox;
    CheckBoxesArr[8] := BelHistoryCheckBox;
    CheckBoxesArr[9] := WorldHistoryCheckBox;
    CheckBoxesArr[10] := GeographyCheckBox;
    Result := CheckBoxesArr;
End;

Procedure TUserForm.FillForm();
Var
    CurrRequest: PList;
    I: Integer;
Begin
    CurrRequest := CheckUserRequest(Self.UsernameLabel.Caption);
    If (CurrRequest <> Nil) then
    Begin
        Self.SurnameEdit.Text := CurrRequest^.Data.Surname;
        Self.NameEdit.Text := CurrRequest^.Data.Name;
        Self.BirthDatePicker.Date := CurrRequest^.Data.BirthDate;
        Self.SeriesPassportEdit.Text := CurrRequest^.Data.SeriesPassport;
        Self.PassportEdit.Text := CurrRequest^.Data.PassportNumber;
        Self.InstituteEdit.Text := CurrRequest^.Data.InstituteType;
        Self.RegionEdit.Text := CurrRequest^.Data.Region;
        For I := 1 to 10 do
        Begin
            If (CurrRequest^.Data.Subjects[I].Status = True) then
                CheckBoxesArr[I].Checked := True
            Else
                CheckBoxesArr[I].Checked := False;
        End;
        StatusLabel.Caption := 'ЗАЯВКА ПОДАНА';
        StatusLabel.Font.Color := clGreen;
    End
    Else
    Begin
        CancelRequestButton.Enabled := False;
        StatusLabel.Caption := 'ЗАЯВКА НЕ ПОДАНА';
        StatusLabel.Font.Color := clRed;
    End;
End;

Procedure TUserForm.SendRequestButtonClick(Sender: TObject);
Var
    NewRecord, Last, CurrRequest: PList;
    Request: TRequest;
    IsCorrect: Boolean;
Begin
    IsCorrect := CheckSendingRequest();
    If (IsCorrect) then
    Begin
        With Request do
        Begin
            Username := UsernameLabel.Caption;
            Surname := SurnameEdit.Text;
            Name := NameEdit.Text;
            BirthDate := BirthDatePicker.Date;
            SeriesPassport := SeriesPassportEdit.Text;
            PassportNumber := PassportEdit.Text;
            InstituteType := InstituteEdit.Text;
            Region := RegionEdit.Text;
            Subjects := CreateListOfSubjects();
        End; 
        CurrRequest := CheckUserRequest(Request.Username);
        AddRequest(CurrRequest, Request);
        RewriteRequestsFile();
        CancelRequestButton.Enabled := True;
        StatusLabel.Caption := 'ЗАЯВКА ПОДАНА';
        StatusLabel.Font.Color := clGreen;
        Application.Messagebox('Заявка с введёнными данными успешно отправлена','Заявка одобрена', MB_ICONINFORMATION);
    End
    Else
        Application.Messagebox('Проверьте корректность введённых данных и повторите попытку!','Проверьте данные', MB_ICONERROR);
End;

Function TUserForm.CheckSendingRequest: Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := True;
    If (SurnameEdit.Text = '') or (NameEdit.Text = '') or (SeriesPassportEdit.Text = '')
        or (Length(PassportEdit.Text) < 7) or (InstituteEdit.Text = '')
            or (RegionEdit.Text = '') or (Not CheckChosenSubjects) then
        IsCorrect := False;
    Result := IsCorrect;
End;

Function TUserForm.CreateListOfSubjects(): TSubjArr;
Var
    SubjectsArr: TSubjArr;
    I: Integer;
Begin
    For I := 1 to 10 do
        SubjectsArr[I].Status := False;
    For I := 1 to 10 do
        If (CheckBoxesArr[I].Checked) then
            SubjectsArr[I].Status := True;
    Result := SubjectsArr;
End;

Procedure TUserForm.ExitButtonClick(Sender: TObject);
Begin
    Self.ModalResult := mrYes;
End;

Procedure TUserForm.CancelRequestButtonClick(Sender: TObject);
Var
    CurrRequest: PList;
Begin
    CurrRequest := CheckUserRequest(UsernameLabel.Caption);
    DeleteRequest(CurrRequest);
    RewriteRequestsFile();
    CancelRequestButton.Enabled := False;
    StatusLabel.Caption := 'ЗАЯВКА НЕ ПОДАНА';
    StatusLabel.Font.Color := clRed;
    Application.Messagebox('Заявка успешно отменена','Заявка отменена', MB_ICONINFORMATION);
End;

Procedure TUserForm.RewriteRequestsFile();
Var
    UsersData: RequestsFile;
    Curr: PList;
Begin
    AssignFile(UsersData, 'UsersData.txt');
    Rewrite(UsersData);
    Curr := Head;
    While (Curr <> Nil) do
    Begin
        Write(UsersData, Curr^.Data);
        Curr := Curr^.Next;
    End;
    CloseFile(UsersData);
End;

Function TUserForm.CheckChosenSubjects(): Boolean;
Var
    I, Counter: Integer;
Begin
    Counter := 0;
    For I := 1 to 10 do
    Begin
        If (CheckBoxesArr[I].Checked) then
            Inc(Counter);
    End;
    If (Counter <= 4) and (Counter > 0) then
    Begin
        ErrorLabel.Visible := False;
        Result := True;
    End
    Else
    Begin
        ErrorLabel.Visible := True;
        Result := False;
    End;
End;

Procedure TUserForm.BelarussianCheckBoxClick(Sender: TObject);
Begin
    CheckChosenSubjects();
    StatusLabel.Caption := 'ЗАЯВКА ИЗМЕНЕНА';
    StatusLabel.Font.Color := $000080FF;
End;

Procedure TUserForm.SeriesPassportEditKeyPress(Sender: TObject; var Key: Char);
Begin
    Key := #0;
End;

Procedure TUserForm.SurnameEditChange(Sender: TObject);
Begin
    StatusLabel.Caption := 'ЗАЯВКА ИЗМЕНЕНА';
    StatusLabel.Font.Color := $000080FF;
End;

Procedure TUserForm.SurnameEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key in ['a'..'z','A'..'Z','0'..'9','@','#','.','.',' ']) then
        Key := #0;
End;

Procedure TUserForm.InstituteEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    Key := #0;
End;

Procedure TUserForm.PassportEditChange(Sender: TObject);
Begin
    StatusLabel.Caption := 'ЗАЯВКА ИЗМЕНЕНА';
    StatusLabel.Font.Color := $000080FF;
    ErrorShape.Pen.Width := 3;
    If (Length(PassportEdit.Text) < 7) then
        ErrorShape.Pen.Color := clRed
    Else
        ErrorShape.Pen.Color := clGreen;
End;

End.
