Unit RegistrationUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
    Vcl.ExtCtrls;

Type
    TRegistrationForm = class(TForm)
        NewUsernameEdit: TEdit;
        RegisterButton: TButton;
        BackgroundImage: TImage;
        NewPasswordEdit: TEdit;
        InvalidUsernameShape: TShape;
        InvalidPasswordShape: TShape;
        ExistedUserLabel: TLabel;
        HeadingLabel: TLabel;
        EyeImage: TImage;
        SquareShape: TShape;
        Procedure FormActivate(Sender: TObject);
        Procedure RegisterButtonClick(Sender: TObject);
        Procedure NewUsernameEditChange(Sender: TObject);
        Procedure NewPasswordEditChange(Sender: TObject);
        Procedure NewUsernameEditKeyPress(Sender: TObject; var Key: Char);
        Procedure NewPasswordEditKeyPress(Sender: TObject; var Key: Char);
        Procedure EyeImageClick(Sender: TObject);

    Private
        { Private declarations }
        Function CheckExistingUser(NewUsername: String): Boolean;
    Public
        { Public declarations }
    End;

Var
    RegistrationForm: TRegistrationForm;

Implementation

{$R *.dfm}

Uses
    LoginUnit;

Procedure TRegistrationForm.FormActivate(Sender: TObject);
Begin
    ActiveControl := Nil;
End;

Procedure TRegistrationForm.NewPasswordEditChange(Sender: TObject);
Begin
    If (NewPasswordEdit.Text <> '') then
        InvalidPasswordShape.Pen.Color := clGreen
    Else
    Begin
        InvalidPasswordShape.Pen.Color := clRed;
    End;
    If (InvalidUsernameShape.Pen.Color = clGreen) and (NewPasswordEdit.Text <> '') then
        RegisterButton.Enabled := True
    Else
        RegisterButton.Enabled := False;
End;

Function TRegistrationForm.CheckExistingUser(NewUsername: String): Boolean;
Var
    UsersData: File of TUser;
    AdminData: TextFile;
    AdminUsername: String[10];
    IsRegistered: Boolean;
    User: TUser;
Begin
    AssignFile(AdminData, 'AdminLogin.txt');
    Reset(AdminData);
    Read(AdminData, AdminUsername);
    AssignFile(UsersData, 'UsersLogin.txt');
    Reset(UsersData);
    NewUsername := NewUsernameEdit.Text;
    IsRegistered := False;
    While Not (EOF(UsersData) or IsRegistered) do
    Begin
        Read(UsersData, User);
        If (NewUsername = User.Username) or (NewUsername = AdminUsername) then
            IsRegistered := True;
    End;
    If (AdminUsername = NewUsername) then
        IsRegistered := True;
    CloseFile(UsersData);
    CloseFile(AdminData);
    Result := IsRegistered;
End;

Procedure TRegistrationForm.NewUsernameEditChange(Sender: TObject);
Var
    NewUsername: String[10];
    IsRegistered: Boolean;
Begin
    NewUsername := NewUsernameEdit.Text;
    IsRegistered := CheckExistingUser(NewUsername);
    If (IsRegistered) then
    Begin
        RegisterButton.Enabled := False;
        InvalidUsernameShape.Pen.Color := clRed;
        ExistedUserLabel.Visible := True;
    End
    Else
    Begin
        InvalidUsernameShape.Pen.Color := clGreen;
        ExistedUserLabel.Visible := False;
    End;
    If (NewUsername = '') then
    Begin
        RegisterButton.Enabled := False;
        InvalidUsernameShape.Pen.Color := clRed;
        ExistedUserLabel.Visible := False;
    End
    Else If (NewUsername <> '') and (NewPasswordEdit.Text <> '') and (Not IsRegistered) then
        RegisterButton.Enabled := True;

End;

Procedure TRegistrationForm.NewUsernameEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = #32)  then
        Key := #0;
    If (Not (Key in ['a'..'z','A'..'Z','0'..'9', #08])) then
        Key := #0;
End;

Procedure TRegistrationForm.NewPasswordEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = #32)  then
        Key := #0;
    If (Not (Key in ['a'..'z','A'..'Z','0'..'9', #08, '@', '#', '$'])) then
        Key := #0;
End;

Procedure TRegistrationForm.RegisterButtonClick(Sender: TObject);
Var
    UsersData: File of TUser;
    NewUser: TUser;
Begin
    AssignFile(UsersData, 'UsersLogin.txt');
    Reset(UsersData);
    Seek(UsersData, FileSize(UsersData));

    NewUser.Username := NewUsernameEdit.Text;
    NewUser.Password := NewPasswordEdit.Text;

    Write(UsersData, NewUser);
    CloseFile(UsersData);

    Application.Messagebox('Вы успешно зарегистрировались в системе.','Успешная регистрация', MB_ICONINFORMATION);
End;

Procedure TRegistrationForm.EyeImageClick(Sender: TObject);
Begin
    If (NewPasswordEdit.PasswordChar = '*') then
    Begin
        EyeImage.Picture.LoadFromFile('..\Icons\closed_eye.png');
        NewPasswordEdit.PasswordChar := #0;
    End
    Else
    Begin
        EyeImage.Picture.LoadFromFile('..\Icons\open_eye.png');
        NewPasswordEdit.PasswordChar := '*';
    End;
End;

End.
