#############################################################################
#                                                                           #
#                                  Osc.pm                                   #
#                                                                           #
#  A collection of different digital oscillators implemented in pure Perl.  #
#                                                                           #
#                      Copyright (c) 2019, Barry Pierce                     #
#                                                                           #
#############################################################################
package Osc;
use strict;
use warnings;

use Carp 'croak';
use base 'Exporter';

our @EXPORT_OK = qw(make_sine_osc);

use constant PI    => 3.1415926535897932;
use constant TWOPI => 2 * PI;


sub make_sine_osc {
    croak 'missing $vec_siz argument' if @_ < 1;
    my ($vec_siz, $samp_rate) = @_;
    
    $samp_rate //= 44100;
    
    if ($vec_siz < 1) {
        croak '$vec_siz must be a postive integer value';
    }
    elsif ($samp_rate < 1) {
        croak '$samp_rate must be a postive integer value';
    }
    
    my $freq  = 0;
    my $phase = 0;
    my $incr  = 0;
    my $two_pi_ovr_sr = TWOPI / $samp_rate;
    
    return sub {
        my ($req_freq, $amp) = @_;
        
        my @vec;
        for (1 .. $vec_siz) {
            if ($freq != $req_freq) {
                $freq = $req_freq;
                $incr = $two_pi_ovr_sr * $req_freq;
            }
            
            push @vec, $amp * sin $phase;
            $phase += $incr;
            
            if ($phase >= TWOPI) {
                $phase -= TWOPI;
            } 
            
            if ($phase < 0) {
                $phase += TWOPI;
            }
        }
        
        return wantarray ? @vec : $vec[0];
    } 
}


1;