# --
# Copyright (C) 2008-2016 tuxwerk OHG - http://www.tuxwerk.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
# This module removes the attachments and plain-text messages of emails

package Kernel::System::GenericAgent::PurgeAttachments;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::Config',
);

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');


    my %Ticket = $TicketObject->TicketGet(%Param);

    my @ArticleIndex = $TicketObject->ArticleGet( TicketID => $Ticket{TicketID} );

    foreach my $Article (@ArticleIndex) {
	$TicketObject->ArticleDeletePlain(      ArticleID => $Article->{ArticleID}, UserID => 1);
	$TicketObject->ArticleDeleteAttachment( ArticleID => $Article->{ArticleID}, UserID => 1);
    }

    $LogObject->Log(Priority => 'notice', Message => "PurgeAttachments: plain message + attachments deleted for ticket [".$Ticket{TicketNumber}."]",);

    return 1;
}

1;
