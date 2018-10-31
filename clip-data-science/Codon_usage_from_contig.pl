#!/usr/bin/perl

# Written by Tom de Man

use strict; 

###Calling all the subroutines
foreach (@ARGV) {
      my ($seq_header,$seq) = &readFasta($_);
      my @genelijst = &codondetect($seq);
      my @hash_container = &cat_hash(@genelijst);
      my $len_hash_container = scalar(@hash_container);
      my $total_AAs = &count_AAs(@genelijst);
      &AAcount(\@hash_container, $seq_header,$total_AAs);
}

###reads fasta files and returns the sequences and headers seperate. 
sub readFasta
{
	my $line;
	my $first;
	my $temp;
	my @seqheader;
	my @seq;
	open(FILE, "<@_[0]") || die "You should enter a fasta file in the terminal\n";
	my $cdsnr = 0;
	$first = 0;
	while (defined($line = <FILE>)){
		chomp($line);
		$temp = substr($line, length($line) - 1, 1);
		if ($temp eq "\r" || $temp eq "\n"){
			chop($line);
		}
		if ($line =~ /^>/) {
			push(@seqheader, $line);
			$cdsnr = $cdsnr + 1;
			if ($first == 0) {
				$first = 1;
			}
			next;
		}
		if ($first == 0) {
			die "Not a standard FASTA file. Stop.\n";
		}
		$seq[$cdsnr - 1] = $seq[$cdsnr - 1] .$line;
	}
	close(FILE);
	return (\@seqheader,\@seq);
} 
      
###list the different codons in an array/hash table to count them afterwards###
sub codondetect ($) 
{
      my @codonlist = ('TCA','TCC','TCG','TCT','TTC','TTT','TTA','TTG','TAC','TAT','TAA','TAG',
	      'TGC','TGT','TGA','TGG','CTA','CTC','CTG','CTT','CCA','CCC','CCG','CCT',
	      'CAC','CAT','CAA','CAG','CGA','CGC','CGG','CGT','ATA','ATC','ATT','ATG',
	      'ACA','ACC','ACG','ACT','AAC','AAT','AAA','AAG','AGC','AGT','AGA','AGG',
	      'GTA','GTC','GTG','GTT','GCA','GCC','GCG','GCT','GAC','GAT','GAA','GAG',
	      'GGA','GGC','GGG','GGT');
      my $genenr=1;
      my @values;
      my @geneList;
      foreach my $dna_fragment (@{$_[0]}) {
	      my %codonocc;
	      #print "\nGene nr:", $genenr, "\n";
	      ###cut in triplets and make an array @cutseq of them###
	      my @cutseq;
	      my $codonofseq;
	      my $codon;
	      for(my $i=0;$i<length($dna_fragment)-2;$i+=3) {
		      $codonofseq = substr(lc($dna_fragment),$i,3);
		      push(@cutseq,$codonofseq);
	      }
	      ###count amount of 64 different triplets and store in a hash table %codonocc###
	      #my $lengthseq = (length($dna_fragment))/3;
	      my $counter=0;
	      foreach my $codon (@codonlist) {
		      foreach my $cdofseq (@cutseq){
			      if (lc($codon) eq lc($cdofseq)){ 	
				  $counter++;
				  #print "counter".$counter."\t";
			      }
		      }
		      push(@values, $counter);
		      #print "waarde".$counter."\t";
		      $counter=0;
	      }
	      foreach my $li (@codonlist) {
		      my $val = shift(@values);
		      #print "value:".$val, "\t";
		      $codonocc{$li} = $val;
	      }
	      ###print all values and afterwards all keys of %codonocc###
	      my @codonkeys = keys(%codonocc);
	      my @codonvalues = values(%codonocc);
	      foreach my $thing (@codonvalues) {
		      #print "\t", $thing;
	      }
	      #print "\n";
	      foreach my $thing2 (@codonkeys) {
		      #print $thing2."\t";
	      }
	      #print "\n", "-"x90, "\n";
	      $genenr++;
	      push @geneList, \%codonocc; ###in which @geneList contains hash tables with codonoccurances.
      }
      return @geneList;
}

### generates one big hash table per species.
sub cat_hash(@) 
{
      my $n = 0;
      my @array = @_;
      my %total_hash;
      my $occurrance;
      my @hash_cont;
      foreach my $el (@array) {
	    my %ref_hash = %$el;
	    foreach my $cod (keys %ref_hash) { #key is codon
		  $occurrance = $ref_hash{$cod};
		  $total_hash{$cod} = $total_hash{$cod} + $occurrance; 
	    }
      }
      push @hash_cont, \%total_hash;
      return @hash_cont;
}

