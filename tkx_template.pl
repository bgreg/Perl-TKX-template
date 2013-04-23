use strict;
use warnings FATAL => qw( all );
use File::Find;
use File::Path;
use Tkx;
use Tkx::LabEntry;
use Carp;
use YAML qw(DumpFile LoadFile);
use File::Basename qw(basename);
Tkx::package_require("BWidget");
Tkx::package_require("ctext");
Tkx::package_require("style");

my $VERSION = '';
my %s;
my %labFrame;
my %frame;
my %labEntry;
my %button;
my %mainWindow;
my @errors;
my @output;

$s{debug} = 1;
my $settingFile = $0 . '.settings';
my $errorFile   = $0 . '.errors';

buildGui();
loadSettings();

Tkx::MainLoop();
exit;

sub buildGui
{
    carp() if $s{debug};

    addMainWindow();
    addWindowFrame();
    setItemsForAllFrames();

    $labEntry{entry1}  = $frame{window}->new_tkx_LabEntry();
    $labEntry{entry2}   = $frame{window}->new_tkx_LabEntry();
    $labEntry{entry3}   = $frame{window}->new_tkx_LabEntry();
    $labEntry{entry4}    = $frame{window}->new_tkx_LabEntry();
  
	addEntry1();
	addEntry2();
	addEntry3();
	addEntry4();
    
    addStartButtons();
	
    setItemsForAllLabEntries();

    $mainWindow{mw}->configure( -menu => addMenuBar() );

    addSizeGrip();
}

sub addSizeGrip
{
    my $sizeGrip = $mainWindow{mw}->new_ttk__sizegrip;
    $sizeGrip->g_pack( -side => 'right' );
}

sub addMainWindow
{
    carp() if $s{debug};
    $mainWindow{mw} = Tkx::widget->new('.');
    $mainWindow{mw}->g_wm_title("Template $VERSION");
    #$mainWindow{mw}->g_wm_minsize( 200, 400 );  # force a size if needed.  Helps with some pack layouts
    $mainWindow{mw}->g_wm_iconbitmap('c:\localdata\cockpit\rocket.ico');
}

sub addWindowFrame
{
    carp() if $s{debug};
    $frame{window} = $mainWindow{mw}->new_ttk__frame();
    $frame{window}->g_pack( -fill => 'x' );
}

sub setItemsForAllFrames
{
    carp() if $s{debug};
    foreach my $key ( keys %labFrame )
    {
        $labFrame{$key}->configure(
            -padding     => '5 5 5 5',
            -borderwidth => 10,
            -relief      => 'sunken'
        );
    }
}

sub addEntry1
{
    carp() if $s{debug};
    $labEntry{entry1}->configure(
        -label        => 'Entry 1',
        -textvariable => \$s{entry1}
    );
    $labEntry{entry1}->g_pack( -fill => 'x', -pady => 2 );
}

sub addEntry2
{
    carp() if $s{debug};
    $labEntry{entry2}->configure(
        -label           => 'Entry 3',
        -textvariable    => \$s{entry2},
        -validate        => 'all',
        -validatecommand => [
            \&validate_entry2,
            Tkx::Ev( '%d', '%i', '%P', '%s', '%S', '%v', '%V', '%W' ),
            $labEntry{entry2}
        ]
    );
    $labEntry{entry2}->g_pack( -fill => 'x', -pady => 2 );
}

sub addEntry3
{
    carp() if $s{debug};
    $labEntry{entry3}->configure(
        -label           => 'Entry 5',
        -textvariable    => \$s{entry3},
        -validate        => 'all',
        -validatecommand => [
            \&validate_entry3,
            Tkx::Ev( '%d', '%i', '%P', '%s', '%S', '%v', '%V', '%W' ),
            $labEntry{entry3}
        ]
    );
    $labEntry{entry3}->g_pack(-fill=>'x',-pady => 2);
}

sub addEntry4
{
    carp() if $s{debug};
    $labEntry{entry4}->configure(
        -label           => 'Entry 6',
        -textvariable    => \$s{entry4},
        -validate        => 'all',
        -validatecommand => [
            \&validate_entry4,
            Tkx::Ev( '%d', '%i', '%P', '%s', '%S', '%v', '%V', '%W' ),
            $labEntry{entry4}
        ]
    );
    $labEntry{entry4}->g_pack( -fill => 'x', -pady => 2 );
}
sub setItemsForAllLabEntries
{
    carp() if $s{debug};
    foreach my $key ( keys %labEntry )
    {
        $labEntry{$key}->configure( -width => 30, -justify => 'left' );
    }
}

sub validate_entry1
{
    my ( $d, $i, $P, $s, $S, $v, $V, $W ) = @_;
    if ( $s eq "" )
    {
 
    }
    else
    {

    }
    return 1;
}

