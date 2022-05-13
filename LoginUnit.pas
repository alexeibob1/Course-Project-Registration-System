Unit LoginUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
    Vcl.ExtCtrls, Vcl.Buttons;

Type
    TUser = Record
        Username: String[10];
        Password: String[15];
    End;

    TLoginForm = class(TForm)
        BackgroundImage: TImage;
        PasswordEdit: TEdit;
        UsernameEdit: TEdit;
        HeadingLabel: TLabel;
        RegisterButton: TBitBtn;
        UserLoginButton: TBitBtn;
        AdminLoginButton: TBitBtn;
        EyeImage: TImage;
        SquareShape: TShape;
        Procedure RegisterButtonClick(Sender: TObject);
        Procedure UserLoginButtonClick(Sender: TObject);
        Procedure UsernameEditKeyPress(Sender: TObject; var Key: Char);
        Procedure PasswordEditKeyPress(Sender: TObject; var Key: Char);
        Procedure EyeImageClick(Sender: TObject);
        Procedure AdminLoginButtonClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    LoginForm: TLoginForm;

Implementation

{$R *.dfm}

Uses
    RegistrationUnit, UserUnit, AdminUnit;

Procedure TLoginForm.RegisterButtonClick(Sender: TObject);
Var
    RegistrationForm: TRegistrationForm;
Begin
    Try
        RegistrationForm := TRegistrationForm.Create(Self);
        RegistrationForm.ShowModal();
    Finally
        RegistrationForm.Free();
        LoginForm.UsernameEdit.Clear();
        LoginForm.PasswordEdit.Clear();
        ActiveControl := Nil;
    End;
End;

Procedure TLoginForm.UserLoginButtonClick(Sender: TObject);
Var
    UsersData: File of TUser;
    User: TUser;
    IsCorrect, IsError: Boolean;
    UserForm: TUserForm;
Begin
    AssignFile(UsersData,'UsersLogin.txt');
    If (FileExists('UsersLogin.txt')) then
    Begin
        Reset(UsersData);
        IsError := False;
    End
    Else
    Begin
        Rewrite(UsersData);
        Application.Messagebox('Произошла потеря пользовательских данных. Создайте новый аккаунт.','Ошибка', MB_ICONERROR);
        IsError := True;
    End;

    IsCorrect := False;
    While (Not EOF(UsersData)) and (Not IsCorrect) do
    Begin
        Read(UsersData, User);
        If (UsernameEdit.Text = User.Username) and (PasswordEdit.Text = User.Password) then
            IsCorrect :=  True;
    End;
    CloseFile(UsersData);

    If (IsCorrect) then
    Begin
        Try
            UserForm := TUserForm.Create(Self);
            UserForm.UsernameLabel.Caption := UsernameEdit.Text;
            UserForm.ShowModal();
        Finally
            UserForm.Free();
            LoginForm.UsernameEdit.Clear();
            LoginForm.PasswordEdit.Clear();
            ActiveControl := Nil;
        End;
    End
    Else If (Not IsCorrect) and (Not IsError) then
        Application.Messagebox('Пользователь не найден. Проверьте введённые данные.','Пользователь не найден', MB_ICONERROR);

End;

Procedure TLoginForm.AdminLoginButtonClick(Sender: TObject);
Var
    AdminData: TextFile;
    AdminUsername, AdminPassword: String[10];
    AdminForm: TAdminForm;
    IsError: Boolean;
Begin
    AssignFile(AdminData,'AdminLogin.txt');

    If (FileExists('AdminLogin.txt')) then
    Begin
        Reset(AdminData);
        IsError := False;
    End
    Else
    Begin
        Application.Messagebox('Произошла потеря данных администратора. Обратитесь к разработчику.','Ошибка', MB_ICONERROR);
        IsError := True;
    End;

    If Not (IsError) then
    Begin
        Readln(AdminData, AdminUsername);
        Readln(AdminData, AdminPassword);
        CloseFile(AdminData);
    End;

    If (UsernameEdit.Text = AdminUsername) and (PasswordEdit.Text = AdminPassword) then
    Begin
        Try
            AdminForm := TAdminForm.Create(Self);
            AdminForm.ShowModal();
        Finally
            AdminForm.Free();
            LoginForm.UsernameEdit.Clear();
            LoginForm.PasswordEdit.Clear();
            ActiveControl := Nil;
        End;
    End
    Else If (Not IsError)  then
        Application.Messagebox('Введены неверные логин и пароль администратора системы! Повторите попытку', 'Ошибка авторизации', MB_ICONERROR);
End;

Procedure TLoginForm.EyeImageClick(Sender: TObject);
Begin
    If (PasswordEdit.PasswordChar = '*') then
    Begin
        EyeImage.Picture.LoadFromFile('closed_eye.png');
        PasswordEdit.PasswordChar := #0;
    End
    Else
    Begin
        EyeImage.Picture.LoadFromFile('open_eye.png');
        PasswordEdit.PasswordChar := '*';
    End;
End;

Procedure TLoginForm.UsernameEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = #32)  then
        Key := #0;
    If (Not (Key in ['a'..'z','A'..'Z','0'..'9', #08])) then
        Key := #0;
End;

Procedure TLoginForm.PasswordEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Key = #32)  then
        Key := #0;
    If (Not (Key in ['a'..'z','A'..'Z','0'..'9', #08, '@', '#', '$'])) then
        Key := #0;
End;

End.