###counts the amount of amino acids per species data set. 
sub count_AAs(@) 
{
      my $n = 0;
      my $sum = 0;
      my @array = @_;### alias @genelijst###
      my $len_geneList= scalar(@array);
      while ($n < $len_geneList) {
	    my $ref_hash = shift @array;
	    my %AAs =( 
		    A => ["GCT","GCC","GCA","GCG"],	
		    L => ["TTA","TTG","CTT","CTC","CTA","CTG"],
		    R => ["CGT","CGC","CGA","CGG","AGA","AGG"],	
		    K => ["AAA","AAG"],
		    N => ["AAT","AAC"],	
		    M => ["ATG"],
		    D => ["GAT","GAC"], 	
		    F => ["TTT","TTC"],
		    C => ["TGT","TGC"],	
		    P => ["CCT","CCC","CCA","CCG"],
		    Q => ["CAA","CAG"], 	
		    S => ["TCT","TCC","TCA","TCG","AGT","AGC"],
		    E => ["GAA","GAG"],	
		    T => ["ACT","ACC","ACA","ACG"],
		    G => ["GGT","GGC","GGA","GGG"],	
		    W => ["TGG"],
		    H => ["CAT","CAC"],	
		    Y => ["TAT","TAC"],
		    I => ["ATT","ATC","ATA"],	
		    V => ["GTT","GTC","GTA","GTG"],	
		    "*" =>["TAA","TGA","TAG"] ###stop codon###
		    );
	    foreach my $AA (keys %AAs) { ###$AA is key of %AAs eg A
		  foreach my $c (@{$AAs{$AA}}) { ###$c is value from %AAs
			$sum += $ref_hash->{$c};
		  }
	    }	
	    $n++;
      }
      #print "Amount of AAs in this dataset: $sum \n";
      return $sum;
}

###counts for each amino acid the amount of codons per species data set normalized by 1000
sub AAcount($$$) 
{
	my $n = 0;###counts number of genes in fastafile###
	my @array = @{$_[0]};### alias @genelijst###
	my @seqheader = @{$_[1]};
	my $total_AAs =$_[2];
	my $total;
	my $tot_tot = 0;
	my $len_hash_container = scalar(@array);
	while ($n < $len_hash_container) {
		my $ref_hash = shift @array; ###$ref_hash is a reference of a hash 
		my $header = shift @seqheader;
		print "$header\n";
		my %AAs =( 
		      A => ["GCT","GCC","GCA","GCG"],	
		      L => ["TTA","TTG","CTT","CTC","CTA","CTG"],
		      R => ["CGT","CGC","CGA","CGG","AGA","AGG"],	
		      K => ["AAA","AAG"],
		      N => ["AAT","AAC"],	
		      M => ["ATG"],
		      D => ["GAT","GAC"], 	
		      F => ["TTT","TTC"],
		      C => ["TGT","TGC"],	
		      P => ["CCT","CCC","CCA","CCG"],
		      Q => ["CAA","CAG"], 	
		      S => ["TCT","TCC","TCA","TCG","AGT","AGC"],
		      E => ["GAA","GAG"],	
		      T => ["ACT","ACC","ACA","ACG"],
		      G => ["GGT","GGC","GGA","GGG"],	
		      W => ["TGG"],
		      H => ["CAT","CAC"],	
		      Y => ["TAT","TAC"],
		      I => ["ATT","ATC","ATA"],	
		      V => ["GTT","GTC","GTA","GTG"],	
		      "*" =>["TAA","TGA","TAG"] ###stop codon###
		);
		foreach my $AA (keys %AAs) { ###$AA is key of %AAs eg A
		      my $sum = 0;
		      foreach my $c (@{$AAs{$AA}}) { ###$c is value from %AAs
			      $sum += $ref_hash->{$c};
		      }
		      print "$AA|\t$sum"."\t|\t";
		      if ($sum != 0) {
			      foreach my $c (@{$AAs{$AA}}) {
				    printf "$c:%.3f\t", ($ref_hash->{$c}/$total_AAs)*1000;
			      }
			      print "\n";
		      }
		      else { ###corrects for the codons which don't occur (can't devide by 0)##
			      foreach my $c (@{$AAs{$AA}}) {
				    printf "$c:%.3f\t", $ref_hash->{$c};###prints non occuring triplets with value(=0)##
			      }
			      print "\n";
		      }
		}
		$n++;
	}
}  