sub validate_entry2
{
    my ( $d, $i, $P, $s, $S, $v, $V, $W ) = @_;
    if ( $s eq "" )
    {
    }
    else
    {
    }
    return 1;
}

sub validate_entry3
{
    my ( $d, $i, $P, $s, $S, $v, $V, $W ) = @_;
    if ( $s eq "" )
    {
    }
    else
    {
    }
    return 1;
}

sub validate_entry4
{
    my ( $d, $i, $P, $s, $S, $v, $V, $W ) = @_;
    if ( $s eq "" )
    {
    }
    else
    {
    }
    return 1;
}

sub addStartButtons
{
    carp() if $s{debug};
    $button{start} =
      $frame{window}->new_ttk__button( -text => 'Start', -command => \&run );
    $button{start}->g_pack( -fill=>'x' );
}
sub addMenuBar
{
    carp() if $s{debug};
    Tkx::option_add( "*Menu.tearOff", 0 );
    my $menuParent  = $mainWindow{mw}->new_menu();
    my $fileMenu    = $menuParent->new_menu();
    my $settingMenu		= $menuParent->new_menu();
    my $helpMenu    = $menuParent->new_menu();
    my $control     = "Control";
    my $ctrl        = "Ctrl+";

    $menuParent->add_cascade( -label => "File",     -menu => $fileMenu );
    $menuParent->add_cascade( -label => "Settings", -menu => $settingMenu );
    $menuParent->add_cascade( -label => "Help",     -menu => $helpMenu );
    $fileMenu->add_command(
        -label       => "Exit",
        -underline   => 1,
        -accelerator => $ctrl . "Q",
        -command     => [ \&Tkx::destroy, $mainWindow{mw} ],
    );
    Tkx::bind( "all", "<$control-q>", [ \&Tkx::destroy, $mainWindow{mw} ] );
    $settingMenu->add_checkbutton(
        -label    => "Option 1",
        -variable => \$s{Option_1},
        -onvalue  => 1,
        -offvalue => 0
    );
    $settingMenu->add_checkbutton(
        -label    => "Option 2",
        -variable => \$s{Option_2},
        -onvalue  => 1,
        -offvalue => 0
    );
    $settingMenu->add_checkbutton(
        -label    => "Option 3",
        -variable => \$s{Option_3},
        -onvalue  => 1,
        -offvalue => 0
    );
    $settingMenu->add_checkbutton(
        -label    => "Option 4",
        -variable => \$s{Option_4},
        -onvalue  => 1,
        -offvalue => 0
    );
	$settingMenu->add_checkbutton(
        -label    => "Save Settings",
        -variable => \$s{save},
        -onvalue  => 1,
        -offvalue => 0
    );
    $helpMenu->add_command(
        -label   => "View ReadMe file",
        -command => sub { loadToPad('ReadMe.txt') },
    );
    $helpMenu->add_checkbutton(
        -label    => "Debug Mode",
        -variable => \$s{debug},
        -onvalue  => 1,
        -offvalue => 0
    );
    $helpMenu->add_command(
        -label   => "About",
        -command => sub {
            Tkx::tk___messageBox(
                -parent  => $mainWindow{mw},
                -title   => "About svgrep",
                -type    => "ok",
                -icon    => "info",
                -message => "Template $VERSION using Tkx $Tkx::VERSION\n"
                  . "Copyright ... ... ...  "
                  . "All rights reserved.",
            );
        }
    );
    return $menuParent;
}
sub run
{
	return 0 unless $s{entry1} or $s{entry2} or $s{entry3} or $s{entry4};
	foreach my $key (keys %s)
	{
		trim($s{$key});
	}
	
    writeSettings() if $s{save};
    carp()          if $s{debug};
    @errors = ();
    Tkx::update();
}


sub writeSettings
{
    carp() if $s{debug};
    DumpFile( $settingFile, \%s );
}

sub loadSettings {
    if ( -e $settingFile ) {
        my $settings = LoadFile($settingFile);
        foreach my $key ( keys %$settings ) {
            $s{$key} = delete $settings->{$key};
        }
    }
}
sub makeErrorLog
{
    carp("@_") if $s{debug};
    if ( $#errors > 0 )
    {
        open( ERROR_LOG, '>>' . "$errorFile" );
        foreach (@errors) { print ERROR_LOG ( $_ . "\n" ); }
        close(ERROR_LOG);
    }
}

sub trim
{
    carp() if $s{debug};
    my $string = shift;
    if ($string){
		chomp($string);
		$string =~ s/^\s+//;
		$string =~ s/\s+$//;
		return $string;
	}
}
__END__