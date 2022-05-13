Unit HelpUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    Vcl.Imaging.pngimage;

Type
    THelpForm = class(TForm)
        IconImage: TImage;
        Label1: TLabel;
        ManualLabel: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        DeveloperLabel: TLabel;
        ContactsLabel: TLabel;
        BsuirLabel: TLabel;
        HeaderLabel: TLabel;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    HelpForm: THelpForm;

Implementation

{$R *.dfm}

End.
