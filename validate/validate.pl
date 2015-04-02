#!/usr/local/bin/perl

use strict;
use utf8;
use XML::LibXML;
use XML::LibXML::Reader;
use Data::Dumper;

sub get_fields
{
    my $fragment    = shift;
    my $ra_attrs    = shift;

    my %hash = map { $_ => '' } @{$ra_attrs};
    my $reader = XML::LibXML::Reader->new(string => $fragment);
    while ($reader->read())
    {
        next if ($reader->nodeType() eq XML_READER_TYPE_END_ELEMENT);

        my $name = $reader->name();
        if (exists $hash{"$name"})
        {
            # read the text content
            $reader->read();
            $hash{$name} = $reader->value();
            #print "value: " . $reader->value() . "\n";
        }
    }

    return \%hash;
}

binmode STDOUT, ":utf8";

my $file = $ARGV[0] || die "Usage: $0 <file>";
my $reader = XML::LibXML::Reader->new(location => $file);

my $pattern = XML::LibXML::Pattern->new('/dataList/rows');

my @needles = ('許可證字號', '中文品名');
my $i = 0;
while ($reader->nextPatternMatch($pattern))
{
    # skip the close tag
    next if ($reader->nodeType() eq XML_READER_TYPE_END_ELEMENT);

    my $fragment = $reader->readOuterXml();
    my $rh_attrs = get_fields($fragment, \@needles);
    if ($rh_attrs->{'中文品名'} =~ m/？/)
    {
        print join("\t", ($rh_attrs->{'許可證字號'}, $rh_attrs->{'中文品名'})) . "\n";
    }

    #last if ($i++ > 2);
}

$reader->finish;

