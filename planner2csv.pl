#!/usr/bin/perl -w

# Parse a .planner file from Planner and generate a CSV from it.
# For use with: http://live.gnome.org/Planner
#
# Written by: Andrew Ruthven <andrew@etc.gen.nz>
# Git repo: http://git.etc.gen.nz/planner-tools.git
#
# Released under the GPLv3.
#
# Usage: planner2csv.pl <file> > out.csv

# Michael:
# sudo apt install -y libtext-csv-xs-perl


use XML::LibXML;
use Text::CSV_XS;

my $file = shift;
if (-! -f $file) {
  die "Sorry, what file do you want to convert to a CSV?\n";
}

my $parser = XML::LibXML->new;
my $tree = $parser->parse_file($file);

my $root = $tree->getDocumentElement;

my $csv = Text::CSV_XS->new(); 

print 'id,description,allocated,start,end,"percent complete"' . "\n";

for my $tasks ($root->findnodes('/project/tasks')) {
  find_tasks($tasks);
}

sub find_tasks {
  my $node = shift;
  my $level = shift || 0;
  my @id = @_;

  $id[$level] = 0;

  for my $task ($node->findnodes('task')) {
    $id[$level]++;
    my @fields = ();
    push @fields, 
        join('.', @id),
        $task->findvalue('@name');
    push @fields, find_allocated($task);

    push @fields, 
        date_convert($task->findvalue('@start')),
        date_convert($task->findvalue('@end')),
        $task->findvalue('@percent-complete');

    $csv->combine (@fields);
    print $csv->string() . "\n";

    push @id, '0';
    find_tasks($task, $level + 1, @id);
    pop @id;
  }
}

sub find_allocated {
  my $task = shift;

  my @resources = ();

  for my $allocation ($root->findnodes('/project/allocations/allocation[@task-id=' . $task->findvalue('@id') . ']')) {
    for my $resource ($root->findnodes('/project/resources/resource[@id=' . $allocation->findvalue('@resource-id') . ']')) {
      push @resources, $resource->findvalue('@name');
    }
  }

  return join(', ', @resources);
}

sub date_convert {
  my $date = shift;

  $date =~ s/^(\d{4})(\d\d)(\d\d).*/$1-$2-$3/;

  return $date;
}
