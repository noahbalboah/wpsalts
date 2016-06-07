#/bin/bash

user=`pwd|cut -d / -f 3`
file=wp-config.php

if [ ! -f $file ];
	then
        	echo "No config file found!" ; exit
fi

if fgrep -q "define('AUTH_KEY'," $file;
        then
        	echo "Changing salts. Stand by.";
                 perl -ne '
                 BEGIN {
                     $keysalts = qx(curl -sS https://api.wordpress.org/secret-key/1.1/salt)
                    }
                         if ( $flipflop = ( m/AUTH_KEY/ .. m/NONCE_SALT/ ) ) {
                         if ( $flipflop =~ /E0$/ ) {
                         printf qq|%s|, $keysalts;
                    }      
                         next;
                         }              
                         printf qq|%s|, $_;' $file > wp-config2.php;

                mv wp-config2.php $file;
                chown $user. $file;
                chmod 644 $file;

         else
                echo "NO SALTS FOUND! Appending new salts to wp-config.php.";
                 curl -sS https://api.wordpress.org/secret-key/1.1/salt >> $file;
		 chown $user. $file;
                 chmod 644 $file;
fi
